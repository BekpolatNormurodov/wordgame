import 'package:wordgame/library.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({super.key});

  @override
  State<StepsPage> createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade800,
        title: const Text(
          "100 QADAMLI YO'L 🚩",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: .6,
            wordSpacing: 1.5,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black54,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          childAspectRatio: 3 *
              MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        itemCount: 100,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Get.to(HangmanPage()),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.cyan.shade600,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}-qadam",
                        style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            letterSpacing: 1,
                            wordSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                offset: Offset(.8, .6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_border_outlined,
                            color: Colors.black45, size: 21),
                        Icon(Icons.star_border_outlined,
                            color: Colors.black45, size: 21),
                        Icon(Icons.star_border_outlined,
                            color: Colors.black45, size: 21),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
