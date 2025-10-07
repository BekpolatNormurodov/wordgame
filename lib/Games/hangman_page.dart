import '../library.dart';

class HangmanPage extends StatefulWidget {
  const HangmanPage({super.key});

  @override
  State<HangmanPage> createState() => _HangmanPageState();
}

class _HangmanPageState extends State<HangmanPage> {
  String characters = 'abcdefghijklmnopqrstuvwxyz'.toUpperCase();
  List<String> selectedChar = [];
  int tries = 0;
  int dateIndex = 2;
  int categoryIndex = 0;
  WordProvider? provider;
  final player = AudioPlayer();

  @override
  void initState() {
    provider = context.read<WordProvider>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider!.getData();
    });
    provider?.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return provider!.state == WordState.intial
        ? Container()
        : provider!.state == WordState.waiting
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.green.shade200,
                  backgroundColor: Colors.green.shade800,
                  strokeWidth: 20.w,
                ),
              )
            : provider!.state == WordState.error
                ? Center(
                    child: Text(
                      "Malumotlar mavjud emas!!!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                  )
                : Scaffold(
                    backgroundColor: Colors.cyan,
                    appBar: AppBar(
                      toolbarHeight: 80,
                      leading: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${categoryIndex + 1}",
                          style: TextStyle(
                            color: Colors.deepPurpleAccent.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      title: Text(
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        provider!.data[dateIndex].category,
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            shadows: [
                              BoxShadow(
                                offset: Offset(.5, .5),
                                color: Colors.pink,
                                blurRadius: 2,
                              )
                            ]),
                      ),
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    body: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Stack(
                                    children: [
                                      figure(GameUI.img0, tries >= 0),
                                      figure(GameUI.img1, tries >= 1),
                                      figure(GameUI.img2, tries >= 2),
                                      figure(GameUI.img3, tries >= 3),
                                      figure(GameUI.img4, tries >= 4),
                                      figure(GameUI.img5, tries >= 5),
                                      figure(GameUI.img6, tries >= 6),
                                    ],
                                  )),
                              if (provider!.data.isNotEmpty)
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: provider!.data[dateIndex].word
                                          .toUpperCase()
                                          .split('')
                                          .map((e) => hiddenLetter(
                                              e,
                                              !selectedChar
                                                  .contains(e.toUpperCase())))
                                          .toList(),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 7,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              children: characters.split('').map(
                                (e) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: Colors.black54,
                                    ),
                                    onPressed: selectedChar
                                            .contains(e.toUpperCase())
                                        ? null
                                        : () {
                                            setState(() {
                                              selectedChar.add(e.toUpperCase());
                                              if (!provider!
                                                  .data[dateIndex].word
                                                  .toUpperCase()
                                                  .split('')
                                                  .contains(e.toUpperCase())) {
                                                playErrorSound();
                                                Vibration.vibrate(
                                                    duration: 200);
                                                tries++;
                                                if (tries >= 5) {
                                                  showLoseDialog();
                                                }
                                              } else {
                                                Vibration.vibrate(
                                                    duration: 200);
                                                playSuccessSound();
                                                showSuccessDialog();
                                              }
                                            });
                                          },
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
  }

  void playErrorSound() async {
    await player.setVolume(1);
    await player.play(AssetSource('voice/error.mp3'));

    player.onPlayerStateChanged.listen((state) async {
      if (state == PlayerState.playing) {
        await player.seek(Duration(milliseconds: 500));
      }
    });
  }

  void playSuccessSound() async {
    await player.setVolume(0.2);
    await player.play(AssetSource('voice/success.mp3'));

    Future.delayed(Duration(seconds: 2), () {
      player.stop();
    });
  }

  // bitta so‘zda nechta takrorlanmagan (yagona) harflar borligini aniqlab beradigan function
  int countDistinctLetters(String word) {
    word = word.toLowerCase(); // katta-kichik farqini yo‘qotish
    Set<String> uniqueLetters = {};

    for (var char in word.runes) {
      String letter = String.fromCharCode(char);
      if (RegExp(r'[a-z]').hasMatch(letter)) {
        // faqat lotin harflar
        uniqueLetters.add(letter);
      }
    }

    return uniqueLetters.length;
  }

// its TRUE
  void showSuccessDialog() {
    String word = provider!.data[dateIndex].word.toUpperCase();
    bool allCorrect =
        word.split('').every((char) => selectedChar.contains(char));

    if (allCorrect) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("🎉 Tabriklaymiz!",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Siz so'zni to'liq topdingiz.\nKeyingi bosqichga o'tasizmi?"),
                    SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 4),
                    Text("Ball: $categoryIndex"),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFA726),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // dialogni yopish
                // goToNextWord(); // bu sizning keyingi so‘zga o‘tish funksiyangiz bo‘lishi kerak
              },
              child: Text("Keyingi bosqich"),
            ),
          ],  
        ),
      );
    }
  }

  void showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              Icon(Icons.sentiment_dissatisfied, size: 48, color: Colors.red),
              SizedBox(height: 8),
              Text(
                "Yutqazdingiz",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("To'g'ri topilgan javoblar: $categoryIndex"),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 4),
                  Text("Ball: $categoryIndex"),
                ],
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.home),
                  label: Text("Uyga"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA726),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.replay),
                  label: Text("Qaytarish"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // restartGame();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
}



Widget hiddenLetter(String char, bool visible) {
  return Container(
    width: 50.0,
    height: 50.0,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.white,
    ),
    child: Visibility(
        visible: !visible,
        child: Text(
          char,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: AppColors.textColor,
          ),
        )),
  );
  
}


Widget figure(String path, bool visible) {
  return SizedBox(
    width: 250.0,
    height: 250.0,
    child: Visibility(
      visible: visible,
      child: Image.asset(path),
    ),
  );
}
