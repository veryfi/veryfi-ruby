# frozen_string_literal: true

require "spec_helper"

RSpec.describe Veryfi::Request do
  include_context :with_veryfi_client

  describe "request headers" do
    let(:expected_headers) do
      {
        "User-Agent": "Ruby Veryfi-Ruby/#{Veryfi::VERSION}",
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Client-Id": "fBvJLm1zCJ8Doxf94mMrpbrkDp8nr",
        "Authorization": "apikey john_doe:123456"
      }
    end

    it "adds necessary headers to the request" do
      stub_request(:get, "https://api.veryfi.com/api/v7/partner/documents/")
        .with(headers: expected_headers)
        .to_return(body: [{ id: 1 }].to_json)

      response = client.document.all

      expect(response).to match_array([{ "id" => 1 }])
    end
  end

  context "when server responds with 400 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 400)
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::BadRequest,
        "Bad Request"
      )
    end
  end

  context "when server responds with 401 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 401)
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::UnauthorizedAccessToken,
        "Unauthorized Access Token"
      )
    end
  end

  context "when server responds with 405 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 405)
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::UnexpectedHTTPMethod,
        "Unexpected HTTP Method"
      )
    end
  end

  context "when server responds with 409 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 409)
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::AccessLimitReached,
        "Access Limit Reached"
      )
    end
  end

  context "when server responds with 500 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 500)
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::InternalError,
        "Internal Server Error"
      )
    end
  end
end
