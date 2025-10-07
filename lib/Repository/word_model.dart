import 'dart:convert';

List<WordModel> wordModelFromJson(String str) =>
    List<WordModel>.from(json.decode(str).map((x) => WordModel.fromJson(x)));

String wordModelToJson(List<WordModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WordModel {
  final int id;
  final String category;
  final String word;

  WordModel({
    required this.id,
    required this.category,
    required this.word,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) => WordModel(
        id: json["id"],
        category: json["category"],
        word: json["word"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "word": word,
      };
}
