import 'package:wordgame/library.dart';

class StepsPage extends StatefulWidget {
  StepsPage({super.key});

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
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Jallod",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
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
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 20.h,
          childAspectRatio:
              3 *
              MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: 100,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Get.to(MillionerPage()),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: index == 0 ? Colors.cyan.shade800 : Colors.black45,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "level ${index + 1}",
                        style: GoogleFonts.robotoSlab(
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
                  index == 0
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_border_outlined,
                                color: Colors.black45,
                                size: 22.sp,
                              ),
                              Icon(
                                Icons.star_border_outlined,
                                color: Colors.black45,
                                size: 22.sp,
                              ),
                              Icon(
                                Icons.star_border_outlined,
                                color: Colors.black45,
                                size: 22.sp,
                              ),
                            ],
                          ),
                        )
                      : index == 0
                          ? Container()
                          : Icon(
                              Icons.lock,
                              color: Colors.black45,
                              size: 30.sp,
                            ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
