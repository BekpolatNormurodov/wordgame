import 'package:wordgame/library.dart';
import 'dart:math' as math;


class WordFindingPage extends StatefulWidget {
  const WordFindingPage({super.key});

  @override
  _WordFindingPageState createState() => _WordFindingPageState();
}

class _WordFindingPageState extends State<WordFindingPage>
    with SingleTickerProviderStateMixin {
  late final List<List<String>> stages;
  late List<String> words;

  String? targetWord;
  String? wrongWord;
  String? correctWord;

  int lives = 3;
  int stageIndex = 0;
  final Random _rnd = Random();

  late final AnimationController _targetFade;

  @override
  void initState() {
    super.initState();

    final stage1 = [
      "Olma","Anor","Banan","Uzum","Shaftoli","Behi","Gilos","Qovun","Tarvuz","Anjir",
      "Limon","Apelsin","Mandarin","Kivi","Greypfrut","Nok","Olxo‘ri","Xurmo","Avokado","Mango",
      "Papayya","Kokos","Bodring","Pomidor","Kartoshka","Sabzi","Piyoz","Sarimsoq","Karam","Salat",
      "Qovoq","Ismaloq","Sholg‘om","No‘xat","Mosh","Loviya","Guruch","Bug‘doy","Un","Non",
      "Asal","Sut","Yog‘","Pishloq","Qatiq","Go‘sht","Choy","Qahva","Shakar","Tuz"
    ];

    final stage2 = [
      "It","Mushuk","Ot","Sigir","Qo‘y","Eshak","Quyon","Sher","Bo‘ri","Tulki",
      "Ayik","Fil","Maymun","Baliq","Qaldirg‘och","Qarg‘a","Tovuq","O‘rdak","G‘oz","Ilon",
      "Qurbaqa","Chayon","Arslon","Yo‘lbars","Jirafa","Kenguru","Panda","Delfin","Akula","To‘ng‘iz",
      "Burgut","Qoplon","Kalamush","Tovus","Chumoli","Asalari","Kapalak","Qirg‘iy","Sichqon","Tulpor",
      "Bo‘ta","Malla","Buzoq","Echki","Qaqnus","Shoxli echki","Qumursqa","Quzg‘un","Xonqizi","Bo‘ri baliqchi"
    ];

    final stage3 = [
      "O‘qituvchi","Shifokor","Muhandis","Dasturchi","Haydovchi","Politsiyachi","Yozuvchi","Rassom","Ashulachi","Raqschi",
      "Arxitektor","Advokat","Sudya","Professor","Talaba","Tikuvchi","Oshpaz","Qassob","Sartarosh","Bog‘bon",
      "Dehqon","Sotuvchi","Fotograf","Operator","Jurnalist","Aktyor","Ilmiy xodim","Elektrik","Duradgor","Buxgalter",
      "Kassir","Bankir","Direktor","Meneger","Dizayner","Navigator","Pilot","Styuardessa","Kosmonavt","Mexanik",
      "Haykaltarosh","Tarjimon","Shoir","Sportchi","Trener","Biznesmen","Farmatsevt","Kutubxonachi","Quruvchi","Dispecher"
    ];

    stages = [stage1, stage2, stage3];
    words = List.from(stages[stageIndex]);

    _targetFade =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _setNewTarget();
  }

  @override
  void dispose() {
    _targetFade.dispose();
    super.dispose();
  }

  void _setNewTarget() {
    if (words.isNotEmpty) {
      targetWord = words[_rnd.nextInt(words.length)];
      wrongWord = null;
      correctWord = null;
      _targetFade.forward(from: 0);
    } else {
      targetWord = null;
    }
    setState(() {});
  }

  void _onCorrectTap(String word) {
    correctWord = word;
    setState(() {});

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      words.remove(word);
      correctWord = null;

      if (words.isNotEmpty) {
        _setNewTarget();
      } else {
        _nextStage();
      }
    });
  }

  void _onWrongTap(String word) {
    wrongWord = word;
    lives--;
    setState(() {});

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      if (wrongWord == word) {
        wrongWord = null;
        setState(() {});
      }
    });

    if (lives <= 0) {
      _showGameOverDialog("😢 O‘yin tugadi. Yana urinib ko‘ring!");
    }
  }

  void _checkWord(String word) {
    if (word == targetWord) {
      _onCorrectTap(word);
    } else {
      _onWrongTap(word);
    }
  }

  void _nextStage() {
    if (stageIndex < stages.length - 1) {
      stageIndex++;
      words = List.from(stages[stageIndex]);
      lives = 3;
      _setNewTarget();
      _showStageDialog("✅ Bosqich ${stageIndex} tugadi! Keyingisiga o‘tasiz.");
    } else {
      _showGameOverDialog("🎉 Tabriklaymiz! Siz barcha 3 bosqichni yutdingiz!");
    }
  }

  void _showStageDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Davom etish"),
          )
        ],
      ),
    );
  }

  void _showGameOverDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _restartGame();
            },
            child: const Text("Qayta o‘ynash"),
          )
        ],
      ),
    );
  }

  void _restartGame() {
    stageIndex = 0;
    words = List.from(stages[stageIndex]);
    lives = 3;
    _setNewTarget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("So‘z Topish O‘yini — Bosqich ${stageIndex + 1}"),
        actions: [
          Row(
            children: List.generate(
              lives,
              (index) => const Icon(Icons.favorite, color: Colors.red),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // So‘zlar
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.spaceAround,
                children: words.map((word) {
                  final isWrong = word == wrongWord;
                  final isCorrect = word == correctWord;

                  Widget chip = Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isWrong
                          ? Colors.red.shade400
                          : isCorrect
                              ? Colors.green.shade400
                              : Colors.cyan.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.shade100,
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        )
                      ],
                    ),
                    child: Text(
                      word,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isWrong || isCorrect
                            ? Colors.white
                            : Colors.cyan.shade700,
                      ),
                    ),
                  );

                  // ❌ faqat xato bosilganda shake
                  if (isWrong) {
                    chip = TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 350),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, t, child) {
                        final dx = math.sin(t * math.pi * 6) * 6;
                        return Transform.translate(
                            offset: Offset(dx, 0), child: child);
                      },
                      child: chip,
                    );
                  }

                  // ✅ to‘g‘ri bosilganda pulse
                  if (isCorrect) {
                    chip = TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween<double>(begin: 1.0, end: 1.2),
                      builder: (context, scale, child) =>
                          Transform.scale(scale: scale, child: child),
                      child: chip,
                    );
                  }

                  return GestureDetector(
                    onTap: () => _checkWord(word),
                    child: chip,
                  );
                }).toList(),
              ),
            ),
          ),

          // Target so‘z
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.cyan.shade700,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: FadeTransition(
                  opacity: _targetFade,
                  child: Text(
                    targetWord ?? "✅ Barcha so‘zlar topildi!",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
