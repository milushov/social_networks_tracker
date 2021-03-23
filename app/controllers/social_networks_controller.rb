class SocialNetworksController < ApplicationController
  def track
    ParallelFetcher.call(urls: urls_params) do |monad|
      monad.success { |result| render json: result[:results] }
      monad.failure { |result| render json: result[:errors], status: :unprocessable_entity }
    end
  end

  private

  # It's not required, but I decided to make this app more general,
  # so it could handle any passed links
  def urls_params
    params.permit(urls: []).dig(:urls) || ParallelFetcher::DEFAULT_URLS
  end
end
