require "open-uri"

# Please don't be scared with dry-transaction 🙈

# Getting resources in parallel manner.
class ParallelFetcher < RootService
  include Dry::Transaction

  THREADS_NUMBER = 3
  OPEN_TIMEOUT = 5
  READ_TIMEOUT = 10
  DEFAULT_URLS = %w[
    https://takehome.io/twitter
    https://takehome.io/facebook
    https://takehome.io/instagram
  ].freeze

  class Contract < RootContract
    params do
      required(:urls).filled { each { filled? } }
    end

    rule(:urls).each do
      key.failure("Url #{value} is not valid") unless value&.match?(URI::DEFAULT_PARSER.make_regexp)
    end
  end

  # If you not familiar with dry-transacton, that's a pipeline with 3 steps
  step :validate_input
  map :fetch_responses
  map :proccess_responses

  # I understand that input validation for such simple task is not required,
  # but I decided to show how I usually write complex services on daily basis
  def validate_input(input)
    Contract.validate_input(input)
  end

  def fetch_responses(input)
    responses = {}
    Parallel.each(input[:urls], in_threads: THREADS_NUMBER) do |url|
      responses[url_key(url)] = begin
        make_request(url)
      rescue => e
        log_error(e.message)
        {error: error_message(:url_not_accessible, url: url)}
      end
    end
    input.merge(responses: responses)
  end

  def proccess_responses(input)
    results = {}
    input[:responses].each do |url_key, response|
      results[url_key] = response.is_a?(String) ? json_parse(response) : response
    end
    input.merge(results: results)
  end

  private

  def make_request(url)
    URI.open(url, read_timeout: READ_TIMEOUT, open_timeout: OPEN_TIMEOUT).read
  end

  def json_parse(string)
    JSON.parse(string, symbolize_names: true)
  rescue => e
    log_error(e.message)
    {error: error_message(:json_parse_failure, json: string)}
  end

  def error_message(key, **attrs)
    I18n.t("services.parallel_fetcher.errors.#{key}", attrs)
  end

  def log_error(err)
    Rails.logger.error("-> ERROR: #{err}")
  end

  def url_key(url)
    url.split("/").last
  end
end
