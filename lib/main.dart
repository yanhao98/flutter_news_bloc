import 'package:flutter/material.dart';
import 'package:news_bloc2/screen/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      // home: TestHome(),
      home: HomeScreen(),
    );
  }
}

class TestHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: ListView.builder(
            itemCount: 100,
            itemBuilder: (c, i) {
              return ListTile(
                title: Text('data'),
              );
            }),
      ),
    );
  }
}
