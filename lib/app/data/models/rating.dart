class RatingModel {
  final int id;
  final int userId;
  final int produkId; // Changed to produkId to match Laravel's produk_id
  final int transactionId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  RatingModel({
    required this.id,
    required this.userId,
    required this.produkId, // Changed to produkId
    required this.transactionId,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      produkId: json['produk_id'] ?? 0, // Changed to produk_id
      transactionId: json['transaction_id'] ?? 0,
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'produk_id': produkId, // Changed to produk_id
      'transaction_id': transactionId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  RatingModel copyWith({
    int? id,
    int? userId,
    int? produkId, // Changed to produkId
    int? transactionId,
    int? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RatingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      produkId: produkId ?? this.produkId, // Changed to produkId
      transactionId: transactionId ?? this.transactionId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RatingStats {
  final double averageRating;
  final int totalRatings;
  final Map<int, int> ratingDistribution;

  RatingStats({
    required this.averageRating,
    required this.totalRatings,
    required this.ratingDistribution,
  });

  factory RatingStats.fromJson(Map<String, dynamic> json) {
    final rawDistribution = json['rating_distribution'] ?? {};
    final distribution = <int, int>{};

    // Convert string keys to int safely
    (rawDistribution as Map).forEach((key, value) {
      final intKey = int.tryParse(key.toString());
      if (intKey != null && value is int) {
        distribution[intKey] = value;
      }
    });

    return RatingStats(
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      totalRatings: json['total_ratings'] ?? 0,
      ratingDistribution: distribution,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'total_ratings': totalRatings,
      'rating_distribution': ratingDistribution.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    };
  }
}
