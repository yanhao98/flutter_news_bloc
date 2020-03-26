// import 'package:meta/meta.dart';

class News {
  final String title;
  final String imageUrl;
  final String passtime;

  News({this.title, this.imageUrl, this.passtime});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] as String,
      imageUrl: json['image'] as String,
      passtime: json['passtime'] as String,
    );
  }
}
