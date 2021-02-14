import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class StreamTwo extends StatefulWidget {
  @override
  _StreamTwoState createState() => _StreamTwoState();
}

class _StreamTwoState extends State<StreamTwo> {

  final StreamController<int> controller = StreamController();
  // fix ERROR for multiple subscriptions using builder.
  // @6:06 https://www.youtube.com/watch?v=53jIxLiCv2E&list=PLdTodMosi-BwEwlzjN6EyS1vwGXFo-UlK&index=11&ab_channel=FilledStacks
  // final StreamController<int> controller = StreamController<int>.broadcast();
  StreamSubscription streamSubscription;

  // manual stream
  Stream<int> getDelayedValue() async* {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(Duration(seconds: 1));

      yield i;
    }
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streams'),
      ),
      body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialButton(
                child: Text('Subscribe'),
                color: Colors.yellow,
                  onPressed: () {
                    Stream stream = controller.stream;
                    streamSubscription = stream.listen((val) {
                      print('Value from controller: $val');
                    });
                  }
              ),
              MaterialButton(
                child: Text('Emit Val'),
                color: Colors.blue.shade200,
                onPressed: () {
                  controller.add(Random().nextInt(10));
                },
              ),
              MaterialButton(
                child: Text('Unsubscribe'),
                color: Colors.red.shade200,
                onPressed: () {
                  streamSubscription.cancel();
                },
              ),
              MaterialButton(
                child: Text('Manual'),
                color: Colors.green.shade200,
                onPressed: () {
                  getDelayedValue().listen((val) {
                    print('Value for manual Stream: $val');
                  });
                },
              )
            ],
          )
      ),
    );
  }
}
