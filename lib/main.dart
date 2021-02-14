import 'dart:async';

import 'package:flutter/material.dart';
import 'package:streams_app/stream_two.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
      routes: {
        '/streamTwo': (context) => StreamTwo(),
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final StreamController _streamController = StreamController();

  // 1. you need to implicitly close the stream.
  void addData() async {
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(Duration(seconds: 1));
      _streamController.sink.add(i);
    }
  }

  // 2. Auto closes the stream.
  Stream<int> numberStream() async* {
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(Duration(seconds: 1));

      yield i;
    }
  }

  @override
  void initState() {
    addData();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streams'),
      ),
      body: Center(
        child: StreamBuilder(
          // stream: _streamController.stream,
          // stream: numberStream(),
          stream: numberStream().map((num) => num * 10),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('There was an error');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return Text(
              '${snapshot.data}',
              style: Theme.of(context).textTheme.headline3,
            );
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/streamTwo');
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
