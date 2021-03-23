require "rails_helper"

describe ParallelFetcher do
  subject { described_class.call(**params) }

  context "when params are invalid" do
    let(:params) { {} }
    it "has proper errors" do
      expect(subject.failure[:errors]).to eq(urls: ["is missing"])
    end
    it "returns failure" do
      expect(subject).to be_failure
    end
  end

  context "when params are valid" do
    let(:json_response) do
      [
        {
          "username": "@GuyEndoreKaiser",
          "tweet": "If you live to be 100.."
        }
      ]
    end
    let(:string_response) { "I am trapped in a social media.." }
    let(:url) { "http://example.com/a" }
    let(:params) { {urls: [url]} }
    let(:first_error) { ->(key) { subject.value!.dig(:results, key, 0, :error) } }

    context "when url returns valid response" do
      before do
        stub_request(:get, url)
          .to_return(status: 200, body: json_response.to_json, headers: {})
      end

      it "returns proper response" do
        expect(subject).to be_success
        expect(subject.value![:results]["a"]).to eq(json_response)
      end
    end

    context "when url returns invalid response" do
      before do
        stub_request(:get, url)
          .to_return(status: 200, body: string_response, headers: {})
      end

      it "returns proper response" do
        expect(subject).to be_success
        expect(first_error["a"]).to match(/JSON string is not valid/)
      end
    end

    context "when url loads too long" do
      before do
        stub_request(:get, url).to_timeout
      end

      it "returns proper response" do
        expect(subject).to be_success
        expect(first_error["a"]).to match(/is not accessible for now/)
      end
    end

    context "when url not found" do
      before do
        stub_request(:get, url).to_return(status: 404, body: "404 page not found")
      end

      it "returns proper response" do
        expect(subject).to be_success
        expect(first_error["a"]).to match(/is not accessible for now/)
      end
    end

    context "when all urls have issues" do
      let(:url_1) { "http://example.com/a" }
      let(:url_2) { "http://example.com/b" }
      let(:url_3) { "http://example.com/c" }
      let(:params) { {urls: [url_1, url_2, url_3]} }

      before do
        stub_request(:get, url_1).to_timeout
        stub_request(:get, url_2).to_return(status: 200, body: string_response)
        stub_request(:get, url_3).to_return(status: 404, body: "404 page not found")
      end

      it "returns proper response" do
        expect(subject).to be_success
        expect(first_error["a"]).to match(/is not accessible for now/)
        expect(first_error["b"]).to match(/JSON string is not valid/)
        expect(first_error["c"]).to match(/is not accessible for now/)
      end
    end
  end
end
