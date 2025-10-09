import 'package:wordgame/library.dart';
import 'dart:io';

class AccountCreate extends StatefulWidget {
  AccountCreate({super.key});

  @override
  State<AccountCreate> createState() => _AccountCreateState();
}

class _AccountCreateState extends State<AccountCreate>
    with TickerProviderStateMixin {
  final TextEditingController nameController =
      TextEditingController(text: "User 1");
  File? profileImage;
  bool isLanguageDropdownOpen = true;
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

  int value = 0;
  int? nullableValue;
  bool positive = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: DefaultTextStyle(
        style: theme.textTheme.titleLarge!,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 4.h),
            child: Column(
              children: [
                // Avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 60.w),
                    SizedBox(
                      height: 120.h,
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          width: 130.w,
                          height: 130.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.cyan.shade700, width: 2.w),
                            image: DecorationImage(
                              image: profileImage != null
                                  ? FileImage(profileImage!)
                                  : AssetImage('assets/icons/face.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: profileImage == null
                              ? Container(
                                  width: 130.w,
                                  height: 130.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                  ),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.cyan.shade900,
                                    size: 40.sp,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    // 🌙 Dark Mode
                    AnimatedToggleSwitch<bool>.dual(
                      current: positive,
                      first: false,
                      second: true,
                      spacing: 4.0.w,
                      style: ToggleStyle(
                        borderColor: Colors.black,
                      ),
                      borderWidth: .1.w,
                      height: 36.h,
                      onChanged: (b) => setState(() => positive = b),
                      styleBuilder: (b) => ToggleStyle(
                        backgroundColor: Color.fromRGBO(0, 0, 0, 0.1),
                        indicatorColor:
                            b ? Colors.black87 : Colors.cyan.shade800,
                      ),
                      indicatorSize: Size.fromWidth(42.0.w),
                      iconBuilder: (value) => value
                          ? Icon(Icons.nightlight, size: 20.sp)
                          : Icon(Icons.sunny, size: 20.sp),
                      textBuilder: (value) => value
                          ? Center(
                              child: Text(
                              'Tun',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16.sp,
                              ),
                            ))
                          : Center(
                              child: Text(
                              'Kun',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16.sp,
                              ),
                            )),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: Text(
                        " Ismingiz:",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
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
                      borderSide:
                          BorderSide(color: Color.fromRGBO(0, 0, 0, 0.15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                          BorderSide(color: Color.fromRGBO(0, 0, 0, 0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.cyan.shade800),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

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
                          border:
                              Border.all(color: Color.fromRGBO(0, 0, 0, 0.03)),
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
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
                    SizedBox(height: 4.h),

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
                              border: Border.all(
                                  color: Color.fromRGBO(0, 0, 0, 0.1)),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              children: languages.asMap().entries.map((entry) {
                                final lang = entry.value;

                                // Navbatdagi fon rang
                                final backgroundColor = Color.fromRGBO(0, 0, 0, 0.1);

                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 2.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: backgroundColor,
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.w),
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
                                            padding:
                                                EdgeInsets.only(right: 8.w),
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

                // 💾 KEYINGI tugmasi
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>Get.to(HomePage()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan.shade800,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'KEYINGI',
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
