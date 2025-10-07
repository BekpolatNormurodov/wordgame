import 'package:flutter/material.dart';

class LeagueRanking extends StatefulWidget {
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
    {
      "name": "Siz",
      "score": 1450,
      "avatar": "https://i.pravatar.cc/150?img=3",
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
          title: const Text(
            "🏆 Reyting",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: .8,
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
          centerTitle: true,
        ),
        body: Column(
          children: [
            ClipRRect(
              child: Container(
                height: 48,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.cyan.shade200,
                ),
                child: TabBar(
                  labelPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.cyan.shade800,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(color: Colors.cyan.shade900, fontSize: 15, fontWeight: FontWeight.w600),
                  tabs: [
                    TabItem(title: 'Tasodify'),
                    TabItem(title: 'Ingliz tili'),
                    TabItem(title: 'Krassvord'),
                    TabItem(title: 'Diniy'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  league(),
                  league(),
                  league(),
                  league(),
                ],
              ),
            )
          ],
        ),
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
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
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
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isYou ? Colors.cyan.shade200 : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.cyan.shade200),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isYou
                              ? Colors.cyan.shade900
                              : Colors.cyan.shade800,
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(player['avatar']),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          player["name"],
                          style: TextStyle(
                            fontWeight:
                                isYou ? FontWeight.bold : FontWeight.w500,
                            color:
                                isYou ? Colors.cyan.shade900 : Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        "${player["score"]} ball",
                        style: TextStyle(
                          fontSize: 14,
                          color: isYou
                              ? Colors.cyan.shade900
                              : Colors.grey.shade800,
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

  const TabItem({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
