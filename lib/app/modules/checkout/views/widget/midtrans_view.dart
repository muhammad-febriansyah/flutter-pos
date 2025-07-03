// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/app/data/utils/color.dart'; // Ubah sesuai path kamu

class MidtransPaymentView extends StatelessWidget {
  final String snapToken;
  final String clientKey;

  const MidtransPaymentView({
    super.key,
    required this.snapToken,
    required this.clientKey,
  });

  @override
  Widget build(BuildContext context) {
    final MidtransEnvironment midtransEnv =
        clientKey.startsWith('SB-')
            ? MidtransEnvironment.sandbox
            : MidtransEnvironment.production;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pembayaran Midtrans',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [blueClr, satu, tiga],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: MidtransSnap(
        mode: midtransEnv,
        token: snapToken,
        midtransClientKey: clientKey,
        onPageFinished: (url) {
          debugPrint("Midtrans Page Finished: $url");
        },
        onPageStarted: (url) {
          debugPrint("Midtrans Page Started: $url");
        },
        onResponse: (result) {
          debugPrint("Midtrans Response: ${result.toJson()}");

          final status = result.transactionStatus;

          if (status == 'settlement' || status == 'capture') {
            // ✅ Pembayaran berhasil
            Get.offAllNamed(
              '/success', // Pastikan sesuai route kamu
              arguments: {
                'message': 'Pembayaran berhasil',
                'invoiceNumber': result.orderId,
                'status': 'paid',
              },
            );
          } else if (status == 'pending') {
            // ⚠️ Pembayaran belum selesai
            Get.snackbar(
              'Pending',
              'Transaksi belum dibayar. Silakan selesaikan pembayaran.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            Get.back(result: {'status': 'pending'});
          } else {
            // ❌ Pembayaran gagal atau dibatalkan
            Get.snackbar(
              'Gagal',
              'Transaksi dibatalkan atau gagal.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            Get.back(result: {'status': 'failed'});
          }
        },
      ),
    );
  }
}
