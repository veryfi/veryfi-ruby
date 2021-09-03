---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

- [Minimal example](#minimal-example)
- [Document API](#document-api)
- [Line Items API](#line-items-api)
- [Tags API](#tags-api)

### Minimal example

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
  file_url: "https://raw.githubusercontent.com/veryfi/veryfi-python/master/tests/assets/receipt_public.jpg",
  auto_delete: true,
  boost_mode: false,
  async: false,
  external_id: "123456789",
  max_pages_to_process: 10,
  tags: ["tag1"],
  categories: [
    "Advertising & Marketing",
    "Automotive"
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

---

### Document API

See [API schema](https://app.swaggerhub.com/apis/Veryfi/verify-api/) for request params and response details.

```ruby
# Update document
veryfi_client.document.update(document_id, params)

# Delete document by ID
veryfi_client.document.delete(document_id)

# Get document by ID
veryfi_client.document.get(document_id)

# List all documents
veryfi_client.document.all
```

---

### Line Items API

See [API schema](https://app.swaggerhub.com/apis/Veryfi/verify-api/) for request params and response details.

```ruby
# Get document line items
veryfi_client.line_items.all(document_id)

# Get line item by document id and line item id
veryfi_client.line_items.get(document_id, id)

# Create/update/delete document line item
veryfi_client.line_items.create(document_id, params)
veryfi_client.line_items.update(document_id, params)
veryfi_client.line_items.delete(document_id, params)
```

---

### Tags API

See [API schema](https://app.swaggerhub.com/apis/Veryfi/verify-api/) for request params and response details.

```ruby
# Tags
# List all tags
veryfi_client.tag.all

# Delete a tag by ID
veryfi_client.tag.delete(id)

# List all document tags
veryfi_client.document_tag.all(document_id)

# Add tag to document
veryfi_client.document_tag.add(document_id, name: "tag_name")

# Delete tag by document id and tag id
veryfi_client.document_tag.delete(document_id, id)

# Delete all document tags
veryfi_client.document_tag.delete_all(document_id)
```
