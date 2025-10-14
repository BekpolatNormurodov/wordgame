import 'package:wordgame/library.dart';

// --- LEVELLAR ---
final List<List<String>> levelLetters = [
  ["B", "E", "T", "O"],
  ["K", "I", "T", "O", "O"],
  ["C", "U", "P", "E", "R"]
];

final List<List<String>> levelWords = [
  ["BOT", "BET", "TOBE"],
  ["KITOB", "BOT", "TOK"],
  ["SUPER", "RUS", "PU"],
];

class CrosswordPage extends StatefulWidget {
  const CrosswordPage({super.key});

  @override
  State<CrosswordPage> createState() => _CrosswordPageState();
}

class _CrosswordPageState extends State<CrosswordPage> {
  int currentLevel = 0;
  List<String> foundWords = [];
  String currentWord = "";
  String errorMessage = "";

  void selectLetter(String letter) {
    setState(() {
      currentWord += letter;
    });
  }

  void clearWord() {
    setState(() {
      currentWord = "";
    });
  }

  void submitWord() {
    final targetWords = levelWords[currentLevel];

    if (targetWords.contains(currentWord) && !foundWords.contains(currentWord)) {
      setState(() {
        foundWords.add(currentWord);
      });
    } else {
      if (currentWord.isNotEmpty) {
        showError("Xato!");
      }
    }

    // Agar hammasi topilgan bo‘lsa keyingi level
    if (foundWords.length == targetWords.length) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (currentLevel < levelLetters.length - 1) {
          setState(() {
            currentLevel++;
            foundWords = [];
            currentWord = "";
            errorMessage = "";
          });
        } else {
          // Barcha level tugadi
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Tabriklaymiz!"),
              content: const Text("Siz barcha levelni tugatdingiz 🎉"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            ),
          );
        }
      });
    }

    clearWord();
  }

  void showError(String msg) {
    setState(() {
      errorMessage = msg;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          errorMessage = "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final letters = levelLetters[currentLevel];
    final targetWords = levelWords[currentLevel];

    return Scaffold(
      appBar: AppBar(
          title: Text("Level ${currentLevel + 1} / ${levelLetters.length}")),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Kataklar (so‘zlar column ko‘rinishida)
          Expanded(
            child: ListView.builder(
              itemCount: targetWords.length,
              itemBuilder: (context, index) {
                final word = targetWords[index];
                final isFound = foundWords.contains(word);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(word.length, (i) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurple, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          isFound ? word[i] : "",
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Hozir terilgan so‘z
          Text(
            currentWord,
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),

          const SizedBox(height: 10),

          // ❌ Xato xabari
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: const TextStyle(
                  fontSize: 22,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
            ),

          const SizedBox(height: 20),

          // Pastdagi harflar – qator ko‘rinishida animatsiyali tugmalar
          Wrap(
            spacing: 12,
            children: List.generate(letters.length, (index) {
              return ScaleTapButton(
                onTap: () => selectLetter(letters[index]),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4)
                    ],
                  ),
                  child: Center(
                    child: Text(
                      letters[index],
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // Tugmalar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: submitWord, child: const Text("Tasdiqlash")),
              const SizedBox(width: 16),
              OutlinedButton(
                  onPressed: clearWord, child: const Text("Tozalash")),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// --- Animatsiyali tugma ---
class ScaleTapButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const ScaleTapButton({super.key, required this.child, required this.onTap});

  @override
  State<ScaleTapButton> createState() => _ScaleTapButtonState();
}

class _ScaleTapButtonState extends State<ScaleTapButton> {
  double scale = 1.0;

  void animate() async {
    setState(() => scale = 0.85);
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => scale = 1.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: animate,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
