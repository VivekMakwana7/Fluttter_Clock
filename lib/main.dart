import 'package:clocker/page/home.dart';
import 'package:clocker/provider/log_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helper/pref_utils.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => LogProvider(),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}
