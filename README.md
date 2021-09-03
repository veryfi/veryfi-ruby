# Veryfi SDK for Ruby

![Veryfi Logo](https://cdn.veryfi.com/logos/veryfi-logo-wide-github.png)

[![Version](https://img.shields.io/gem/v/veryfi)](https://rubygems.org/gems/veryfi)
[![Test](https://github.com/veryfi/veryfi-ruby/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/veryfi/veryfi-ruby/actions/workflows/test.yml)

[![Coverage](https://raw.githubusercontent.com/veryfi/veryfi-ruby/main/coverage/coverage-badge.png)](https://raw.githubusercontent.com/veryfi/veryfi-ruby/main/coverage/coverage-badge.png)

## Table of Contents

- [Veryfi SDK for Ruby](#veryfi-sdk-for-ruby)
  - [Table of Contents](#table-of-contents)
  - [Example](#example)
  - [Installation](#installation)
  - [Getting Started](#getting-started)
    - [Obtaining Client ID and user keys](#obtaining-client-id-and-user-keys)
    - [Ruby API Client Library](#ruby-api-client-library)
  - [Need help?](#need-help)
- [For Developers](#for-developers)
  - [Install](#install)
  - [Quality tools](#quality-tools)
  - [Develop](#develop)

**veryfi-ruby** is a Ruby gem for communicating with the [Veryfi OCR API](https://veryfi.com/api/)

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

```bash
gem install veryfi
```

Or add to your Gemfile:
```ruby
gem 'veryfi', '~> 0.1'
```

## Getting Started

### Obtaining Client ID and user keys

If you don't have an account with Veryfi, please go ahead and register here: [https://hub.veryfi.com/signup/api/](https://hub.veryfi.com/signup/api/)

### Ruby API Client Library

The **veryfi-ruby** gem can be used to communicate with Veryfi API. All available functionality is described [in docs](https://veryfi.github.io/veryfi-ruby/)

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
