# frozen_string_literal: true

module Veryfi
  class Client
    attr_reader :request

    def initialize(
      client_id:,
      client_secret:,
      username:,
      api_key:,
      base_url: "https://api.veryfi.com/api/",
      api_version: "v7",
      timeout: 20
    )
      @request = Veryfi::Request.new(client_id, client_secret, username, api_key, base_url, api_version, timeout)
    end

    def document
      @_document ||= Veryfi::Api::Document.new(request)
    end

    def line_item
      @_line_item ||= Veryfi::Api::LineItem.new(request)
    end

    def tag
      @_tag ||= Veryfi::Api::Tag.new(request)
    end

    def document_tag
      @_document_tag ||= Veryfi::Api::DocumentTag.new(request)
    end

    def api_url
      request.api_url
    end
  end
end
