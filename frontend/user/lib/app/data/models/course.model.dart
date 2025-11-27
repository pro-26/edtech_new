class Course {
  final String id;
  final String title;
  final String description;
  final String? thumbnail;
  final double price;
  final String level;
  final String? instructorId;
  final String? instructorName;

  Course({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnail,
    required this.price,
    required this.level,
    this.instructorId,
    this.instructorName,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'],
      price: double.parse(json['price']?.toString() ?? '0'),
      level: json['level'] ?? 'beginner',
      instructorId: json['instructorId'],
      instructorName: json['instructorName'],
    );
  }
}

// {id: 341b63ae-5d19-4e85-b163-5ca397372b7c, title: Introduction to NestJS, description: Learn the basics of NestJS..., price: 49.99, thumbnail: https://example.com/thumbnail.jpg, categoryId: 288b5661-a4d6-44e7-bc9a-48333db229e5, subcategoryId: 25ea88a9-d414-49f0-adcf-607f2ba282e4, instructorId: 193ffcd2-a199-492f-bd0d-48cea02d9e00, createdAt: 2025-11-27T10:08:26.041Z}]
