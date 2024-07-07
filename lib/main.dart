import 'package:flutter/material.dart';
import 'package:uas/pages/HomePage.dart';
import 'package:uas/pages/SalesPage.dart';
import 'package:uas/pages/StockPage.dart';
import 'package:uas/pages/productPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahmad Fathon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ahmad Fathon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipPath(
        clipper: TopAppBarClipper(),
        child: BottomAppBar(
          notchMargin: 5.0,
          shape: const CircularNotchedRectangle(),
          color: const Color.fromARGB(255, 255, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        pageController.jumpToPage(0);
                      },
                      icon: const Icon(Icons.home),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        pageController.jumpToPage(1);
                      },
                      icon: const Icon(Icons.local_mall),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        pageController.jumpToPage(2);
                      },
                      icon: const Icon(Icons.inventory),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        pageController.jumpToPage(3);
                      },
                      icon: const Icon(Icons.badge),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                HomePage(),
                ProductPage(),
                StockPage(),
                SalesPage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TopAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 30.0;

    // Start from the bottom left corner
    path.moveTo(0, radius);
    // Draw a quadratic bezier curve to the top left corner
    path.quadraticBezierTo(0, 0, radius, 0);
    // Draw a line to the top right corner
    path.lineTo(size.width - radius, 0);
    // Draw a quadratic bezier curve to the top right corner
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    // Draw lines to the bottom corners
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}


