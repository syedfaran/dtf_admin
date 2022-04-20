import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteModel {
  final String author;
  final String quote;

  const QuoteModel({required this.author, required this.quote});

  factory QuoteModel.fromFirestore(QueryDocumentSnapshot json) {
    return QuoteModel(
      author: json['author'] as String,
      quote: json['quote'] as String,
    );
  }
  factory QuoteModel.fromJson(Map json) {
    return QuoteModel(
      author: json['author'] as String,
      quote: json['quote'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'quote': quote,
    };
  }

  QuoteModel copyWith({
    String? author,
    String? quote,
  }) {
    return QuoteModel(
      author: author ?? this.author,
      quote: quote ?? this.quote,
    );
  }
}
