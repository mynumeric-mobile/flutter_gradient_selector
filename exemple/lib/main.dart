import 'package:flutter/material.dart';
import 'package:flutter_gradient_selector/flutter_gradient_selector.dart';
import 'package:flutter_gradient_selector/helpers/localization.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: SizedBox(
              height: constraints.maxHeight * 0.9,
              width: constraints.maxWidth * 0.9,
              child: GradientSelector(
                allowChangeMode: false,
                gradientMode: false,
                color: const LinearGradient(colors: [Colors.green, Colors.amber]),
                lang: LocalisationCode.fr,
                history: const [Colors.amber, Colors.white, Colors.green],
                onChange: (value) {
                  var c = value;
                },
              )),
        );
      }),
    );
  }
}
