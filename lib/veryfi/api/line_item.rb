# frozen_string_literal: true

module Veryfi
  module Api
    class LineItem
      attr_reader :request

      def initialize(request)
        @request = request
      end

      def all(document_id, params = {})
        response = request.get("/partner/documents/#{document_id}/line-items/", params)
        response["line_items"]
      end

      def create(document_id, params)
        request.post("/partner/documents/#{document_id}/line-items/", params)
      end

      def get(document_id, id, params = {})
        request.get("/partner/documents/#{document_id}/line-items/#{id}", params)
      end

      def update(document_id, id, params)
        request.put("/partner/documents/#{document_id}/line-items/#{id}", params)
      end

      def delete(document_id, id)
        request.delete("/partner/documents/#{document_id}/line-items/#{id}")
      end
    end
  end
end
