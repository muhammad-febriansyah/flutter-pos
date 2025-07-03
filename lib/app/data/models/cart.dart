// pos/app/data/models/cart.dart
import 'package:get/get.dart';
import 'package:pos/app/data/models/product.dart'; // Mengacu pada kelas Datum Anda

class CartItem {
  final Datum product; // Menggunakan Datum sebagai tipe produk
  RxInt quantity;
  RxInt subtotal;

  CartItem({required this.product, required int quantity})
    : quantity = quantity.obs,
      subtotal = (product.hargaJual * quantity).obs;

  void updateQuantity(int newQuantity) {
    if (newQuantity >= 0) {
      quantity.value = newQuantity;
      subtotal.value = product.hargaJual * quantity.value;
    }
  }

  // --- Ini adalah implementasi fromJson yang sangat penting ---
  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Debugging: Lihat data JSON yang masuk ke fromJson CartItem
    // print('DEBUG CartItem.fromJson receiving: $json'); // AKTIFKAN UNTUK DEBUGGING

    try {
      return CartItem(
        // Pastikan 'product' ada di JSON dan tipenya Map<String, dynamic>
        // Kemudian parse menggunakan Datum.fromJson
        product: Datum.fromJson(json['product'] as Map<String, dynamic>),
        // Pastikan 'quantity' ada di JSON dan di-cast ke int
        quantity: json['quantity'] as int,
      );
    } catch (e) {
      // print('ERROR CartItem.fromJson: Gagal parsing: $e, JSON: $json'); // AKTIFKAN UNTUK DEBUGGING
      rethrow; // Re-throw error untuk melacak masalah
    }
  }

  // --- Ini adalah implementasi toJson yang sangat penting ---
  Map<String, dynamic> toJson() {
    // Debugging: Lihat data JSON yang dibuat oleh toJson CartItem
    // print('DEBUG CartItem.toJson creating: { "product": ${product.toJson()}, "quantity": ${quantity.value} }'); // AKTIFKAN UNTUK DEBUGGING

    return {
      // Pastikan key 'product' ini cocok dengan yang diharapkan oleh fromJson
      'product': product.toJson(), // Panggil toJson dari objek Datum
      // Pastikan key 'quantity' ini cocok dengan yang diharapkan oleh fromJson
      'quantity': quantity.value, // Ambil nilai int dari RxInt
    };
  }
}
