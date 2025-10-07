import 'package:wordgame/library.dart';
import 'dart:io';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

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
        title: const Text(
          "Profile",
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
        child: Column(
          children: [
            // Avatar
            SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.cyan.shade700, width: 2),
                        image: DecorationImage(
                          image: profileImage != null
                              ? FileImage(profileImage!)
                              : const AssetImage('assets/icons/face.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: profileImage == null
                          ? Icon(
                              Icons.add_a_photo,
                              color: Colors.cyan.shade900,
                              size: 32,
                            )
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 16),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        cursorColor: Colors.cyan.shade800,
                        cursorWidth: 1.6,
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(.15)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(.15)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black.withOpacity(0.03)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        color: Colors.cyan.shade800,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Tungi rejim",
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
            const SizedBox(height: 16),

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.1),
                      border: Border.all(color: Colors.black.withOpacity(0.03)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language,
                                color: Colors.cyan.shade700, size: 28),
                            const SizedBox(width: 12),
                            const Text(
                              "Tilni tanlang",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            selectedLanguage.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.cyan.shade800,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // 🔽 Animatsiya bilan ochiladigan qism
                ClipRect(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: ConstrainedBox(
                      constraints: isLanguageDropdownOpen
                          ? const BoxConstraints()
                          : const BoxConstraints(maxHeight: 0),
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: languages.asMap().entries.map((entry) {
                            final index = entry.key;
                            final lang = entry.value;

                            // Navbatdagi fon rang
                            final backgroundColor = index.isEven
                                ? Colors.black.withOpacity(.1)
                                : Colors.black.withOpacity(.1);

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: backgroundColor,
                              ),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                title: Text(
                                  lang.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: selectedLanguage == lang
                                    ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
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
              margin: EdgeInsets.only(bottom: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'SAQLASH',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
