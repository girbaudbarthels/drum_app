// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:drumm_app/home/view/home_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.grey[800],
        ),
        scaffoldBackgroundColor: Colors.grey[800],
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
          backgroundColor: Colors.grey[700],
        ),
      ),
      home: const HomePage(),
    );
  }
}
