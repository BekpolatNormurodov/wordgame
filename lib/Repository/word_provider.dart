import '../library.dart';

enum WordState { intial, waiting, success, error }

class WordProvider extends ChangeNotifier {
  WordState state = WordState.intial;
  set(WordState value) {
    state = value;
    notifyListeners();
  }

  List<WordModel> data = [];

  Future getData() async {
    set(WordState.waiting);
    try {
      data = (await WordService().wordService())!;
      set(WordState.success);
    } catch (e) {
      set(WordState.error);
    }
  }
}
