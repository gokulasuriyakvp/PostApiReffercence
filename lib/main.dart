import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'post_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Post>? post;

  @override
  void initState() {
    super.initState();
    print('+++++++++++++++++initial state');
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter REST API Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter REST API Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, Index) {
              if (Index.hasData) {
                return Text(Index.data!.data![5].id.toString(),
                  style: TextStyle(
                    fontSize: 25,
                  ),);
              } else if (Index.hasError) {
                return Text("${Index.error}");
              }

              // By default, it show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}


// https://dummy.restapiexample.com/api/v1/employees

//https://reqres.in/api/users?page=2
Future<Post> fetchPost() async {
  final _authority = "reqres.in";
  final _path = "/api/users";
  final _params = { "page":"2" };
  final _uri =  Uri.https(_authority, _path, _params);
  final response = await http.get(_uri);
  print("---------------- ${_uri.toString()}");

  if (response.statusCode == 200) {
    print('----------- ${response.body}');

    // If the call to the server was successful (returns OK), parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    print('Error Exception');
    // If that call was not successful (response was unexpected), it throw an error.
    throw Exception('Failed to load post');
  }
}

