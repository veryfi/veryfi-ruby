# frozen_string_literal: true

require "date"
require "faraday"
require "json"

module Veryfi
  # Low-level HTTP layer used by every API class. You typically don't need
  # to interact with this directly — go through {Veryfi::Client} instead.
  #
  # Custom Faraday configuration (adapter, retries, logging, persistent
  # connections, …) can be supplied via the `faraday:` block when
  # constructing the client. The block receives the `Faraday::Connection`
  # before it's frozen, so you can attach any middleware you want.
  class Request
    attr_reader :client_id, :client_secret, :username, :api_key,
                :base_url, :api_version, :timeout, :faraday_block

    VERBS_WITH_BODIES = %i[post put].freeze

    def initialize(
      client_id,
      client_secret,
      username,
      api_key,
      base_url,
      api_version,
      timeout,
      faraday_block = nil
    )
      @client_id = client_id
      @client_secret = client_secret
      @username = username
      @api_key = api_key
      @base_url = base_url
      @api_version = api_version
      @timeout = timeout
      @faraday_block = faraday_block
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
      response = attempt_request(http_verb, url, body, headers)
      json_response = process_response(response)

      if response.success?
        json_response
      else
        raise Veryfi::Error.from_response(response.status, json_response)
      end
    end

    def attempt_request(http_verb, url, body, headers)
      conn.public_send(http_verb, url, body, headers)
    rescue Faraday::TimeoutError => e
      raise unless e.message.include?("closed")

      @_conn = nil
      conn.public_send(http_verb, url, body, headers)
    end

    def conn
      @_conn ||= Faraday.new do |conn|
        conn.options.timeout = timeout
        faraday_block&.call(conn)
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
        "X-Veryfi-Request-Timestamp" => timestamp,
        "X-Veryfi-Request-Signature" => signature
      )
    end

    def default_headers
      {
        "User-Agent" => "Ruby Veryfi-Ruby/#{Veryfi::VERSION}",
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Client-Id" => client_id,
        "Authorization" => "apikey #{username}:#{api_key}"
      }
    end

    def generate_signature(params, timestamp)
      Veryfi::Signature.new(client_secret, params, timestamp).to_base64
    end

    def process_response(response)
      return Veryfi::Resource.new if response.body.empty?

      Veryfi::Resource.wrap(JSON.parse(response.body))
    end
  end
end
