# frozen_string_literal: true

require "spec_helper"

RSpec.describe "LineItem API" do
  include_context :with_veryfi_client

  let(:line_items_fixture) { File.read("spec/fixtures/line_items.json") }
  let(:line_items) { JSON.parse(line_items_fixture)["line_items"] }

  let(:document_id) { 38_947_300 }
  let(:base_url) { "https://api.veryfi.com/api/v8/partner/documents/#{document_id}" }

  describe "line_item.all(document_id)" do
    before do
      stub_request(:get, "#{base_url}/line-items/").to_return(
        body: line_items_fixture
      )
    end

    it "can fetch line_items" do
      response = client.line_item.all(document_id)

      expect(response[0]["id"]).to eq(101_170_751)
    end
  end

  describe "line_item.create(document_id, params)" do
    before do
      stub_request(:post, "#{base_url}/line-items/").to_return(
        body: line_items[0].to_json
      )
    end

    let(:line_item_params) do
      {
        "date": "",
        "description": "98 Meat Pty Xchz",
        "discount": 0,
        "end_date": "",
        "hsn": "",
        "order": 1,
        "price": 12.5,
        "quantity": 1,
        "reference": "",
        "section": "",
        "sku": "038902058959",
        "start_date": "",
        "tags": [
          {
            "id": 757_123,
            "name": "tag"
          }
        ],
        "tax": 7.66,
        "tax_rate": 7.66,
        "total": 88.2,
        "type": "food",
        "unit_of_measure": ""
      }
    end

    it "can create line item for a give document" do
      response = client.line_item.create(document_id, line_item_params)

      expect(response["id"]).to eq(101_170_751)
    end
  end

  describe "line_item.get(document_id, id)" do
    before do
      stub_request(:get, "#{base_url}/line-items/101170751").to_return(
        body: line_items[0].to_json
      )
    end

    it "can fetch line item by id" do
      response = client.line_item.get(document_id, 101_170_751)

      expect(response["id"]).to eq(101_170_751)
    end
  end

  describe "line_item.update(document_id, id, params)" do
    before do
      stub_request(:put, "#{base_url}/line-items/101170751").to_return(
        body: line_items[0].merge(discount: 0.9).to_json
      )
    end

    it "can update line item" do
      response = client.line_item.update(document_id, 101_170_751, discount: 0.9)

      expect(response["id"]).to eq(101_170_751)
      expect(response["discount"]).to eq(0.9)
    end
  end

  describe "line_item.delete(document_id, id)" do
    before do
      stub_request(:delete, "#{base_url}/line-items/101170751").to_return(
        body: { status: "ok", message: "Line item has been deleted" }.to_json
      )
    end

    it "can delete line item by id" do
      response = client.line_item.delete(document_id, 101_170_751)

      expect(response["message"]).to eq("Line item has been deleted")
    end
  end
end
