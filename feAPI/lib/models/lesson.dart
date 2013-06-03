class Lesson {
  final int id;
  final int categoryId;
  final String title;
  final String description;
  final int orderNum;
  final DateTime createdAt;

  Lesson({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.orderNum,
    required this.createdAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      orderNum: json['order_num'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
