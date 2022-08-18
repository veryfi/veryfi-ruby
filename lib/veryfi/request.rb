# frozen_string_literal: true

require "date"
require "faraday"
require "json"

module Veryfi
  class Request
    attr_reader :client_id, :client_secret, :username, :api_key, :base_url, :api_version, :timeout

    VERBS_WITH_BODIES = %i[post put].freeze

    def initialize(
      client_id,
      client_secret,
      username,
      api_key,
      base_url,
      api_version,
      timeout
    )
      @client_id = client_id
      @client_secret = client_secret
      @username = username
      @api_key = api_key
      @base_url = base_url
      @api_version = api_version
      @timeout = timeout
    end

    def get(path, params = {})
      make_request(:get, path, params)
    end

    def put(path, params)
      make_request(:put, path, params)
    end

    def post(path, params)
      make_request(:post, path, params)
    end

    def delete(path)
      make_request(:delete, path)
    end

    def api_url
      @_api_url ||= [base_url, api_version].join
    end

    private

    def make_request(http_verb, path, params = {})
      url = [api_url, path].join
      body = generate_body(http_verb, params)
      headers = generate_headers(params)

      response = conn.public_send(http_verb, url, body, headers)
      json_response = process_response(response)

      if response.success?
        json_response
      else
        raise Veryfi::Error.from_response(response.status, json_response)
      end
    end

    def conn
      @_conn ||= Faraday.new do |conn|
        conn.options.timeout = timeout
      end
    end

    def generate_body(http_verb, params)
      return params unless VERBS_WITH_BODIES.include?(http_verb)

      params.to_json
    end

    def generate_headers(params = {})
      return default_headers if client_secret.nil?

      timestamp = DateTime.now.strftime("%Q")
      signature = generate_signature(params, timestamp)

      default_headers.merge(
        "X-Veryfi-Request-Timestamp": timestamp,
        "X-Veryfi-Request-Signature": signature
      )
    end

    def default_headers
      {
        "User-Agent": "Ruby Veryfi-Ruby/#{Veryfi::VERSION}",
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Client-Id": client_id,
        "Authorization": "apikey #{username}:#{api_key}"
      }
    end

    def generate_signature(params, timestamp)
      Veryfi::Signature.new(client_secret, params, timestamp).to_base64
    end

    def process_response(response)
      return {} if response.body.empty?

      JSON.parse(response.body)
    end
  end
end
