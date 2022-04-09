import 'package:cloud_firestore/cloud_firestore.dart';

class MainCategory {
  final String mainCategory;
  final String categoryId;

  const MainCategory({required this.mainCategory, required this.categoryId});

  factory MainCategory.fromFirestore(QueryDocumentSnapshot json) =>
      MainCategory(
          mainCategory: json['mainCategory'],
          categoryId: json['mainCategoryId']);
}
