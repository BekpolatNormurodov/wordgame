import 'package:wordgame/library.dart';

class HangmanPage extends StatefulWidget {
   HangmanPage({super.key});

  @override
  State<HangmanPage> createState() => _HangmanPageState();
}

class _HangmanPageState extends State<HangmanPage> {
  final String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final List<String> selectedChar = [];
  int tries = 0;
  int dateIndex = 2;
  int categoryIndex = 0;
  WordProvider? provider;
  final player = AudioPlayer();
  VoidCallback? _providerListener;

  @override
  void initState() {
    super.initState();

    provider = context.read<WordProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider?.getData();
    });

    // listener yaratamiz
    _providerListener = () {
      if (mounted) {
        setState(() {});
      }
    };

    provider?.addListener(_providerListener!);
  }

  @override
  void dispose() {
    // endi faqat _providerListener mavjud bo‘lsa tozalaymiz
    if (_providerListener != null) {
      provider?.removeListener(_providerListener!);
    }
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (provider == null) return  SizedBox();

    switch (provider!.state) {
      case WordState.intial:
        return  SizedBox();

      case WordState.waiting:
        return Center(
          child: CircularProgressIndicator(
            color: Colors.green.shade200,
            backgroundColor: Colors.green.shade800,
            strokeWidth: 20.w,
          ),
        );

      case WordState.error:
        return  Center(
          child: Text(
            "Ma'lumotlar mavjud emas!!!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        );

      case WordState.success:
        return Scaffold(
          backgroundColor: Color.fromRGBO(66, 27, 155, 1),
          appBar: AppBar(
            toolbarHeight: 70.h,
            leading: Container(
              margin:  EdgeInsets.symmetric(horizontal: 10.w),
              decoration:  BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                "${categoryIndex + 1}",
                style: TextStyle(
                  color: Colors.deepPurpleAccent.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
              ),
            ),
            title: Text(
              provider!.data[dateIndex].category,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                color: Color.fromRGBO(47, 151, 255, 1),
                fontWeight: FontWeight.bold,
                fontSize: 26.sp,
                shadows: [
                  BoxShadow(
                    offset: Offset(.5, .5),
                    color: Colors.black,
                    blurRadius: 2,
                  )
                ],
              ),
            ),
            actions: [
              Icon(
                Icons.home,
                size: 30.sp,
                color: Colors.white,
              ),
              SizedBox(width: 12.w)
            ],
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
                      ),
                    ),
                    if (provider!.data.isNotEmpty)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: provider!.data[dateIndex].word
                                .toUpperCase()
                                .split('')
                                .map((e) => hiddenLetter(
                                      e,
                                      !selectedChar.contains(e.toUpperCase()),
                                      provider!.data[dateIndex].word.length,
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: GridView.count(
                    physics:  NeverScrollableScrollPhysics(),
                    crossAxisCount: 7,
                    mainAxisSpacing: 10.w,
                    crossAxisSpacing: 8.h,
                    children: characters.split('').map((e) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                          padding: EdgeInsets.zero,
                          backgroundColor: Color.fromRGBO(7, 126, 245, 1),
                        ),
                        onPressed: selectedChar.contains(e.toUpperCase())
                            ? null
                            : () {
                                setState(() {
                                  selectedChar.add(e.toUpperCase());
                                  if (!provider!.data[dateIndex].word
                                      .toUpperCase()
                                      .split('')
                                      .contains(e.toUpperCase())) {
                                    playErrorSound();
                                    Vibration.vibrate(duration: 200);
                                    tries++;
                                    if (tries >= 5) {
                                      showLoseDialog();
                                    }
                                  } else {
                                    Vibration.vibrate(duration: 200);
                                    playSuccessSound();
                                    showSuccessDialog();
                                  }
                                });
                              },
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  // 🔊 ERROR tovushi
  void playErrorSound() async {
    await player.setVolume(1);
    await player.play(AssetSource('voice/error.mp3'));
  }

  // 🔊 SUCCESS tovushi
  void playSuccessSound() async {
    await player.setVolume(0.2);
    await player.play(AssetSource('voice/success.mp3'));
    Future.delayed( Duration(seconds: 2), () {
      player.stop();
    });
  }

  // ✅ To‘g‘ri topganda
  void showSuccessDialog() {
    String word = provider!.data[dateIndex].word.toUpperCase();
    bool allCorrect =
        word.split('').every((char) => selectedChar.contains(char));

    if (!allCorrect) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title:  Text("🎉 Tabriklaymiz!",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          height: 72.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                  "Siz so'zni to'liq topdingiz.\nKeyingi bosqichga o'tasizmi?"),
               SizedBox(height: 8.h),
              Row(
                children: [
                   Icon(Icons.star, color: Colors.amber),
                   SizedBox(width: 4.w),
                  Text("Ball: $categoryIndex"),
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:  Color(0xFFFFA726),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child:  Text("Keyingi bosqich"),
          ),
        ],
      ),
    );
  }

  // ❌ Yutqazganda
  void showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          title:  Column(
            children:  [
              Icon(Icons.sentiment_dissatisfied, size: 48.sp, color: Colors.red),
              SizedBox(height: 8.h),
              Text(
                "Yutqazdingiz",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("To'g'ri topilgan javoblar: $categoryIndex"),
               SizedBox(height: 8.h),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 4.w),
                  Text("Ball: "),
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
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon:  Icon(Icons.home),
                  label:  Text("Uyga"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color(0xFFFFA726),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon:  Icon(Icons.replay),
                  label:  Text("Qaytarish"),
                  onPressed: () {
                    Navigator.of(context).pop();
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

// 🔡 Harfni yashirish uchun vidjet
Widget hiddenLetter(String char, bool visible, int count) {
  return Container(
    width: count <= 7
        ? 40.w
        : count == 8
            ? 36.w
            : count == 9
                ? 33.w
                : 30.w,
    height: count <= 7
        ? 40.w
        : count == 8
            ? 38.w
            : count == 9
                ? 34.w
                : 32.w,
    margin: EdgeInsets.symmetric(
        horizontal: count <= 7
            ? 4.w
            : count == 8
                ? 3.w
                : count == 9
                    ? 2.5.w
                    : 2.w),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      color: Colors.white,
    ),
    child: Visibility(
      visible: !visible,
      child: Text(
        char,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22.sp,
          color: Colors.black87,
        ),
      ),
    ),
  );
}

// 🖼️ Rasm ko‘rsatish
Widget figure(String path, bool visible) {
  return SizedBox(
    width: 250.0.w,
    height: 250.0.w,
    child: Visibility(
      visible: visible,
      child: Image.asset(path),
    ),
  );
}


class GameUI {
  static const img0 = "assets/images/hangman/0.png";
  static const img1 = "assets/images/hangman/1.png";
  static const img2 = "assets/images/hangman/2.png";
  static const img3 = "assets/images/hangman/3.png";
  static const img4 = "assets/images/hangman/4.png";
  static const img5 = "assets/images/hangman/5.png";
  static const img6 = "assets/images/hangman/6.png";
}