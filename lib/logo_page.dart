import 'package:wordgame/library.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> with TickerProviderStateMixin {
  AnimationController? _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(seconds: 1));

    _controller!.forward();
    _controller!.addListener(() {
      setState(() {});
    });
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
          context, AnimationRouter(AccountCreate(), 3000), (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(68, 68, 68, 1),
      body: Center(
        child: Container(
          width: Get.width * _controller!.value,
          height: 340.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/logo.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimationRouter extends PageRouteBuilder {
  final Widget page;
  final int ms;
  AnimationRouter(this.page, this.ms)
      : super(
          transitionDuration: Duration(milliseconds: ms),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation1,
            Animation<double> animation2,
          ) {
            return page;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation1,
            Animation<double> animation2,
            Widget child,
          ) {
            return FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation1, curve: Curves.easeIn),
              ),
              child: child,
            );
          },
        );
}
