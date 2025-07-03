// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DuitkuWebView extends StatelessWidget {
  final String paymentUrl;
  final String invoiceNumber; // Terima nomor invoice

  const DuitkuWebView({
    super.key,
    required this.paymentUrl,
    required this.invoiceNumber,
  });

  @override
  Widget build(BuildContext context) {
    WebViewController webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                if (kDebugMode) {
                  print('WebView Duitku sedang dimuat: $progress%');
                }
              },
              onPageStarted: (String url) {
                if (kDebugMode) {
                  print('WebView Duitku mulai dimuat: $url');
                }
              },
              onPageFinished: (String url) {
                if (kDebugMode) {
                  print('WebView Duitku selesai dimuat: $url');
                }
                // Tidak ada lagi logika deep link di sini.
                // Status akan dicek setelah WebView ditutup.
              },
              onWebResourceError: (WebResourceError error) {
                if (kDebugMode) {
                  print(
                    'Kesalahan memuat WebView Duitku: ${error.description}',
                  );
                }
                Get.snackbar(
                  'Error Memuat Halaman',
                  'Gagal memuat halaman pembayaran: ${error.description}. Silakan coba lagi.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                // Kembalikan hasil error ke CheckoutController
                Get.back(
                  result: {'status': 'error', 'message': error.description},
                );
              },
              // MODIFIKASI: onNavigationRequest tidak lagi menangani deep link
              onNavigationRequest: (NavigationRequest request) {
                // Hanya izinkan navigasi di dalam WebView untuk proses Duitku.
                if (kDebugMode) {
                  print('WebView menavigasi ke: ${request.url}');
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(paymentUrl));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lengkapi Pembayaran',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
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
          onPressed: () {
            // Ketika user menekan tombol kembali manual di WebView
            // Kembalikan hasil ke CheckoutController untuk memicu pengecekan status
            Get.back(
              result: {
                'status': 'manual_dismiss',
                'invoiceNumber': invoiceNumber,
              },
            );
            Get.snackbar(
              'Pembayaran Belum Selesai',
              'Anda kembali dari halaman pembayaran. Status akan dicek.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            if (kDebugMode) {
              print('User menutup WebView Duitku secara manual.');
            }
          },
        ),
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
