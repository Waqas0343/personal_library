class BookModel {
  final int? id;
  final String name;
  final String description;
  final String author;
  final String image;
  bool status;  // Add status field


  BookModel({
    this.id,
    required this.name,
    required this.description,
    required this.author,
    required this.image,
    this.status = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'author': author,
      'image': image,
      'status': status ? 1 : 0,
    };
  }

  BookModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        image = map['image'],
        author = map['author'],
        status= map['status'] == 1;

  BookModel copyWith({
    int? id,
    String? name,
    String? description,
    String? author,
    String? image,
    bool? status,
  }) =>
      BookModel(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        author: author ?? this.author,
        image: image ?? this.image,
        status: status ?? this.status,
      );
}
