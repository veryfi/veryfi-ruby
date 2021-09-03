# frozen_string_literal: true

module Veryfi
  module Api
    class DocumentTag
      attr_reader :request

      def initialize(request)
        @request = request
      end

      def all(document_id, params = {})
        response = request.get("/partner/documents/#{document_id}/tags/", params)

        response["tags"]
      end

      def add(document_id, params)
        request.put("/partner/documents/#{document_id}/tags/", params)
      end

      def delete_all(document_id)
        request.delete("/partner/documents/#{document_id}/tags/")
      end

      def delete(document_id, id)
        request.delete("/partner/documents/#{document_id}/tags/#{id}")
      end
    end
  end
end
