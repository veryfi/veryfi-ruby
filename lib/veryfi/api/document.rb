# frozen_string_literal: true

require "base64"

module Veryfi
  module Api
    # Receipts & invoices endpoints (`/partner/documents/`).
    #
    # @see https://docs.veryfi.com/api/receipts-invoices/
    class Document
      # Default categories sent with `process` / `process_url` when the
      # caller does not supply their own `:categories` list. Veryfi will
      # bucket the document into one of these values for the `category`
      # field on the response.
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

      # List previously processed documents.
      #
      # @see https://docs.veryfi.com/api/receipts-invoices/search-documents/
      #
      # @param params [Hash] query-string parameters (all optional)
      # @option params [String]  :q              free-text search query
      # @option params [String]  :external_id    filter by your own document id
      # @option params [String]  :tag            filter by tag name
      # @option params [String]  :created__gt    "YYYY-MM-DD HH:MM:SS" — strictly after
      # @option params [String]  :created__gte   "YYYY-MM-DD HH:MM:SS" — after or equal
      # @option params [String]  :created__lt    "YYYY-MM-DD HH:MM:SS" — strictly before
      # @option params [String]  :created__lte   "YYYY-MM-DD HH:MM:SS" — before or equal
      # @option params [Integer] :page           1-indexed page number (default 1)
      # @option params [Integer] :page_size      items per page (default 50)
      #
      # @return [Veryfi::Resource] `{ "documents" => [...] }`
      def all(params = {})
        request.get("/partner/documents/", params)
      end

      # Upload a local file and extract its data.
      #
      # Required:
      #   * `:file_path` — path on disk to the file to process.
      #
      # All other keys below are optional. **Omitting a key is equivalent to
      # passing its default value** — both produce the same API call. Pass a
      # key explicitly only when you want a non-default value or when you
      # want to make the intent explicit in your code.
      #
      # @see https://docs.veryfi.com/api/receipts-invoices/process-a-document/
      #
      # @param raw_params [Hash]
      # @option raw_params [String]        :file_path   **required.** Local path to the file.
      # @option raw_params [String]        :file_name   (basename of `:file_path`, extension stripped)
      #   Display name sent to Veryfi.
      # @option raw_params [Array<String>] :categories  ({CATEGORIES})
      #   Restrict Veryfi's categorization to this set.
      # @option raw_params [Array<String>] :tags        (`nil`)
      #   Tags to attach to the resulting document.
      # @option raw_params [Boolean]       :auto_delete (`false`)
      #   If true, delete from Veryfi storage right after extraction.
      # @option raw_params [Boolean]       :boost_mode  (`false`)
      #   Skip data enrichment for faster, less-accurate processing.
      # @option raw_params [Boolean]       :async       (`false`)
      #   Return immediately; the document keeps processing server-side.
      #   Prefer the dedicated async endpoint where available.
      # @option raw_params [String]        :external_id (`nil`)
      #   Your own identifier to associate with the document.
      # @option raw_params [Integer]       :max_pages_to_process (`nil` = all pages)
      #   Cap pages read, starting from page 1.
      # @option raw_params [Hash]          :bounding_boxes     (`false`)
      #   Return bounding-box info for extracted fields.
      # @option raw_params [Hash]          :confidence_details (`false`)
      #   Return confidence score details.
      # @option raw_params [String]        :thinking           (`nil`)
      #   Extra LLM pass on the line items: `"light"` or `"deep"` (slower).
      #   Omit to turn it off. Needs thinking mode enabled for your account.
      #
      # @return [Veryfi::Resource] Extracted document data.
      def process(raw_params)
        params = setup_create_params(raw_params)

        file_content = File.read(params[:file_path])
        file_data = Base64.encode64(file_content).gsub("\n", "")
        file_name = params[:file_name] || File.basename(params[:file_path], ".*")

        payload = params.reject { |k| k == :file_path }.merge(
          file_name: file_name,
          file_data: file_data
        )

        request.post("/partner/documents/", payload)
      end

      # Process a document from a public URL.
      #
      # Either `:file_url` (single) or `:file_urls` (multiple, processed as
      # one logical document) must be present. All other params behave the
      # same as in {#process}.
      #
      # @see https://docs.veryfi.com/api/receipts-invoices/process-a-document/
      #
      # @param raw_params [Hash]
      # @option raw_params [String]         :file_url    publicly accessible URL to a single file
      # @option raw_params [Array<String>]  :file_urls   list of publicly accessible URLs
      # @option raw_params [Array<String>]  :categories  ({CATEGORIES})
      # @option raw_params [Array<String>]  :tags        (`nil`)
      # @option raw_params [Boolean]        :auto_delete (`false`)
      # @option raw_params [Boolean]        :boost_mode  (`false`)
      # @option raw_params [Boolean]        :async       (`false`)
      # @option raw_params [String]         :external_id (`nil`)
      # @option raw_params [Integer]        :max_pages_to_process (`nil` = all pages)
      # @option raw_params [String]         :thinking    (`nil`) `"light"` or `"deep"`, see {#process}
      #
      # @return [Veryfi::Resource]
      def process_url(raw_params)
        params = setup_create_params(raw_params)

        request.post("/partner/documents/", params)
      end

      # Bulk-process many documents from URLs in a single call.
      #
      # @see https://docs.veryfi.com/api/receipts-invoices/bulk-process-multiple-documents/
      # @note This endpoint must be enabled for your account. Contact support@veryfi.com.
      #
      # @param file_urls [Array<String>] publicly accessible URLs
      # @return [Veryfi::Resource] `{ "document_ids" => [...] }`
      def process_bulk(file_urls)
        request.post("/partner/documents/bulk/", file_urls: file_urls)
      end

      # Fetch a single document by id.
      #
      # @see https://docs.veryfi.com/api/receipts-invoices/get-a-document/
      #
      # @param id [Integer] document id
      # @param params [Hash] query-string parameters (all optional)
      # @option params [Boolean] :bounding_boxes      (`false`) Include bounding boxes in the response.
      # @option params [Boolean] :confidence_details  (`false`) Include per-field confidence scores.
      #
      # @return [Veryfi::Resource]
      def get(id, params = {})
        request.get("/partner/documents/#{id}", params)
      end

      # Update writable fields on a previously processed document.
      #
      # @example
      #   client.document.update(44_691_518, date: "2021-01-01", notes: "look what I did")
      #
      # @see https://docs.veryfi.com/api/receipts-invoices/update-a-document/
      #
      # @param id [Integer] document id
      # @param params [Hash] any writable fields you want to change
      # @return [Veryfi::Resource] the updated document
      def update(id, params)
        request.put("/partner/documents/#{id}", params)
      end

      # Delete a document.
      #
      # @see https://docs.veryfi.com/api/receipts-invoices/delete-a-document/
      #
      # @param id [Integer]
      # @return [Veryfi::Resource] `{ "status" => "ok", "message" => "..." }`
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
