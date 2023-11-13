import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainHome(title: 'My Home Page'),
    );
  }
}

class MainHome extends StatefulWidget {
  MainHome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int current = 0;
  final List<String> items = ['Box 1', 'Box 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ListView.builder(
                itemCount: 2,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        current = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: 80,
                      height: 45,
                      decoration: BoxDecoration(
                        color: current == index ? Colors.white70 : Colors.white54,
                      ),
                      child: Center(child: Text(items[index])),
                    ),
                  );
                },
              ),
            ),
          Container(margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              height: 800,color: Colors.black,)],
        ),
      ),
    );
  }
}
