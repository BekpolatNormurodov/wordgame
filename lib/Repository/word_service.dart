// ignore_for_file: depend_on_referenced_packages
import '../library.dart';
import 'package:http/http.dart' as http;

class WordService {
  Future<List<WordModel>?> wordService() async {
    try {
      var response = await http
          .get(Uri.parse('https://bekpolatnormurodov.uz/wordgameApi/api/v1/hangman'));
      if (response.statusCode == 200) {
        List json = jsonDecode(response.body);
        List<WordModel> data = json.map((e) => WordModel.fromJson(e)).toList();
        return data;
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      [];
    }
    return null;
  }
}
