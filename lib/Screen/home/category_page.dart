import 'package:wordgame/library.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final categories = [
    {'icon': "hangman", 'label': "Jallod"},
    {'icon': "millioner", 'label': "Millioner"},
    {'icon': "crossword", 'label': 'Krassvord'},
    {'icon': "hiddenwords", 'label': "Yashirin so'zlar"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 60.h,
        title: Text(
          "O'yin turini tanlang",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
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
        backgroundColor: Colors.cyan.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 100.h),
          child: GridView.builder(
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 20.w,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _AnimatedCategoryButton(
                icon: category['icon'] as String,
                label: category['label'] as String,
                onTap: () => Get.to(StepsPage(category: category['icon']!)),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AnimatedCategoryButton extends StatefulWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  _AnimatedCategoryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedCategoryButton> createState() =>
      _AnimatedCategoryButtonState();
}

class _AnimatedCategoryButtonState extends State<_AnimatedCategoryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateAndNavigate() async {
    await _controller.reverse();
    await _controller.forward();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animateAndNavigate,
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 4.r,
                offset: Offset(2, 2),
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 4.r,
                offset: Offset(-1, -1),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: widget.icon == 'hangman' ? 10.h : 0),
              Image(
                image: AssetImage("assets/images/${widget.icon}.png"),
                height: widget.icon == 'hangman' ? 80.h : 100.h,
              ),
              SizedBox(height: widget.icon == 'hangman' ? 10.h : 4.h),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
