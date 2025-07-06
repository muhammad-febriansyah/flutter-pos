import 'package:get/get.dart';
import 'package:pos/app/data/faq_provider.dart';
import 'package:pos/app/data/models/faq.dart';

class FaqController extends GetxController {
  final FaqProvider provider = FaqProvider();

  // State untuk menyimpan daftar FAQ. Menggunakan .obs agar reaktif.
  var faqList = <Faq>[].obs;

  // State untuk status loading
  var isLoading = true.obs;

  // State untuk pesan error
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs(); // Panggil fungsi fetch data saat controller diinisialisasi
  }

  // Fungsi untuk mengambil data dari provider
  void fetchFaqs() async {
    try {
      isLoading(true); // Mulai loading
      errorMessage(''); // Bersihkan pesan error sebelumnya

      // Panggil provider untuk mendapatkan data
      var faqs = await provider.getFaqs();

      // Jika berhasil, update list FAQ
      faqList.assignAll(faqs);
    } catch (e) {
      // Jika terjadi error, simpan pesan error
      errorMessage('Gagal memuat data: ${e.toString()}');
    } finally {
      // Selesai loading, apapun hasilnya
      isLoading(false);
    }
  }
}
