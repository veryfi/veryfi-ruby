# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Document API" do
  include_context :with_veryfi_client

  let(:documents_fixture) { response_fixture_body("documents/list") }
  let(:documents) { JSON.parse(documents_fixture)["documents"] }

  it { expect(client.api_url).to eq "https://api.veryfi.com/api/v8" }

  describe "document.all" do
    before do
      stub_request(:get, "https://api.veryfi.com/api/v8/partner/documents/").to_return(
        body: documents_fixture
      )
    end

    it "can fetch documents" do
      response = client.document.all

      expect(response["documents"][0]["id"]).to eq(44_691_518)
    end

    it "returns a Veryfi::Resource supporting attribute-style access" do
      response = client.document.all

      expect(response).to be_a(Veryfi::Resource)
      expect(response.documents.first.id).to eq(44_691_518)
      expect(response.documents.first.vendor.name).to be_a(String)
    end
  end

  describe "document.process(id, params)" do
    before do
      stub_request(:post, "https://api.veryfi.com/api/v8/partner/documents/").to_return(
        body: documents[0].to_json
      )
    end

    let(:document_params) do
      {
        file_path: file_fixture_path("receipt.jpg"),
        auto_delete: true,
        boost_mode: true,
        async: false,
        external_id: "123456789",
        max_pages_to_process: 10,
        tags: [
          "tag1"
        ],
        categories: [
          "Advertising & Marketing",
          "Automotive"
        ]
      }
    end

    let(:expected_file_data) { receipt_file_data }

    let(:expected_document_params) do
      {
        file_name: "receipt",
        file_data: expected_file_data,
        auto_delete: true,
        boost_mode: true,
        async: false,
        external_id: "123456789",
        max_pages_to_process: 10,
        tags: ["tag1"],
        categories: [
          "Advertising & Marketing",
          "Automotive"
        ]
      }
    end

    it "can process document" do
      expect_any_instance_of(Veryfi::Request).to receive(:post).with(
        "/partner/documents/",
        expected_document_params
      ).and_call_original

      response = client.document.process(document_params)

      expect(response["id"]).to eq(44_691_518)
    end

    %w[light deep].each do |mode|
      it "sends thinking=#{mode}" do
        client.document.process(document_params.merge(thinking: mode))

        expect(
          a_request(:post, "https://api.veryfi.com/api/v8/partner/documents/")
            .with { |req| JSON.parse(req.body)["thinking"] == mode }
        ).to have_been_made.once
      end
    end

    it "does not send thinking when omitted" do
      client.document.process(document_params)

      expect(
        a_request(:post, "https://api.veryfi.com/api/v8/partner/documents/")
          .with { |req| !JSON.parse(req.body).key?("thinking") }
      ).to have_been_made.once
    end
  end

  describe "document.process_url(id, params)" do
    before do
      stub_request(:post, "https://api.veryfi.com/api/v8/partner/documents/").to_return(
        body: documents[0].to_json
      )
    end

    let(:document_params) do
      {
        file_name: "invoice.png",
        file_url: "https://raw.githubusercontent.com/veryfi/veryfi-python/master/tests/assets/receipt_public.jpg",
        file_urls: [
          "https://raw.githubusercontent.com/veryfi/veryfi-python/master/tests/assets/receipt_public.jpg"
        ],
        auto_delete: true,
        boost_mode: true,
        async: false,
        external_id: "123456789",
        max_pages_to_process: 10,
        tags: [
          "tag1"
        ],
        categories: [
          "Advertising & Marketing",
          "Automotive"
        ]
      }
    end

    it "can process document from url" do
      response = client.document.process_url(document_params)

      expect(response["id"]).to eq(44_691_518)
    end

    %w[light deep].each do |mode|
      it "sends thinking=#{mode}" do
        client.document.process_url(document_params.merge(thinking: mode))

        expect(
          a_request(:post, "https://api.veryfi.com/api/v8/partner/documents/")
            .with { |req| JSON.parse(req.body)["thinking"] == mode }
        ).to have_been_made.once
      end
    end

    it "does not send thinking when omitted" do
      client.document.process_url(document_params)

      expect(
        a_request(:post, "https://api.veryfi.com/api/v8/partner/documents/")
          .with { |req| !JSON.parse(req.body).key?("thinking") }
      ).to have_been_made.once
    end
  end

  describe "document.get(id)" do
    before do
      stub_request(:get, "https://api.veryfi.com/api/v8/partner/documents/44691518").to_return(
        body: documents[0].to_json
      )
    end

    it "can fetch document by id" do
      response = client.document.get(44_691_518)

      expect(response["id"]).to eq(44_691_518)
    end
  end

  describe "document.update(id, params)" do
    before do
      stub_request(:put, "https://api.veryfi.com/api/v8/partner/documents/44691518").to_return(
        body: documents[0].merge(discount: 0.9).to_json
      )
    end

    it "can update document" do
      response = client.document.update(44_691_518, discount: 0.9)

      expect(response["id"]).to eq(44_691_518)
      expect(response["discount"]).to eq(0.9)
    end
  end

  describe "document.delete(id)" do
    before do
      stub_request(:delete, "https://api.veryfi.com/api/v8/partner/documents/44691518").to_return(
        body: { status: "ok", message: "Document has been deleted" }.to_json
      )
    end

    it "can fetch document by id" do
      response = client.document.delete(44_691_518)

      expect(response["message"]).to eq("Document has been deleted")
    end
  end

  describe "document.process_bulk(file_urls)" do
    before do
      stub_request(:post, "https://api.veryfi.com/api/v8/partner/documents/bulk/").to_return(
        body: { document_ids: [1, 2] }.to_json
      )
    end

    let(:file_urls) do
      %w[
        https://cdn.example.com/receipt1.jpg
        https://cdn.example.com/receipt2.jpg
      ]
    end

    it "submits the urls in a single bulk request" do
      expect_any_instance_of(Veryfi::Request).to receive(:post).with(
        "/partner/documents/bulk/",
        file_urls: file_urls
      ).and_call_original

      response = client.document.process_bulk(file_urls)

      expect(response["document_ids"]).to eq([1, 2])
    end
  end
end
