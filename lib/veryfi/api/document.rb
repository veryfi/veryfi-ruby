# frozen_string_literal: true

require "base64"

module Veryfi
  module Api
    class Document
      CATEGORIES = [
        "Advertising & Marketing",
        "Automotive",
        "Bank Charges & Fees",
        "Legal & Professional Services",
        "Insurance",
        "Meals & Entertainment",
        "Office Supplies & Software",
        "Taxes & Licenses",
        "Travel",
        "Rent & Lease",
        "Repairs & Maintenance",
        "Payroll",
        "Utilities",
        "Job Supplies",
        "Grocery"
      ].freeze

      attr_reader :request

      def initialize(request)
        @request = request
      end

      def all(params = {})
        response = request.get("/partner/documents/", params)

        response.is_a?(Hash) ? [response] : response
      end

      def process(raw_params)
        params = setup_create_params(raw_params)

        file_content = File.read(params[:file_path])
        file_data = Base64.encode64(file_content).gsub("\n", "")

        payload = params.reject { |k| k == :file_path }.merge(
          file_data: file_data
        )

        request.post("/partner/documents/", payload)
      end

      def process_url(raw_params)
        params = setup_create_params(raw_params)

        request.post("/partner/documents/", params)
      end

      def get(id, params = {})
        request.get("/partner/documents/#{id}", params)
      end

      def update(id, params)
        request.put("/partner/documents/#{id}", params)
      end

      def delete(id)
        request.delete("/partner/documents/#{id}")
      end

      private

      def setup_create_params(raw_params)
        params = raw_params.transform_keys(&:to_sym)

        params[:categories] = CATEGORIES if params[:categories].to_a.empty?

        params
      end
    end
  end
end
