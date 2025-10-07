import 'package:wordgame/library.dart';
import 'dart:io';

class AccountCreate extends StatefulWidget {
  const AccountCreate({super.key});

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
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 4),
            child: Column(
              children: [
                // Avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 60),
                    SizedBox(
                      height: 140,
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.cyan.shade700, width: 2),
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
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(.1),
                                  ),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.cyan.shade900,
                                    size: 40,
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
                      spacing: 4.0,
                      style: ToggleStyle(
                        borderColor: Colors.black,
                      ),
                      borderWidth: .1,
                      height: 42,
                      onChanged: (b) => setState(() => positive = b),
                      styleBuilder: (b) => ToggleStyle(
                        backgroundColor: Colors.black.withOpacity(.1),
                        indicatorColor:
                            b ? Colors.black87 : Colors.cyan.shade800,
                      ),
                      indicatorSize: Size.fromWidth(42.0),
                      iconBuilder: (value) => value
                          ? const Icon(Icons.nightlight, size: 20)
                          : const Icon(Icons.sunny, size: 20),
                      textBuilder: (value) => value
                          ? const Center(
                              child: Text(
                              'Tun',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ))
                          : const Center(
                              child: Text(
                              'Kun',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            )),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      child: Text(
                        " Ismingiz:",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
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
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(.15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.cyan.shade800),
                    ),
                  ),
                ),
                SizedBox(height: 20),

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
                          border:
                              Border.all(color: Colors.black.withOpacity(0.03)),
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
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
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.1)),
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
                                  margin: EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: backgroundColor,
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
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
                                            padding:
                                                const EdgeInsets.only(right: 8),
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'KEYINGI',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
