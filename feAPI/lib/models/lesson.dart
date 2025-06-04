class Lesson {
  final int id;
  final int categoryId;
  final String title;
  final String description;

  Lesson({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
    );
  }
}
