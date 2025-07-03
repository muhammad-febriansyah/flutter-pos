// Tambahkan definisi untuk RatingStats jika belum ada
class RatingStats {
  final int totalRatings;
  final double averageRating;
  final List<dynamic>
  ratingsCountByStar; // Atau buat model terpisah jika lebih kompleks

  RatingStats({
    required this.totalRatings,
    required this.averageRating,
    required this.ratingsCountByStar,
  });

  factory RatingStats.fromJson(Map<String, dynamic> json) {
    return RatingStats(
      totalRatings: json['total_ratings'] ?? 0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      ratingsCountByStar: json['ratings_count_by_star'] ?? [],
    );
  }
}
