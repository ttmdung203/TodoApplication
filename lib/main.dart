import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:to_do/helper/app_configuration.dart';
import 'package:to_do/helper/router_helper.dart';

void main() {
  AppConfiguration.instance.configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: RouterFactory.todoListPage(),
      builder: EasyLoading.init(),
    );
  }
}
