import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MillionerPage extends StatefulWidget {
  const MillionerPage({super.key});

  @override
  State<MillionerPage> createState() => _MillionerPageState();
}

class _MillionerPageState extends State<MillionerPage> {
  int? selected;
  int correct = 2;
  int vaqt = 25;
  Timer? taymer;

  final List<Map<String, String>> javoblar = [
    {"label": "A", "text": "Black"},
    {"label": "B", "text": "Brown"},
    {"label": "C", "text": "White & Black"},
    {"label": "D", "text": "White"},
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    vaqt = 25;
    taymer?.cancel();
    taymer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (vaqt > 0) {
        setState(() => vaqt--);
      } else {
        t.cancel();
      }
    });
  }

  void onSelect(int i) {
    if (selected != null) return;
    setState(() => selected = i);
  }

  Color getColor(int i) {
    if (selected == null) return const Color(0xFF001B77);
    if (i == selected && i == correct) return const Color(0xFF00C853); // green
    if (i == selected && i != correct) return const Color(0xFFFF1744); // red
    if (i == correct) return const Color(0xFF00C853); // correct
    return const Color(0xFF001B77); // normal blue
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E0064),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🟡 Upper section (Timer + Money banner)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconButton(Icons.directions_run),
                _timerCircle(),
                _iconButton(Icons.attach_money),
              ],
            ),

            const SizedBox(height: 10),

            // 💰 Money banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 70),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "\$25,000",
                  style: GoogleFonts.orbitron(
                    fontSize: 22,
                    color: Colors.deepPurple.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ❓ Question box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0033A0), Color(0xFF000B40)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                "What is color of Panda?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Answer options
            ...List.generate(javoblar.length, (i) {
              final color = getColor(i);
              return GestureDetector(
                onTap: () => onSelect(i),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  height: 55,
                  child: ClipPath(
                    clipper: TrapetsiyaClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.95),
                            color.withOpacity(0.75),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Text(
                            "${javoblar[i]["label"]}:",
                            style: GoogleFonts.poppins(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              javoblar[i]["text"]!,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ⏱ Timer circle
  Widget _timerCircle() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.amber, width: 5),
        gradient: const RadialGradient(
          colors: [Color(0xFF290066), Color(0xFF1A004D)],
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 3))
        ],
      ),
      child: Center(
        child: Text(
          "$vaqt",
          style: GoogleFonts.orbitron(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 🔘 Upper corner icons
  Widget _iconButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3A1B7D),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: const [
          BoxShadow(
              color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}

// 🧱 Trapetsiya variant shakli
class TrapetsiyaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    double cut = 3;

    Path path = Path();
    path.moveTo(cut, 0);
    path.lineTo(w - cut, 0);
    path.lineTo(w, h / 2);
    path.lineTo(w - cut, h);
    path.lineTo(cut, h);
    path.lineTo(0, h / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
