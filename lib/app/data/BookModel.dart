class BookModel {
  final int? id;
  final String title;
  final String author;
  final String? description;
  final String coverUrl; // URL of the book cover image
  final String pdfUrl; // URL to download the PDF
  final double? price;
  final String category;
  final String? size;
  final String page;
  final double? rating;
  final int? downloads;
  final DateTime? publishedDate;

  BookModel({
    this.id,
    required this.title,
    required this.author,
    this.description,
    required this.coverUrl,
    required this.pdfUrl,
    this.price,
    required this.category,
    this.size,
    required this.page,
    this.rating,
    this.downloads,
    this.publishedDate,
  });

  // Convert from Supabase database map
  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      description: map['description'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
      pdfUrl: map['pdfUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      size: map['size(MB)'] ?? '',
      page: map['page'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      downloads: map['downloads'] ?? 0,
      publishedDate: DateTime.parse(
        map['publishedDate'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Convert to Supabase-compatible map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'pdfUrl': pdfUrl,
      'price': price,
      'category': category,
      'size(MB)': size,
      'page': page,
      'rating': rating,
      'downloads': downloads,
      'publishedDate': publishedDate?.toIso8601String() ?? DateTime.now(),
    };
  }
}
