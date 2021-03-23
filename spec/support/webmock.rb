require "webmock/rspec/matchers"

RSpec.configure do |config|
  config.include WebMock::API
  config.include WebMock::Matchers

  config.before(:suite) do
    WebMock.enable!
    WebMock.disable_net_connect!(
      allow_localhost: true
    )
  end

  config.after(:suite) do
    WebMock.reset!
    WebMock.disable!
  end
end
