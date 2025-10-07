import 'package:wordgame/library.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.cyan.shade800,
        elevation: 0,
        centerTitle: true,
        leading: Container(),
        title: Text(
          "SO'Z O'YINLARI",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            wordSpacing: 1,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black54,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Get.to(AccountPage()),
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.transparent,
                child: Image(image: AssetImage("assets/icons/account.png")),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 80, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton("O'yinlar", "games", 0),
            buildButton("Online  Battle", "battle", 1),
            SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(LeagueRanking()),
        backgroundColor: Colors.cyan.shade800,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Image(image: AssetImage("assets/icons/ranking.png")),
        ),
      ),
    );
  }

  Widget buildButton(String text, String icon, index) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: GestureDetector(
          onTap: () => Get.to(CategoryPage(index)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.cyan.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Expanded(
                  child: Center(
                    child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        shadows: [
                          BoxShadow(
                            offset: Offset(1.2, 1),
                            color: Colors.black,
                            blurRadius: 2,
                          ),
                        ]
                      ),
                    ),
                  ),
                ),
                Image(image: AssetImage("assets/icons/$icon.png")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
