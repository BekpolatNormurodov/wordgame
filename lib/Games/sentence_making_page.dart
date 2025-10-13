import 'package:wordgame/library.dart';

class SentenceMakingPage extends StatefulWidget {
  const SentenceMakingPage({super.key});

  @override
  State<SentenceMakingPage> createState() => _SentenceMakingPageState();
}

class _SentenceMakingPageState extends State<SentenceMakingPage> {
  final List<String> levels = [
    "MEN VA SEN",
    "ULAR BAXTLI",
    "HALF",
    "BALL GAME",
  ];

  int currentLevel = 0;

  List<String> selected = [];      // tanlangan harflar (bo'shliqsiz)
  late List<String> _allShuffled;  // level boshida bir marta aralashtiriladi
  late List<String> remaining;     // tugmalardagi harflar
  late List<bool> used;            // qaysi tugma bosilgan

  @override
  void initState() {
    super.initState();
    _setupLevel();
  }

  String _clean(String s) => s.replaceAll(' ', '');

  void _setupLevel() {
    final cleaned = _clean(levels[currentLevel]);
    _allShuffled = cleaned.split('');
    _allShuffled.shuffle(Random());     // 🔹 faqat level boshida shuffle

    remaining = List.of(_allShuffled);
    used = List.filled(remaining.length, false);
    selected.clear();
    setState(() {});
  }

  void _onLetterTap(int index) {
    if (used[index]) return; // allaqachon bosilgan bo'lsa, ishlamasin

    final targetLen = _clean(levels[currentLevel]).length;
    setState(() {
      selected.add(remaining[index]);
      used[index] = true; // 🔹 tugma bosildi (lekin tugmada harf ko'rinib turadi)
    });

    if (selected.length == targetLen) {
      _checkAnswer();
    }
  }

  void _checkAnswer() {
    final original = _clean(levels[currentLevel]);
    final attempt = selected.join();

    if (attempt == original) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: const Text("✅ To‘g‘ri javob!", style: TextStyle(color: Colors.white)),
        ),
      );
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          if (currentLevel < levels.length - 1) {
            currentLevel++;
            _setupLevel();
          } else {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Colors.white,
                title: const Text("🎉 O‘yin tugadi", style: TextStyle(color: Colors.black)),
                content: const Text("Barcha levelni o‘tdingiz!", style: TextStyle(color: Colors.black)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      currentLevel = 0;
                      _setupLevel();
                    },
                    child: Text("Qaytadan o‘ynash", style: TextStyle(color: Colors.cyan.shade800)),
                  ),
                ],
              ),
            );
          }
        });
      });
    } else {
      // ❗️Siz xohlaganingiz: xato bo'lsa tugmalar avtomatik qayta chiqmasin.
      // Shuning uchun faqat kataklarni tozalaymiz, tugmalar holatini o'zgartirmaymiz.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text("❌ Xato, RESET bosib qaytadan urinib ko‘ring!", style: TextStyle(color: Colors.white)),
        ),
      );
      setState(() {
        selected.clear();             // kataklar bo'shadi
        // used O'ZGARMAYDI → tugmalar disabled holda qoladi
        // remaining O'ZGARMAYDI → tugmalar joyi o'zgarmaydi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sentence = levels[currentLevel];   // masalan: "MEN VA SEN"
    final parts = sentence.split(' ');       // ["MEN", "VA", "SEN"]

    // Har bir so'zning global boshlanish indekslari (bo'shliqsiz)
    final offsets = <int>[];
    var acc = 0;
    for (final p in parts) {
      offsets.add(acc);
      acc += p.length;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Word Rush"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text("Level ${currentLevel + 1}", style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // So'zlar qatorma-qator kataklarda
          Column(
            children: [
              for (var wi = 0; wi < parts.length; wi++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(parts[wi].length, (j) {
                    final globalIndex = offsets[wi] + j;
                    final char = globalIndex < selected.length ? selected[globalIndex] : '';
                    return Container(
                      margin: const EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.cyan.shade800, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          char,
                          style: const TextStyle(fontSize: 28, color: Colors.black),
                        ),
                      ),
                    );
                  }),
                ),
            ],
          ),

          const SizedBox(height: 50),

          // Harflar tugmalari (bosilganda DISABLED, lekin harf ko'rinadi)
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: List.generate(remaining.length, (i) {
              final letter = remaining[i];
              return ElevatedButton(
                onPressed: used[i] ? null : () => _onLetterTap(i),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(25)),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.white; // 🔹 bosilganda oq fon
                    }
                    return Colors.cyan.shade800; // 🔹 oddiy holatda cyan
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.black; // 🔹 bosilganda harf qora ko'rinsin
                    }
                    return Colors.white; // 🔹 oddiy holatda harf oq
                  }),
                  side: MaterialStateProperty.resolveWith<BorderSide?>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return BorderSide(color: Colors.cyan.shade800, width: 2); // 🔹 oq tugmada cyan chegara
                    }
                    return null;
                  }),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: Text(letter, style: const TextStyle(fontSize: 24)),
              );
            }),
          ),

          const SizedBox(height: 40),

          // RESET tugmasi (faqat shunda tugmalar yana ishlaydi)
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                selected.clear();
                used = List.filled(remaining.length, false); // 🔹 tugmalarni qayta yoqish
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.black),
            label: const Text("RESET", style: TextStyle(fontSize: 18, color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
