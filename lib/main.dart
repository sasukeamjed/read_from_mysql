import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List> getData() async {
    final response = await http.get("http://10.0.2.2/image/getdata.php");
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Read From MySql'),
      ),
      body: new FutureBuilder(
        future: getData(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ItemList(list: snapshot.data)
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  ItemList({this.list});

  final List list;

  final decoder = new Base64Decoder();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: Card(
            child: Column(
              children: <Widget>[
                Image.memory(decoder.convert(list[index]['image'])),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      color: Colors.green,
                      padding: EdgeInsets.all(8.0),
                      child: Text(list[index]['name']),
                    ),
                    Container(
                      color: Colors.green,
                      padding: EdgeInsets.all(8.0),
                      child: Text('Email : ${list[index]['email']}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
