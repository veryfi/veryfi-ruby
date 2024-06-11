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

    let(:expected_error) do
      <<-TEXT.strip_heredoc.chomp
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
      <<-TEXT.strip_heredoc.chomp
        {
          "code": 400,
          "error": "Bad Request",
          "details": [
            {
              "type": "value_error",
              "loc": [

              ],
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
