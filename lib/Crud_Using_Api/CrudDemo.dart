import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrudDemo extends StatefulWidget {
  const CrudDemo({super.key});

  @override
  State<CrudDemo> createState() => _CrudDemoState();
}

class _CrudDemoState extends State<CrudDemo> {
  List<dynamic> user = [];

  void initState(){
    super.initState();
  }

  Future<void> fetchdata() async{
    const url = 'https://65ded69cff5e305f32a0984c.mockapi.io/flutterapi';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final Decodedresponse = jsonDecode(response.body) as List<dynamic>;
    setState(() {
      user = Decodedresponse;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crud Demo using MokeApi')
      ),
      body: Column(

      ),
    );
  }
}
