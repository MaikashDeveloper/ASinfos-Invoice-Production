// ignore_for_file: unused_local_variable

import 'package:asinfos_invoice/pages/desktop.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  // inti the hive
  await Hive.initFlutter();

  // open Box
  var box = await Hive.openBox('myBox');

  // App run
  runApp(const MyApp());

  // Set the minimum and maximum window size
  doWhenWindowReady(() {
    const initialSize = Size(1000, 500); // Define your initial window size
    appWindow.minSize = const Size(1000, 700); // Set minimum size constraint
    appWindow.size = initialSize; // Set initial size
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DesktopView(),
    );
  }
}

// class ResponsiveWidget extends StatefulWidget {
//   const ResponsiveWidget({super.key});

//   @override
//   State<ResponsiveWidget> createState() => _ResponsiveWidgetState();
// }

// class _ResponsiveWidgetState extends State<ResponsiveWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // if (constraints.maxWidth < 1100) {
//         //   return const TabletView();
//         // }
//         return const DesktopView();
//       },
//     );
//   }
// }
