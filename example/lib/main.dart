
import 'package:flutter/material.dart';
import 'package:meiqia_flutter/meiqia_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //init meiqia first
    // MeiqiaFlutter.initMeiqia("");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              MeiqiaFlutter.chat(customId: "1234564");
            },
            child: Text("test"),
          ),
        ),
      ),
    );
  }
}
