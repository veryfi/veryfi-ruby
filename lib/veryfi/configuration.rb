# frozen_string_literal: true

module Veryfi
  # Process-wide settings used by {Veryfi.client} to build the shared
  # singleton client. Mirrors the keyword arguments of
  # {Veryfi::Client#initialize}; defaults match the client's defaults.
  class Configuration
    ATTRS = %i[
      client_id client_secret username api_key
      base_url api_version timeout faraday
    ].freeze

    attr_accessor(*ATTRS)

    def initialize
      @base_url    = "https://api.veryfi.com/api/"
      @api_version = "v8"
      @timeout     = 30
    end

    # @return [Hash] the configuration as a keyword-arg-ready Hash. Keys
    #   with `nil` values are still included; {Veryfi.client} calls
    #   `.compact` before passing it to {Veryfi::Client#initialize}.
    def to_h
      ATTRS.to_h { |attr| [attr, public_send(attr)] }
    end
  end
end
