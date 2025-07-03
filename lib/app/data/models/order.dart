// app/data/models/order.dart
class Order {
  final int id; // ID transaksi internal
  final String invoiceNumber; // Nomor invoice
  final int userId;
  final int customerId;
  final String type; // e.g., "take_away", "dine_in"
  final int subTotal;
  final int ppn;
  final int biayaLayanan;
  final int total; // Total harga setelah PPN
  final int laba;
  final String? duitkuReference;
  final String status; // e.g., "paid", "pending"
  final String? midtransTransactionId;
  final String? paymentUrl;
  final String? midtransSnapToken;
  final DateTime createdAt; // Tanggal dan waktu pembuatan
  final DateTime updatedAt;
  final int? mejaId;
  final String paymentMethod; // e.g., "cash", "midtrans"

  Order({
    required this.id,
    required this.invoiceNumber,
    required this.userId,
    required this.customerId,
    required this.type,
    required this.subTotal,
    required this.ppn,
    required this.biayaLayanan,
    required this.total,
    required this.laba,
    this.duitkuReference,
    required this.status,
    this.midtransTransactionId,
    this.paymentUrl,
    this.midtransSnapToken,
    required this.createdAt,
    required this.updatedAt,
    this.mejaId,
    required this.paymentMethod,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      invoiceNumber: json['invoice_number'] as String,
      userId: json['user_id'] as int,
      customerId: json['customer_id'] as int,
      type: json['type'] as String,
      subTotal: json['sub_total'] as int,
      ppn: json['ppn'] as int,
      biayaLayanan: json['biaya_layanan'] as int,
      total: json['total'] as int,
      laba: json['laba'] as int,
      duitkuReference: json['duitku_reference'] as String?,
      status: json['status'] as String,
      midtransTransactionId: json['midtrans_transaction_id'] as String?,
      paymentUrl: json['payment_url'] as String?,
      midtransSnapToken: json['midtrans_snap_token'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      mejaId: json['meja_id'] as int?,
      paymentMethod: json['payment_method'] as String,
    );
  }
}
