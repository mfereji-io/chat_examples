import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  var ttStr = 'Kaskazini Crew';
  var chatStr = 'chat';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ttStr,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '$ttStr - $chatStr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late centrifuge.Client _centrifuge;
  late centrifuge.Subscription _subscription;
  late ScrollController _controller;

  final _items = <_ChatItem>[];
  bool isConnected = false;

  @override
  void initState() {
    //final url = 'ws://localhost:8000/connection/websocket?format=protobuf';
    //final url = 'ws://localhost:8081/v1/ws/?format=protobuf';
    final apiKey = '4a554a556d616ecf6fb2c56586e27e690260f79d5da7bf9413d7c6aeacb6755e5d0fe05661d9531e6dcf1787738691b5014e5dfe0f8ea7f095f447251631d7068f8419484141ac';
    //final url = 'ws://10.0.2.2:8081/v1/ws/connect?format=protobuf&api_key='+apiKey;
    //final url = 'ws://10.0.2.2:8081/v1/ws/connect?api_key='+apiKey;
    final url = 'ws://192.168.0.19:8081/v1/ws/connect?api_key='+apiKey;
    //final url = 'wss://lab.chat-api.mfereji.io:8081/v1/ws/connect?format=protobuf&api_key='+apiKey;


    _centrifuge = centrifuge.createClient(url);

    _controller = ScrollController();
    super.initState();
  }

  /*
   setState(() {
    if(isConnected){

    }

   });
   */

  @override
  void dispose() async {
    await _centrifuge.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: isConnected ? Colors.greenAccent: Colors.redAccent,
        actions: <Widget>[
          PopupMenuButton<Function>(
            onSelected: (f) => f(),
            itemBuilder: (context) => <PopupMenuItem<Function>>[
              PopupMenuItem(
                value: () => _connect(),
                child: Text('Connect'),
              ),
              PopupMenuItem(
                value: () => _disconnect(),
                child: Text('DisConnect'),
              ),
              PopupMenuItem(
                value: () => _subscribe(),
                child: Text('Subscribe'),
              ),
              PopupMenuItem(
                value: () => _publish(),
                child: Text('Publish'),
              ),
            ],
          )
        ],
      ),
      body: ListView.builder(
          itemCount: _items.length,
          controller: _controller,
          itemBuilder: (context, index) {
            final item = _items[index];
            return ListTile(
              title: Text(item.title),
              subtitle: Text(item.subtitle),
            );
          }),
    );
  }

  void _connect() async {
    try {
      await _centrifuge.connect();
      setState(() => isConnected = true);
    } catch (exception) {
      _show(exception);
    }
  }

  void _disconnect() async {
    try {
      await _centrifuge.disconnect();
      setState(() => isConnected = false);
    } catch (exception) {
      _show(exception);
    }
  }

  void _subscribe() async {
    final channel = 'KaskaziniChannel';
    _subscription = _centrifuge.newSubscription(channel);

    _subscription.subscribing.listen(_show);
    _subscription.subscribed.listen(_show);
    _subscription.unsubscribed.listen(_show);

    final onNewItem = (_ChatItem item) {
      setState(() {
        //_items.insert(0,item);
        _items.add(item);
      });
      Future.delayed(Duration(milliseconds: 125), () => _controller.jumpTo(64.0 + _controller.offset));
    };

    _subscription.join.listen((event) {
      final user = event.user;
      final client = event.client;

      final item = _ChatItem(title: 'User $user joined channel $channel', subtitle: '(client ID $client)');
      onNewItem(item);
    });

    _subscription.leave.listen((event) {
      final user = event.user;
      final client = event.client;
      final item = _ChatItem(title: 'User $user left channel $channel', subtitle: '(client ID $client)');
      onNewItem(item);
    });

    _subscription.publication.listen((event) {
      final String message = json.decode(utf8.decode(event.data))['input'];

      final item = _ChatItem(title: message, subtitle: 'User: user');
      onNewItem(item);
    });

    await _subscription.subscribe();

  }

  void _show(dynamic error) {
    showDialog<AlertDialog>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(
          error.toString(),
        ),
      ),
    );
  }

  void _publish() async {
    try {
      //List<int> someData = [];
      var dataStr = 'Hello from Kaskazini Mobile';
      var dataCh = 'KaskaziniChannel';

      final output = jsonEncode({'input':dataStr});
      final data = utf8.encode(output);
      await _centrifuge.publish(dataCh, data );
      //setState(() => isConnected = false);
    } catch (exception) {
      _show(exception);
    }
  }

}

 


class _ChatItem {
  _ChatItem({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}
