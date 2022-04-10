import 'package:cloud_firestore/cloud_firestore.dart';

class Quote {
  final String author;
  final String quote;

  const Quote({required this.author, required this.quote});

  factory Quote.fromFirestore(QueryDocumentSnapshot json) {
    return Quote(
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
}
