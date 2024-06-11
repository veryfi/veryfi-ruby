# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext/string/strip"

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
      stub_request(:get, "https://api.veryfi.com/api/v8/partner/documents/")
        .with(headers: expected_headers)
        .to_return(body: [{ id: 1 }].to_json)

      response = client.document.all

      expect(response).to match_array([{ "id" => 1 }])
    end
  end

  context "when server responds with 400 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 400, body: '{"code": 400, "error": "Bad Request"}')
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::BadRequest,
        "400, Bad Request"
      )
    end
  end

  context "when server responds with 400 error and details" do
    before do
      stub_request(:get, /\.*/).to_return(
        status: 400,
        body: <<-JSON
          {
            "code": 400,
            "error": "Bad Request",
            "details": [
              {
                "type": "value_error",
                "loc": [],
                "msg": "Value error, Only one of ..."
              }
            ]
          }
        JSON
      )
    end

    let(:expected_error) do
      <<-TEXT.strip_heredoc.chomp
        400, Bad Request
        [
          {
            "type": "value_error",
            "loc": [

            ],
            "msg": "Value error, Only one of ..."
          }
        ]
      TEXT
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::BadRequest
      ) { |error|
        expect(error.to_s).to eq(expected_error)
      }
    end
  end

  context "when server responds with 401 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 401, body: '{"error": "Unauthorized Access Token"}')
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::UnauthorizedAccessToken,
        "401, Unauthorized Access Token"
      )
    end
  end

  context "when server responds with 404 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 404, body: '{"error": "Resource Not Found"}')
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::ResourceNotFound,
        "404, Resource not found"
      )
    end
  end

  context "when server responds with 405 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 405, body: '{"error": "Unexpected HTTP Method"}')
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::UnexpectedHTTPMethod,
        "405, Unexpected HTTP Method"
      )
    end
  end

  context "when server responds with 409 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 409, body: '{"error": "Access Limit Reached"}')
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::AccessLimitReached,
        "409, Access Limit Reached"
      )
    end
  end

  context "when server responds with 500 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 500, body: '{"error": "Internal Server Error"}')
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::InternalError,
        "500, Internal Server Error"
      )
    end
  end

  context "when server responds with empty body" do
    before do
      stub_request(:get, /\.*/).to_return(status: 501, body: "")
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::VeryfiError,
        "501"
      )
    end
  end

  context "when server responds with unknown error and body" do
    before do
      stub_request(:get, /\.*/).to_return(status: 504, body: '{"error": "Gateway Timeout"}')
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::VeryfiError,
        "504, Gateway Timeout"
      )
    end
  end
end
