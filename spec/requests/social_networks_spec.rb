require "rails_helper"

RSpec.describe "SocialNetworks", type: :request do
  describe "GET /" do
    before do
      stub_request(:get, /https:\/\/takehome.io*/)
    end

    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end

    it "returns failure when passed invalid url" do
      get "/?urls[]=invalid_url"
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns failure when passed empty url" do
      get "/?urls[]="
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
