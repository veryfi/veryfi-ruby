# frozen_string_literal: true

require "spec_helper"

RSpec.describe Veryfi::Request do
  include_context :with_veryfi_client

  describe "request headers" do
    let(:expected_headers) do
      {
        "User-Agent": "Ruby Veryfi-Ruby/#{Veryfi::VERSION}",
        Accept: "application/json",
        "Content-Type": "application/json",
        "Client-Id": "fBvJLm1zCJ8Doxf94mMrpbrkDp8nr",
        Authorization: "apikey john_doe:123456"
      }
    end

    it "adds necessary headers to the request" do
      stub_request(:get, "https://api.veryfi.com/api/v8/partner/documents/")
        .with(headers: expected_headers)
        .to_return(body: [{ id: 1 }].to_json)

      response = client.document.all

      expect(response).to contain_exactly({ "id" => 1 })
    end
  end

  context "when server responds with 400 error" do
    before do
      stub_request(:get, /\.*/).to_return(status: 400, body: '{"code": 400, "error": "Bad Request"}')
    end

    let(:expected_error) do
      <<~TEXT.chomp
        {
          "code": 400,
          "error": "Bad Request"
        }
      TEXT
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::VeryfiError,
        expected_error
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
      <<~TEXT.chomp
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
      TEXT
    end

    it "raises error" do
      expect { client.document.all }.to raise_error(
        Veryfi::Error::VeryfiError
      ) { |error|
        expect(error.to_s).to eq(expected_error)
      }
    end
  end

  describe "stale connection recovery" do
    let(:request) do
      described_class.new("cid", nil, "u", "k", "https://api.veryfi.com/api/", "v8", 30)
    end

    let(:endpoint) { "https://api.veryfi.com/api/v8/partner/documents/" }

    it "retries once after a closed-socket ReadTimeout" do
      stub_request(:get, endpoint)
        .to_raise(Faraday::TimeoutError.new("Net::ReadTimeout with #<TCPSocket:(closed)>")).then
        .to_return(status: 200, body: '[{"id":1}]')

      expect { request.get("/partner/documents/") }.not_to raise_error
    end

    it "re-raises Faraday::TimeoutError when the socket is not closed" do
      stub_request(:get, endpoint)
        .to_raise(Faraday::TimeoutError.new("execution expired"))

      expect { request.get("/partner/documents/") }.to raise_error(Faraday::TimeoutError, /execution expired/)
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
end
