import 'dart:convert';

// Fungsi untuk mem-parsing list JSON
List<Faq> faqFromJson(String str) =>
    List<Faq>.from(json.decode(str)['data'].map((x) => Faq.fromJson(x)));

class Faq {
  final int id;
  final String question;
  final String answer;

  Faq({required this.id, required this.question, required this.answer});

  // Factory constructor untuk membuat instance Faq dari map (JSON object)
  factory Faq.fromJson(Map<String, dynamic> json) =>
      Faq(id: json["id"], question: json["question"], answer: json["answer"]);
}
