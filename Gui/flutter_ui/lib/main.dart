import 'package:flutter/material.dart';
import 'widgets/slider_widget.dart';
import 'dart:js' as js;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
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
  double _slidervalue = 0.5;

  void _onSliderChanged(double value) {
    setState(() {
      _slidervalue = value;
      try {
        js.context.callMethod('sendToNative', [value]);
      } catch (e, stack) {
        print('Caught error: $e');
        print('Stack trace: $stack');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SliderWidget(value: _slidervalue, onChanged: _onSliderChanged)
      ),
    );
  }
}