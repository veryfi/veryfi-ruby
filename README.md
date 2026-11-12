# Veryfi SDK for Ruby

<img src="https://user-images.githubusercontent.com/30125790/212157461-58bdc714-2f89-44c2-8e4d-d42bee74854e.png#gh-dark-mode-only" width="200">
<img src="https://user-images.githubusercontent.com/30125790/212157486-bfd08c5d-9337-4b78-be6f-230dc63838ba.png#gh-light-mode-only" width="200">

[![Version](https://img.shields.io/gem/v/veryfi)](https://rubygems.org/gems/veryfi)
[![Test](https://github.com/veryfi/veryfi-ruby/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/veryfi/veryfi-ruby/actions/workflows/test.yml)
[![Coverage](https://raw.githubusercontent.com/veryfi/veryfi-ruby/main/coverage/coverage-badge.png)](https://raw.githubusercontent.com/veryfi/veryfi-ruby/main/coverage/coverage-badge.png)

**veryfi-ruby** is a Ruby gem for communicating with the [Veryfi OCR API](https://veryfi.com/api/)

[Documentation](https://veryfi.github.io/veryfi-ruby/)

## Table of Contents

- [Top](#veryfi-sdk-for-ruby)
  - [Table of Contents](#table-of-contents)
  - [Example](#example)
  - [Installation](#installation)
  - [Versioning & compatibility](#versioning--compatibility)
  - [Getting Started](#getting-started)
    - [Obtaining Client ID and user keys](#obtaining-client-id-and-user-keys)
    - [Ruby API Client Library](#ruby-api-client-library)
  - [Configuring the client](#configuring-the-client)
    - [Custom Faraday configuration](#custom-faraday-configuration)
  - [Handling errors](#handling-errors)
  - [Response objects](#response-objects)
  - [Common parameters & defaults](#common-parameters--defaults)
  - [Available APIs](#available-apis)
    - [Documents](#documents)
    - [Tags](#tags)
    - [Document Tags](#document-tags)
    - [Line Items](#line-items)
    - [Tax Lines](#tax-lines)
    - [PDF Split (Documents Set)](#pdf-split-documents-set)
    - [Any Document (A-Docs)](#any-document-a-docs)
    - [Bank Statements](#bank-statements)
    - [Bank Statement Split](#bank-statement-split)
    - [Business Cards](#business-cards)
    - [Checks](#checks)
    - [Classify](#classify)
    - [W-2](#w-2)
    - [W-2 Split](#w-2-split)
    - [W-8 BEN-E](#w-8-ben-e)
    - [W-9](#w-9)
    - [Per-resource tags](#per-resource-tags)
  - [Need help?](#need-help)
- [For Developers](#for-developers)
  - [Install](#install)
  - [Quality tools](#quality-tools)
  - [Develop](#develop)


## Example

Below is a sample script using <a href="https://www.veryfi.com" target="_blank">**Veryfi**</a> for OCR and extracting data from a document:

```ruby
require 'veryfi'

veryfi_client = Veryfi::Client.new(
  client_id: 'your_client_id',
  client_secret: 'your_client_secret',
  username: 'your_username',
  api_key: 'your_password'
)
```

This submits a document for processing (3-5 seconds for a response)

```ruby
params = {
  file_path: './test/receipt.jpg',
  auto_delete: true,
  boost_mode: false,
  async: false,
  external_id: '123456789',
  max_pages_to_process: 10,
  tags: ['tag1'],
  categories: [
    'Advertising & Marketing',
    'Automotive'
  ]
}

response = veryfi_client.document.process(params)

puts response
```

...or with a URL

```ruby
params = {
  file_url: 'https://raw.githubusercontent.com/veryfi/veryfi-python/master/tests/assets/receipt_public.jpg',
  auto_delete: true,
  boost_mode: false,
  async: false,
  external_id: '123456789',
  max_pages_to_process: 10,
  tags: ['tag1'],
  categories: [
    'Advertising & Marketing',
    'Automotive'
  ]
}

response = veryfi_client.document.process_url(params)

puts response
```

This will produce the following response:

```json
{
  "abn_number": "",
  "account_number": "",
  "bill_to_address": "2 Court Square\nNew York, NY 12210",
  "bill_to_name": "John Smith",
  "bill_to_vat_number": "",
  "card_number": "",
  "cashback": 0,
  "category": "Repairs & Maintenance",
  "created": "2021-06-28 19:20:02",
  "currency_code": "USD",
  "date": "2019-02-11 00:00:00",
  "delivery_date": "",
  "discount": 0,
  "document_reference_number": "",
  "document_title": "",
  "document_type": "invoice",
  "due_date": "2019-02-26",
  "duplicate_of": 37055375,
  "external_id": "",
  "id": 37187909,
  "img_file_name": "receipt.png",
  "img_thumbnail_url": "https://scdn.veryfi.com/receipts/thumbnail.png",
  "img_url": "https://scdn.veryfi.com/receipts/receipt.png",
  "insurance": "",
  "invoice_number": "US-001",
  "is_duplicate": 1,
  "line_items": [
    {
      "date": "",
      "description": "Front and rear brake cables",
      "discount": 0,
      "id": 68004313,
      "order": 0,
      "price": 100,
      "quantity": 1,
      "reference": "",
      "section": "",
      "sku": "",
      "tax": 0,
      "tax_rate": 0,
      "total": 100,
      "type": "product",
      "unit_of_measure": ""
    },
    {
      "date": "",
      "description": "New set of pedal arms",
      "discount": 0,
      "id": 68004315,
      "order": 1,
      "price": 15,
      "quantity": 2,
      "reference": "",
      "section": "",
      "sku": "",
      "tax": 0,
      "tax_rate": 0,
      "total": 30,
      "type": "product",
      "unit_of_measure": ""
    },
    {
      "date": "",
      "description": "Labor 3hrs",
      "discount": 0,
      "id": 68004316,
      "order": 2,
      "price": 5,
      "quantity": 3,
      "reference": "",
      "section": "",
      "sku": "",
      "tax": 0,
      "tax_rate": 0,
      "total": 15,
      "type": "service",
      "unit_of_measure": ""
    }
  ],
  "notes": "",
  "ocr_text": "\n\fEast Repair Inc.\n1912 Harvest Lane\nNew York, NY 12210\n\nBILL TO\t\tSHIP TO\tRECEIPT #\tUS-001\nJohn Smith\t\tJohn Smith\tRECEIPT DATE\t11/02/2019\n2 Court Square\t3787 Pineview Drive\n\tP.O.#\t2312/2019\nNew York, NY 12210\tCambridge, MA 12210\n\tDUE DATE\t26/02/2019\nReceipt Total\t\t\t$154.06\n\nQTY DESCRIPTION\t\t\tUNIT PRICE\tAMOUNT\n1\tFront and rear brake cables\t\t100.00\t100.00\n2\tNew set of pedal arms\t\t\t15.00\t30.00\n3\tLabor 3hrs\t\t\t\t5.00\t15.00\n\n\tSubtotal\t145.00\n\tSales Tax 6.25%\t9.06\n\nTERMS & CONDITIONS\nPayment is due within 15 days\nPlease make checks payable to: East Repair\n\tJohn Smith\n\tInc.\n",
  "order_date": "",
  "payment_display_name": "",
  "payment_terms": "15 days",
  "payment_type": "",
  "phone_number": "",
  "purchase_order_number": "2312/2019",
  "rounding": 0,
  "service_end_date": "",
  "service_start_date": "",
  "ship_date": "",
  "ship_to_address": "3787 Pineview Drive\nCambridge, MA 12210",
  "ship_to_name": "John Smith",
  "shipping": 0,
  "store_number": "",
  "subtotal": 145,
  "tax": 9.06,
  "tax_lines": [
    {
      "base": 0,
      "name": "Sales",
      "order": 0,
      "rate": 6.25,
      "total": 9.06
    }
  ],
  "tip": 0,
  "total": 154.06,
  "total_weight": "",
  "tracking_number": "",
  "updated": "2021-06-28 19:20:03",
  "vat_number": "",
  "vendor": {
    "address": "1912 Harvest Lane\nNew York, NY 12210",
    "category": "Car Repair",
    "email": "",
    "fax_number": "",
    "name": "East Repair",
    "phone_number": "",
    "raw_name": "East Repair Inc.",
    "vendor_logo": "https://cdn.veryfi.com/logos/tmp/560806841.png",
    "vendor_reg_number": "",
    "vendor_type": "Car Repair",
    "web": ""
  },
  "vendor_account_number": "",
  "vendor_bank_name": "",
  "vendor_bank_number": "",
  "vendor_bank_swift": "",
  "vendor_iban": ""
}
```

## Installation

Install the latest version of the gem:

```bash
gem install veryfi
```

Or pin it in your `Gemfile`. The current major series is **`4.x`**, so the
recommended pessimistic constraint is:

```ruby
gem 'veryfi', '~> 4.0'
```

That gives you all backwards-compatible improvements in the `4.x` line
(`>= 4.0, < 5.0`) without unexpectedly jumping to a future `5.0` that
might contain breaking changes.

After editing your `Gemfile`, run:

```bash
bundle install
```

Then in your Ruby code:

```ruby
require 'veryfi'
```

## Versioning & compatibility

`veryfi-ruby` follows [Semantic Versioning](https://semver.org/):

- **MAJOR** (`4.x` → `5.x`): backwards-incompatible API changes. Read the
  release notes before upgrading.
- **MINOR** (`4.0.x` → `4.1.0`): new endpoints or new methods, fully
  backwards compatible. Safe to upgrade.
- **PATCH** (`4.0.0` → `4.0.1`): bug fixes only. Safe to upgrade.

| Series  | Status      | Notes                                                                                |
| ------- | ----------- | ------------------------------------------------------------------------------------ |
| `4.x`   | **Current** | Full coverage of the Veryfi v8 partner API including A-Docs, bank statements, checks (with remittance + async), W-2/W-8/W-9, classify, PDF split, W-2 split, bank-statement split, tax lines, and per-resource tag management. Responses are lightweight `Veryfi::Resource` objects (Hash-compatible). |
| `3.x`   | Maintenance | Documents, line items, tags, document tags only.                                     |
| `<=2.x` | Unsupported | Please upgrade.                                                                      |

### Supported Ruby versions

The minimum supported Ruby version is **3.0** (the floor of the Faraday
2.x line, which is the gem's only non-stdlib runtime dependency). CI
verifies the gem against:

| Ruby   | Upstream status              | Notes                                  |
| ------ | ---------------------------- | -------------------------------------- |
| `3.0`  | End-of-life upstream         | Floor — best-effort, no Ruby-side fixes |
| `3.1`  | End-of-life upstream         | Best-effort                            |
| `3.2`  | Security maintenance         |                                        |
| `3.3`  | Normal maintenance           |                                        |
| `3.4`  | Normal maintenance           |                                        |
| `4.0`  | Current stable               |                                        |

Ruby 2.7 and earlier are not supported. If you need to stay on Ruby 2.7
pin the `veryfi` 3.x release line, which targeted that vintage of Ruby.

The gem talks to Veryfi API version **`v8`** by default. You can override
this at construction time if you are working against a different version:

```ruby
Veryfi::Client.new(
  client_id:     'your_client_id',
  client_secret: 'your_client_secret',
  username:      'your_username',
  api_key:       'your_api_key',
  api_version:   'v8'          # default
)
```

## Getting Started

### Obtaining Client ID and user keys

If you don't have an account with Veryfi, please go ahead and register here: [https://hub.veryfi.com/signup/api/](https://hub.veryfi.com/signup/api/)

### Ruby API Client Library

The **veryfi-ruby** gem can be used to communicate with Veryfi API. All available functionality is described [in docs](https://veryfi.github.io/veryfi-ruby/)

## Configuring the client

The most explicit way is to instantiate {`Veryfi::Client`} directly:

```ruby
client = Veryfi::Client.new(
  client_id:     ENV.fetch('VERYFI_CLIENT_ID'),
  client_secret: ENV.fetch('VERYFI_CLIENT_SECRET'),
  username:      ENV.fetch('VERYFI_USERNAME'),
  api_key:       ENV.fetch('VERYFI_API_KEY')
)
```

For apps that want a single process-wide client (common in Rails / Sidekiq
setups), the `Veryfi.configure` / `Veryfi.client` shortcuts are provided:

```ruby
# config/initializers/veryfi.rb
Veryfi.configure do |c|
  c.client_id     = ENV.fetch('VERYFI_CLIENT_ID')
  c.client_secret = ENV.fetch('VERYFI_CLIENT_SECRET')
  c.username      = ENV.fetch('VERYFI_USERNAME')
  c.api_key       = ENV.fetch('VERYFI_API_KEY')
end

# anywhere in your app
Veryfi.client.document.process(file_path: './receipt.jpg')
```

`Veryfi.client` is memoized; if you re-`configure` the SDK it's rebuilt
automatically on the next access. Call `Veryfi.reset!` in tests to drop
the memoized client and configuration.

### Custom Faraday configuration

The underlying HTTP connection is a plain `Faraday::Connection`. Pass a
`faraday:` block to add middleware — retries, logging, persistent
connections, anything Faraday supports:

```ruby
client = Veryfi::Client.new(
  client_id:     '…',
  client_secret: '…',
  username:      '…',
  api_key:       '…',
  faraday: ->(conn) {
    # automatic exponential backoff on retryable statuses
    conn.request  :retry,
                  max:             3,
                  interval:        0.5,
                  backoff_factor:  2,
                  retry_statuses:  [429, 502, 503, 504]

    # log every request / response
    conn.response :logger, Rails.logger if defined?(Rails)

    # keep TCP connections open between API calls
    conn.adapter  :net_http_persistent
  }
)
```

(`faraday-retry` and `faraday-net_http_persistent` are not bundled with
this gem — install whichever extensions you need.)

## Handling errors

Every error raised by the SDK descends from `Veryfi::Error::VeryfiError`,
so a catch-all rescue is always valid:

```ruby
begin
  client.document.process(file_path: './receipt.jpg')
rescue Veryfi::Error::VeryfiError => e
  Rails.logger.error("Veryfi call failed (status=#{e.status}): #{e.message}")
  raise
end
```

When you want to react differently per HTTP status, rescue one of the
specific subclasses. Order matters — list narrower classes before broader
ones:

| HTTP status        | Exception class                         | Typical reason                              |
| ------------------ | --------------------------------------- | ------------------------------------------- |
| `400 Bad Request`        | `Veryfi::Error::BadRequest`         | Malformed payload or failed validation      |
| `401 Unauthorized`       | `Veryfi::Error::Unauthorized`       | Bad / missing / expired credentials         |
| `403 Forbidden`          | `Veryfi::Error::AccessLimitReached` | Credentials lack permission for this action |
| `404 Not Found`          | `Veryfi::Error::NotFound`           | Resource id does not exist                  |
| `408 Request Timeout`    | `Veryfi::Error::RequestTimeout`     | Request timed out before Veryfi responded   |
| `409 Conflict`           | `Veryfi::Error::Conflict`           | Conflicts with current resource state       |
| `415 Unsupported Media`  | `Veryfi::Error::UnsupportedMediaType` | File type not supported by the endpoint   |
| `429 Too Many Requests`  | `Veryfi::Error::TooManyRequests`    | Rate-limited; back off and retry            |
| Other 4xx                | `Veryfi::Error::ClientError`        | Generic 4xx                                 |
| Any 5xx                  | `Veryfi::Error::ServerError`        | Server-side error; retry with backoff       |

```ruby
begin
  client.document.process(file_path: path)
rescue Veryfi::Error::Unauthorized    then refresh_credentials!
rescue Veryfi::Error::TooManyRequests then back_off
rescue Veryfi::Error::ServerError     then schedule_retry
rescue Veryfi::Error::VeryfiError     then notify_ops
end
```

Each error exposes `#status` (Integer), `#response` (parsed body as a
`Veryfi::Resource`) and `#message` (the pretty-printed JSON body, falling
back to `"<status>"` when the response is empty).

## Response objects

Every API call returns a `Veryfi::Resource`. A `Resource` is a tiny
subclass of `Hash`, so anything that already treats the response as a
hash keeps working unchanged — no migration required when upgrading
from earlier versions of this gem:

```ruby
response = client.document.get(44_691_518)

response["id"]                            # => 44691518
response[:id]                             # => 44691518  (symbol keys work too)
response.dig("vendor", "name")            # => "East Repair"
response.is_a?(Hash)                      # => true
JSON.pretty_generate(response)            # works as you'd expect
```

In addition, every key is exposed as a method, recursively:

```ruby
response.id                               # => 44691518
response.vendor.name                      # => "East Repair"
response.line_items.first.description     # => "Brake cables"
response.line_items.map(&:total)          # => [100, 30, 15]
response.is_duplicate?                    # => true   (boolean predicate sugar)
```

Nested objects become `Resource`s and arrays of objects become arrays
of `Resource`s automatically. Leaf values (strings, numbers, booleans,
`nil`) pass through untouched. Unknown keys raise `NoMethodError`, so
typos surface immediately instead of silently returning `nil`.

If you need a plain `Hash` (e.g. to hand off to a serializer that
inspects the exact class), call `#to_h`, which recursively unwraps:

```ruby
response.to_h.class                       # => Hash
response.to_h["vendor"].class             # => Hash
```

## Common parameters & defaults

Most of the "process" methods (`process`, `process_url`, `process_async`,
`process_url_async`, `process_with_remittance`, …) accept the same set
of optional keys. **Omitting a key is exactly equivalent to passing its
default value** — both produce the same outbound request. Only pass a
key when you want a non-default value or want to make the intent
explicit in your own code.

| Key                     | Required?                                  | Default                                       | Meaning |
| ----------------------- | ------------------------------------------ | --------------------------------------------- | ------- |
| `file_path`             | Yes for `process` / `process_async` etc.   | —                                             | Local path to the file to upload. Read and base64-encoded for you. |
| `file_url`              | Yes for `process_url` (or `file_urls`)     | —                                             | Publicly accessible URL to a single file. |
| `file_urls`             | Alternative to `file_url`                  | —                                             | Array of publicly accessible URLs treated as one logical document. |
| `file_name`             | No                                         | basename of `file_path` / `file_url`          | Display name sent to Veryfi. Useful when `file_path` is a tempfile with an ugly name. |
| `categories`            | No                                         | Veryfi's default list (see `Veryfi::Api::Document::CATEGORIES`) for receipts/invoices; `[]` for split endpoints | Restrict Veryfi's categorization output to this set of strings. |
| `tags`                  | No                                         | `nil` (no tags)                               | Array of tag names to attach to the resulting document. |
| `auto_delete`           | No                                         | `false`                                       | When `true`, Veryfi deletes the document from its storage immediately after extraction. Use when you don't need Veryfi to keep the file (e.g. you store it yourself). |
| `boost_mode`            | No                                         | `false`                                       | When `true`, Veryfi skips data-enrichment steps (vendor lookup, logo, category enrichment, etc.). Processing is **faster** but the response has **less** extracted/enriched data. Useful for high-throughput pipelines that don't need the extras. |
| `async`                 | No                                         | `false`                                       | When `true`, the request returns immediately (with a processing-status payload) and Veryfi continues extraction in the background. **Prefer the dedicated `.process_async` / `.process_url_async` methods** where available — they hit the canonical async endpoint instead of piggybacking on the sync one. |
| `external_id`           | No                                         | `nil`                                         | Your own identifier for the document. Echoed back in the response and searchable via `client.document.all(external_id: …)`. |
| `max_pages_to_process`  | No                                         | `nil` (= all pages)                           | Hard cap on the number of pages Veryfi reads, starting from page 1. Useful for very long PDFs when you only care about the first few pages. |
| `bounding_boxes`        | No                                         | `false`                                       | When `true`, the response includes `bounding_box` / `bounding_region` metadata for each extracted field. |
| `confidence_details`    | No                                         | `false`                                       | When `true`, the response includes per-field `score` and `ocr_score` values. |
| `thinking`              | No                                         | `nil` (off)                                   | Extra LLM pass on the line items: `"light"` or `"deep"` (slower). Used by `process` / `process_url`, and only takes effect if thinking mode is enabled for your account. |

So all four of the following calls are equivalent and produce the same
request payload — pick whichever style your team prefers:

```ruby
# All defaults explicit
client.document.process(
  file_path:            './receipt.jpg',
  auto_delete:          false,
  boost_mode:           false,
  async:                false,
  external_id:          nil,
  max_pages_to_process: nil,
  tags:                 nil,
  categories:           Veryfi::Api::Document::CATEGORIES
)

# Defaults omitted (recommended — least noise)
client.document.process(file_path: './receipt.jpg')

# Only the non-defaults
client.document.process(
  file_path:   './receipt.jpg',
  auto_delete: true,
  tags:        ['expense']
)

# Same call, mixing styles
client.document.process(
  file_path:   './receipt.jpg',
  boost_mode:  false,           # explicit default — purely for readability
  external_id: '123456789'
)
```

If you ever need to know the default list of categories at runtime,
it lives at `Veryfi::Api::Document::CATEGORIES`.

## Available APIs

The `Veryfi::Client` exposes the full Veryfi API surface through namespaced sub-objects. All sub-objects share the same underlying authenticated `Veryfi::Request`, so a single client instance is enough.

```ruby
client = Veryfi::Client.new(
  client_id: 'your_client_id',
  client_secret: 'your_client_secret',
  username: 'your_username',
  api_key: 'your_api_key'
)
```

### Documents

```ruby
client.document.all                                                # GET    /partner/documents/
client.document.get(document_id)                                   # GET    /partner/documents/:id
client.document.process(file_path: 'receipt.jpg')                  # POST   /partner/documents/ (upload)
client.document.process_url(file_url: 'https://...')               # POST   /partner/documents/ (url)
client.document.process_bulk(%w[https://... https://...])          # POST   /partner/documents/bulk/
client.document.update(document_id, notes: 'edited')               # PUT    /partner/documents/:id
client.document.delete(document_id)                                # DELETE /partner/documents/:id
```

### Tags

```ruby
client.tag.all                                                     # GET    /partner/tags/
client.tag.delete(tag_id)                                          # DELETE /partner/tags/:id
```

### Document Tags

```ruby
client.document_tag.all(document_id)                               # GET    /partner/documents/:id/tags/
client.document_tag.add(document_id, name: 'priority')             # PUT    /partner/documents/:id/tags/
client.document_tag.add_multiple(document_id, %w[a b c])           # POST   /partner/documents/:id/tags/
client.document_tag.replace(document_id, %w[a b c])                # PUT    /partner/documents/:id/
client.document_tag.delete(document_id, tag_id)                    # DELETE /partner/documents/:id/tags/:tag_id
client.document_tag.delete_all(document_id)                        # DELETE /partner/documents/:id/tags/
```

### Line Items

```ruby
client.line_item.all(document_id)                                  # GET    /partner/documents/:id/line-items/
client.line_item.get(document_id, line_item_id)                    # GET    /partner/documents/:id/line-items/:line_id
client.line_item.create(document_id, description: 'Foo')           # POST   /partner/documents/:id/line-items/
client.line_item.update(document_id, line_item_id, discount: 0.9)  # PUT    /partner/documents/:id/line-items/:line_id
client.line_item.delete(document_id, line_item_id)                 # DELETE /partner/documents/:id/line-items/:line_id
client.line_item.delete_all(document_id)                           # DELETE /partner/documents/:id/line-items
```

### Tax Lines

```ruby
client.tax_line.all(document_id)                                   # GET    /partner/documents/:id/tax-lines
client.tax_line.get(document_id, tax_line_id)                      # GET    /partner/documents/:id/tax-lines/:tax_id
client.tax_line.create(document_id, name: 'Sales Tax', rate: 6.25) # POST   /partner/documents/:id/tax-lines
client.tax_line.update(document_id, tax_line_id, rate: 7.0)        # PUT    /partner/documents/:id/tax-lines/:tax_id
client.tax_line.delete(document_id, tax_line_id)                   # DELETE /partner/documents/:id/tax-lines/:tax_id
```

### PDF Split (Documents Set)

Split a multi-page PDF into multiple processed documents.

```ruby
client.pdf_split.all                                               # GET    /partner/documents-set/
client.pdf_split.get(documents_set_id)                             # GET    /partner/documents-set/:id
client.pdf_split.process(file_path: 'multi.pdf')                   # POST   /partner/documents-set/ (upload)
client.pdf_split.process_url(file_url: 'https://...')              # POST   /partner/documents-set/ (url)
```

### Any Document (A-Docs)

Process arbitrary document types using a Veryfi blueprint.

```ruby
client.any_document.all                                            # GET    /partner/any-documents/
client.any_document.get(document_id)                               # GET    /partner/any-documents/:id
client.any_document.process(
  blueprint_name: 'us_w2_2022',
  file_path: 'doc.pdf'
)                                                                  # POST   /partner/any-documents/ (upload)
client.any_document.process_url(
  blueprint_name: 'us_w2_2022',
  file_url: 'https://...'
)                                                                  # POST   /partner/any-documents/ (url)
client.any_document.process_async(
  blueprint_name: 'us_w2_2022',
  file_path: 'doc.pdf'
)                                                                  # POST   /partner/any-documents/async (upload)
client.any_document.process_url_async(
  blueprint_name: 'us_w2_2022',
  file_url: 'https://...'
)                                                                  # POST   /partner/any-documents/async (url)
client.any_document.update(document_id, notes: 'edited')           # PUT    /partner/any-documents/:id
client.any_document.delete(document_id)                            # DELETE /partner/any-documents/:id
```

### Bank Statements

```ruby
client.bank_statement.all                                          # GET    /partner/bank-statements/
client.bank_statement.get(document_id)                             # GET    /partner/bank-statements/:id
client.bank_statement.process(file_path: 'statement.pdf')          # POST   /partner/bank-statements/ (upload)
client.bank_statement.process_url(file_url: 'https://...')         # POST   /partner/bank-statements/ (url)
client.bank_statement.process_async(file_path: 'statement.pdf')    # POST   /partner/bank-statements/async (upload)
client.bank_statement.process_url_async(file_url: 'https://...')   # POST   /partner/bank-statements/async (url)
client.bank_statement.update(document_id, notes: 'edited')         # PUT    /partner/bank-statements/:id
client.bank_statement.delete(document_id)                          # DELETE /partner/bank-statements/:id
```

### Bank Statement Split

Split a multi-statement file into individually processed bank statements.

```ruby
client.bank_statement_split.all                                    # GET    /partner/bank-statements-set/
client.bank_statement_split.get(id)                                # GET    /partner/bank-statements-set/:id
client.bank_statement_split.process(file_path: 'multi.pdf')        # POST   /partner/bank-statements-set/ (upload)
client.bank_statement_split.process_url(file_urls: ['https://...']) # POST  /partner/bank-statements-set/ (url)
```

### Business Cards

```ruby
client.business_card.all                                           # GET    /partner/business-cards/
client.business_card.get(document_id)                              # GET    /partner/business-cards/:id
client.business_card.process(file_path: 'card.jpg')                # POST   /partner/business-cards/ (upload)
client.business_card.process_url(file_url: 'https://...')          # POST   /partner/business-cards/ (url)
client.business_card.update(document_id, company: 'Globex')        # PUT    /partner/business-cards/:id
client.business_card.delete(document_id)                           # DELETE /partner/business-cards/:id
```

### Checks

```ruby
client.check.all                                                   # GET    /partner/checks/
client.check.get(document_id)                                      # GET    /partner/checks/:id
client.check.process(file_path: 'check.jpg')                       # POST   /partner/checks/ (upload)
client.check.process_url(file_url: 'https://...')                  # POST   /partner/checks/ (url)
client.check.process_with_remittance(file_path: 'check.jpg')       # POST   /partner/check-with-document/ (upload)
client.check.process_with_remittance_url(file_url: 'https://...')  # POST   /partner/check-with-document/ (url)
client.check.process_async(file_path: 'check.jpg')                 # POST   /partner/checks/async (upload)
client.check.process_url_async(file_url: 'https://...')            # POST   /partner/checks/async (url)
client.check.update(document_id, notes: 'edited')                  # PUT    /partner/checks/:id
client.check.delete(document_id)                                   # DELETE /partner/checks/:id
```

### Classify

Predict the document type of a file.

```ruby
client.classify.process(
  file_path: 'unknown.jpg',
  document_types: %w[invoice receipt w2]
)                                                                  # POST   /partner/classify/ (upload)
client.classify.process_url(
  file_url: 'https://...',
  document_types: %w[invoice receipt w2]
)                                                                  # POST   /partner/classify/ (url)
```

### W-2

```ruby
client.w2.all                                                      # GET    /partner/w2s/
client.w2.get(document_id)                                         # GET    /partner/w2s/:id
client.w2.process(file_path: 'w2.pdf')                             # POST   /partner/w2s/ (upload)
client.w2.process_url(file_url: 'https://...')                     # POST   /partner/w2s/ (url)
client.w2.update(document_id, notes: 'edited')                     # PUT    /partner/w2s/:id
client.w2.delete(document_id)                                      # DELETE /partner/w2s/:id
```

### W-2 Split

Split a file containing multiple W-2 forms into individually processed W-2s.

```ruby
client.w2_split.all                                                # GET    /partner/w2s-set/
client.w2_split.get(w2s_set_id)                                    # GET    /partner/w2s-set/:id
client.w2_split.process(file_path: 'multi_w2.pdf')                 # POST   /partner/w2s-set/ (upload)
client.w2_split.process_url(file_urls: ['https://...'])            # POST   /partner/w2s-set/ (url)
```

### W-8 BEN-E

```ruby
client.w8.all                                                      # GET    /partner/w-8ben-e/
client.w8.get(document_id)                                         # GET    /partner/w-8ben-e/:id
client.w8.process(file_path: 'w8.pdf')                             # POST   /partner/w-8ben-e/ (upload)
client.w8.process_url(file_url: 'https://...')                     # POST   /partner/w-8ben-e/ (url)
client.w8.update(document_id, notes: 'edited')                     # PUT    /partner/w-8ben-e/:id
client.w8.delete(document_id)                                      # DELETE /partner/w-8ben-e/:id
```

### W-9

```ruby
client.w9.all                                                      # GET    /partner/w9s/
client.w9.get(document_id)                                         # GET    /partner/w9s/:id
client.w9.process(file_path: 'w9.pdf')                             # POST   /partner/w9s/ (upload)
client.w9.process_url(file_url: 'https://...')                     # POST   /partner/w9s/ (url)
client.w9.update(document_id, notes: 'edited')                     # PUT    /partner/w9s/:id
client.w9.delete(document_id)                                      # DELETE /partner/w9s/:id
```

### Per-resource tags

Every processed-document resource (`any_document`, `bank_statement`, `business_card`, `check`, `w2`, `w8`, `w9`) exposes the same tag-management methods directly on the resource, mirroring the per-document tag endpoints:

```ruby
client.check.tags(check_id)                                        # GET    /partner/checks/:id/tags
client.check.add_tag(check_id, name: 'priority')                   # PUT    /partner/checks/:id/tags  (single)
client.check.add_tags(check_id, %w[priority urgent])               # POST   /partner/checks/:id/tags  (multiple)
client.check.delete_tag(check_id, tag_id)                          # DELETE /partner/checks/:id/tags/:tag_id
client.check.delete_tags(check_id)                                 # DELETE /partner/checks/:id/tags  (all)
```

The same five methods are available on `client.any_document`, `client.bank_statement`, `client.business_card`, `client.w2`, `client.w8`, and `client.w9`.

## Need help?

If you run into any issue or need help installing or using the library, please contact support@veryfi.com.

If you found a bug in this library or would like new features added, then open an issue or pull requests against this repo!

# For Developers

## Install

```bash
bin/setup
```

## Quality tools

* `bin/quality` based on [RuboCop](https://github.com/bbatsov/rubocop)
* `.rubocop.yml` describes active checks

## Develop

`bin/ci` checks your specs and runs quality tools

## Release

1. Change version in `lib/veryfi/version.rb`
2. Run `bundle` - this should update `Gemfile.lock`
3. Commit changes, push to a new Github branch, and merge
4. On Github go to `Actions` -> `Release` -> and click `Run workflow` to trigger a new release
5. Release workflow will publish gem to [Rubygems](https://rubygems.org/gems/veryfi)
