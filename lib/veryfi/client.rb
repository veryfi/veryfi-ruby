# frozen_string_literal: true

module Veryfi
  # The user-facing entry point.
  #
  # @example Basic usage
  #   client = Veryfi::Client.new(
  #     client_id:     ENV["VERYFI_CLIENT_ID"],
  #     client_secret: ENV["VERYFI_CLIENT_SECRET"],
  #     username:      ENV["VERYFI_USERNAME"],
  #     api_key:       ENV["VERYFI_API_KEY"]
  #   )
  #   client.document.process(file_path: "./receipt.jpg")
  #
  # @example Custom Faraday configuration (persistent connections + retries)
  #   client = Veryfi::Client.new(
  #     client_id:     "…",
  #     client_secret: "…",
  #     username:      "…",
  #     api_key:       "…",
  #     faraday: ->(conn) {
  #       conn.request  :retry, max: 3, interval: 0.5, backoff_factor: 2,
  #                             retry_statuses: [429, 502, 503, 504]
  #       conn.response :logger, Rails.logger if defined?(Rails)
  #       conn.adapter  :net_http_persistent
  #     }
  #   )
  class Client
    # DSL: declare an API namespace as a lazily-memoized reader.
    #
    # @example
    #   api_namespace :document, Veryfi::Api::Document
    #
    # @param name [Symbol]
    # @param klass [Class] API class accepting a `Veryfi::Request` in its constructor
    # @return [void]
    def self.api_namespace(name, klass)
      ivar = :"@_#{name}"
      define_method(name) do
        instance_variable_get(ivar) || instance_variable_set(ivar, klass.new(request))
      end
    end

    attr_reader :request

    def initialize(
      client_id:,
      client_secret:,
      username:,
      api_key:,
      base_url: "https://api.veryfi.com/api/",
      api_version: "v8",
      timeout: 30,
      faraday: nil
    )
      @request = Veryfi::Request.new(
        client_id, client_secret, username, api_key,
        base_url, api_version, timeout, faraday
      )
    end

    api_namespace :document,             Veryfi::Api::Document
    api_namespace :line_item,            Veryfi::Api::LineItem
    api_namespace :tax_line,             Veryfi::Api::TaxLine
    api_namespace :tag,                  Veryfi::Api::Tag
    api_namespace :document_tag,         Veryfi::Api::DocumentTag
    api_namespace :any_document,         Veryfi::Api::AnyDocument
    api_namespace :bank_statement,       Veryfi::Api::BankStatement
    api_namespace :bank_statement_split, Veryfi::Api::BankStatementSplit
    api_namespace :business_card,        Veryfi::Api::BusinessCard
    api_namespace :check,                Veryfi::Api::Check
    api_namespace :classify,             Veryfi::Api::Classify
    api_namespace :pdf_split,            Veryfi::Api::PdfSplit
    api_namespace :w2,                   Veryfi::Api::W2
    api_namespace :w2_split,             Veryfi::Api::W2Split
    api_namespace :w8,                   Veryfi::Api::W8
    api_namespace :w9,                   Veryfi::Api::W9

    def api_url
      request.api_url
    end
  end
end
