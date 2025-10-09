import 'package:wordgame/library.dart';

class LeagueRanking extends StatefulWidget {
  LeagueRanking({super.key});

  @override
  State<LeagueRanking> createState() => _LeagueRankingState();
}

class _LeagueRankingState extends State<LeagueRanking> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final List<Map<String, dynamic>> players = [
    {
      "name": "Dilshod",
      "score": 1800,
      "avatar": "https://i.pravatar.cc/150?img=1",
    },
    {
      "name": "Alisher",
      "score": 1670,
      "avatar": "https://i.pravatar.cc/150?img=2",
    },
    {"name": "Siz", "score": 1450, "avatar": "https://i.pravatar.cc/150?img=3"},
    {
      "name": "Aziza",
      "score": 1300,
      "avatar": "https://i.pravatar.cc/150?img=4",
    },
    {
      "name": "Kamron",
      "score": 1180,
      "avatar": "https://i.pravatar.cc/150?img=5",
    },
    {
      "name": "Dilshod",
      "score": 1800,
      "avatar": "https://i.pravatar.cc/150?img=1",
    },
    {
      "name": "Alisher",
      "score": 1670,
      "avatar": "https://i.pravatar.cc/150?img=2",
    },
    {
      "name": "Aziza",
      "score": 1300,
      "avatar": "https://i.pravatar.cc/150?img=4",
    },
    {
      "name": "Kamron",
      "score": 1180,
      "avatar": "https://i.pravatar.cc/150?img=5",
    },
    {
      "name": "Dilshod",
      "score": 1800,
      "avatar": "https://i.pravatar.cc/150?img=1",
    },
    {
      "name": "Alisher",
      "score": 1670,
      "avatar": "https://i.pravatar.cc/150?img=2",
    },
    {
      "name": "Aziza",
      "score": 1300,
      "avatar": "https://i.pravatar.cc/150?img=4",
    },
    {
      "name": "Kamron",
      "score": 1180,
      "avatar": "https://i.pravatar.cc/150?img=5",
    },
    {
      "name": "Dilshod",
      "score": 1800,
      "avatar": "https://i.pravatar.cc/150?img=1",
    },
    {
      "name": "Alisher",
      "score": 1670,
      "avatar": "https://i.pravatar.cc/150?img=2",
    },
    {
      "name": "Aziza",
      "score": 1300,
      "avatar": "https://i.pravatar.cc/150?img=4",
    },
    {
      "name": "Kamron",
      "score": 1180,
      "avatar": "https://i.pravatar.cc/150?img=5",
    },
    {
      "name": "Aziza",
      "score": 1300,
      "avatar": "https://i.pravatar.cc/150?img=4",
    },
    {
      "name": "Kamron",
      "score": 1180,
      "avatar": "https://i.pravatar.cc/150?img=5",
    },
    {
      "name": "Dilshod",
      "score": 1800,
      "avatar": "https://i.pravatar.cc/150?img=1",
    },
    {
      "name": "Alisher",
      "score": 1670,
      "avatar": "https://i.pravatar.cc/150?img=2",
    },
    {
      "name": "Aziza",
      "score": 1300,
      "avatar": "https://i.pravatar.cc/150?img=4",
    },
    {
      "name": "Kamron",
      "score": 1180,
      "avatar": "https://i.pravatar.cc/150?img=5",
    },
    {
      "name": "Dilshod",
      "score": 1800,
      "avatar": "https://i.pravatar.cc/150?img=1",
    },
    {
      "name": "Alisher",
      "score": 1670,
      "avatar": "https://i.pravatar.cc/150?img=2",
    },
    {
      "name": "Aziza",
      "score": 1300,
      "avatar": "https://i.pravatar.cc/150?img=4",
    },
    {
      "name": "Kamron",
      "score": 1180,
      "avatar": "https://i.pravatar.cc/150?img=5",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.cyan.shade100,
        appBar: AppBar(
          backgroundColor: Colors.cyan.shade800,
          leading: GestureDetector(onTap: ()=>Get.back(), child: Icon(Icons.arrow_back, color: Colors.white),),
          title: Text(
            "🏆 Reyting",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: .8,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 4.0.r,
                  color: Colors.black54,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: league(),
      ),
    );
  }

  league() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.shade100,
            blurRadius: 5.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                final isYou = player["name"] == "Siz";

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isYou ? Colors.cyan.shade200 : Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isYou
                          ? Colors.cyan.shade300
                          : Colors.cyan.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isYou ? Colors.black : Colors.cyan.shade800,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      CircleAvatar(
                        radius: 18.r,
                        backgroundImage: NetworkImage(player['avatar']),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          player["name"],
                          style: TextStyle(
                            fontWeight: isYou
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: isYou ? Colors.black : Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        "${player["score"]} ball",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isYou ? Colors.black : Colors.grey.shade800,
                          fontWeight: isYou ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;

  TabItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Tab(child: Text(title, overflow: TextOverflow.ellipsis));
  }
}
