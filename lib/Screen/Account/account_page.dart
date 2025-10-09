import 'package:wordgame/library.dart';
import 'dart:io';

class AccountPage extends StatefulWidget {
  AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with TickerProviderStateMixin {
  final TextEditingController nameController =
      TextEditingController(text: "User 1");
  File? profileImage;
  bool isLanguageDropdownOpen = false;
  String selectedLanguage = 'uzb';
  List<String> languages = ['uzb', 'rus'];

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade800,
        leading: GestureDetector(onTap: ()=>Get.back(), child: Icon(Icons.arrow_back, color: Colors.white,),),
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 22.sp,
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 12.h, bottom: 26.h),
        child: Column(
          children: [
            // Avatar
            SizedBox(
              height: 120.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.cyan.shade700, width: 2),
                        image: DecorationImage(
                          image: profileImage != null
                              ? FileImage(profileImage!)
                              : AssetImage('assets/icons/face.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: profileImage == null
                          ? Icon(
                              Icons.add_a_photo,
                              color: Colors.cyan.shade900,
                              size: 32.sp,
                            )
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 90.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 14.w),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                        cursorColor: Colors.cyan.shade800,
                        cursorWidth: 1.6,
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.15)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.15)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.cyan.shade800),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 🌙 Dark Mode
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.03)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        color: Colors.cyan.shade800,
                        size: 28.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Tungi rejim",
                        style: TextStyle(fontSize: 16.sp, color: Colors.black),
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: .8,
                    child: Switch(
                      value: false,
                      inactiveTrackColor: Colors.cyan.shade800,
                      inactiveThumbColor: Colors.white,
                      activeColor: Colors.red,
                      activeTrackColor: Colors.yellowAccent,
                      onChanged: (val) {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // 🌐 Til tanlash
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLanguageDropdownOpen = !isLanguageDropdownOpen;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.03)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language,
                                color: Colors.cyan.shade700, size: 28.sp),
                            SizedBox(width: 12.w),
                            Text(
                              "Tilni tanlang",
                              style:
                                  TextStyle(fontSize: 16.sp, color: Colors.black),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: Text(
                            selectedLanguage.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.cyan.shade800,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4),

                // 🔽 Animatsiya bilan ochiladigan qism
                ClipRect(
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: ConstrainedBox(
                      constraints: isLanguageDropdownOpen
                          ? BoxConstraints()
                          : BoxConstraints(maxHeight: 0),
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color.fromRGBO(0, 0, 0, 0.1)),
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        child: Column(
                          children: languages.asMap().entries.map((entry) {
                            final lang = entry.value;

                            // Navbatdagi fon rang
                            final backgroundColor = Color.fromRGBO(0, 0, 0, 0.1);

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 1.w, horizontal: 2.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: backgroundColor,
                              ),
                              child: ListTile(
                                contentPadding:
                                     EdgeInsets.symmetric(horizontal: 20.w),
                                title: Text(
                                  lang.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                trailing: selectedLanguage == lang
                                    ? Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: Icon(Icons.check,
                                          color: Colors.cyan.shade800),
                                    )
                                    : null,
                                onTap: () {
                                  setState(() {
                                    selectedLanguage = lang;
                                    isLanguageDropdownOpen = false;
                                  });
                                },
                                splashColor: Colors.transparent,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),

            // 💾 Saqlash tugmasi
            Container(
              margin: EdgeInsets.only(bottom: 20.h),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade800,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'SAQLASH',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
