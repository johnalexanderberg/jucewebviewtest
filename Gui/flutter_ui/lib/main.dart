import 'package:flutter/material.dart';
import 'widgets/slider_param.dart';

void main() {
  const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
  print(isRunningWithWasm? "Running with Wasm" : "Not running with Wasm");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter & Juce Test'),
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

  double _sliderValue = 0.5;
  @override
  void initState() {
    super.initState();

  }
    @override
    Widget build(BuildContext context) {
      return const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(
                "Attached to Juce gain parameter",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SliderParam(parameterId: 'gain'),
            ],
          ),
        ),
      );
    }
  }