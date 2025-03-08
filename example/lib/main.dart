import 'package:alert_banner/exports.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Example",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

// Home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // EXAMPLE #1 of showAlertBanner()
              // You can alter its MANY fields, too
              TextButton(
                onPressed: () => showAlertBanner(
                  context,
                  () => print("TAPPED"),

                  // const ExampleAlertBannerChild(),

                  const AnimatedBanner(
                    imageHeight: 30,
                    imageWidth: 50,
                    imageUrl:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Flag_of_Palestine.svg/640px-Flag_of_Palestine.svg.png",
                  ),

                  maxWidth: 50,
                  durationOfStayingOnScreen: const Duration(seconds: 6),
                  durationOfScalingUp: const Duration(seconds: 0),
                  durationOfScalingDown: const Duration(seconds: 0),
                  durationOfLeavingScreenBySwipe: const Duration(seconds: 0),
                  alertBannerLocation: AlertBannerLocation.center,
                  // .. EDIT MORE FIELDS HERE ...
                ),
                child: const Text("Show top alert"),
              ),

              ////
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "🔥 Use with your own custom child widget.\n\n🔥 Adjust every field, such as child, durations, anim curves, safe areas, etc.\n\n🔥 Easy to call.\n\n🔥 Dismissible.\n\n🔥 Callback for onTap.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              // EXAMPLE #2 of showAlertBanner()
              // You can alter its MANY fields, too
              TextButton(
                onPressed: () => print("TAPPED OUT OF ALERT"),
                // showAlertBanner(
                //   context,
                //   () => print("TAPPED"),
                //   const ExampleAlertBannerChild(),
                //   alertBannerLocation: AlertBannerLocation.bottom,
                // ),
                child: const Text("Show bottom alert"),
                // .. EDIT MORE FIELDS HERE ...
              ),
            ],
          ),
        ));
  }
}

// Example child of alert banner
class ExampleAlertBannerChild extends StatelessWidget {
  const ExampleAlertBannerChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          child: Text(
            "This is an example notification. It looks awesome!",
            style: TextStyle(color: Colors.white, fontSize: 18),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class AnimatedBanner extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final String imageUrl;
  final Duration duration;

  const AnimatedBanner({
    Key? key,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageUrl,
    this.duration = const Duration(seconds: 6),
  }) : super(key: key);

  @override
  State<AnimatedBanner> createState() => _MovingBannerState();
}

class _MovingBannerState extends State<AnimatedBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // ضبط مدة الحركة حسب الحاجة
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward().whenComplete(() => print("Done"));

    // من أجل بدء الودجت خارج الشاشة على اليمين ونهايته خارج الشاشة على اليسار
    _slideAnimation = Tween<Offset>(
      begin:
          const Offset(0.6, 0.0), // خارج الشاشة من اليمين (1.0 يعني عرض الودجت)
      end: const Offset(-0.6, 0.0), // خارج الشاشة من اليسار
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: SizedBox(
          height: widget.imageHeight + 10,
          width: widget.imageWidth + 10,
          child: UnconstrainedBox(
            child: Image.network(
              widget.imageUrl,
              width: widget.imageWidth,
              height: widget.imageHeight,
            ),
          ),
        ),
      ),
    );
  }
}
