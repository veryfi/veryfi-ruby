# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Tag API" do
  include_context :with_veryfi_client

  let(:tags_fixture) { File.read("spec/fixtures/tags.json") }
  let(:tags) { JSON.parse(tags_fixture)["tags"] }

  let(:document_id) { 38_947_300 }
  let(:base_url) { "https://api.veryfi.com/api/v7/partner" }

  describe "tag.all" do
    before do
      stub_request(:get, "#{base_url}/tags/").to_return(
        body: tags_fixture
      )
    end

    it "can fetch document tags" do
      response = client.tag.all

      expect(response[0]["name"]).to eq("foo")
    end
  end

  describe "tag.delete(id)" do
    before do
      stub_request(:delete, "#{base_url}/tags/75788890").to_return(
        body: { status: "ok", message: "Tag has been deleted" }.to_json
      )
    end

    it "can delete tag from document by tag id" do
      response = client.tag.delete(75_788_890)

      expect(response["message"]).to eq("Tag has been deleted")
    end
  end
end
