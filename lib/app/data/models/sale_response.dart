class SaleResponse {
  final bool success;
  final String message;
  final Invoice? invoice; // Made nullable
  final double? change;
  final String? statusPenjualan;
  final String? paymentUrl; // Added for Duitku
  final List<ItemDetail>? itemDetails; // Added for Duitku case
  final Map<String, dynamic>? errors; // Added for backend validation errors

  SaleResponse({
    required this.success,
    required this.message,
    this.invoice,
    this.change,
    this.statusPenjualan,
    this.paymentUrl,
    this.itemDetails,
    this.errors,
  });

  factory SaleResponse.fromJson(Map<String, dynamic> json) {
    List<ItemDetail>? parsedItemDetails;
    if (json['itemDetails'] != null) {
      parsedItemDetails =
          (json['itemDetails'] as List)
              .map((e) => ItemDetail.fromJson(e as Map<String, dynamic>))
              .toList();
    }

    // Safely parse 'invoice' only if it's a Map
    Invoice? parsedInvoice;
    if (json['invoice'] != null && json['invoice'] is Map) {
      parsedInvoice = Invoice.fromJson(json['invoice'] as Map<String, dynamic>);
    }

    return SaleResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      invoice: parsedInvoice,
      change:
          (json['change'] as num?)
              ?.toDouble(), // Use num to handle int or double
      statusPenjualan: json['status_penjualan'] as String?,
      paymentUrl: json['paymentUrl'] as String?, // Parse paymentUrl
      itemDetails: parsedItemDetails,
      errors:
          json['errors'] is Map ? json['errors'] as Map<String, dynamic> : null,
    );
  }
}

class Invoice {
  final int id;
  final String invoiceNumber;
  final double total;
  // Add other relevant fields from your Penjualan model here
  // final String? someOtherField; // Example of another field

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.total,
    // this.someOtherField, // Example
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as int,
      invoiceNumber: json['invoice_number'] as String,
      total: (json['total'] as num).toDouble(), // Ensure total is a double
      // someOtherField: json['some_other_field'] as String?, // Example
    );
  }
}

class ItemDetail {
  final String name;
  final int price;
  final int quantity;

  ItemDetail({required this.name, required this.price, required this.quantity});

  factory ItemDetail.fromJson(Map<String, dynamic> json) {
    return ItemDetail(
      name: json['name'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
    );
  }
}

// Add this extension to your Invoice class to convert it back to a Map for arguments
extension InvoiceToJson on Invoice {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'total': total,
      // Add other fields here if needed for arguments
    };
  }
}
