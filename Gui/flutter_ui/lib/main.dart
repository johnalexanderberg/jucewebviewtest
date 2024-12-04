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
  double _slidervalue = 0.5;
  double _slidervalue2 = 0.0;

  @override
  void initState() {
    super.initState();

    js.context.callMethod('setGainValueChangedFromDAWListener', [_onDAWGainValueChanged]);
  }

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

  void _onGainChangeStart(double value) {
    js.context.callMethod('gainSliderDragStarted', []);
  }

  void _onGainChangeEnd(double value) {
    js.context.callMethod('gainSliderDragEnded', []);
  }

  void _onGainSliderChanged(double value) {
    setState(() {
      _slidervalue2 = value;
      js.context.callMethod('gainSetNormalisedValue', [value]);
    });
  }

  void _onDAWGainValueChanged(double value) {
    // This function will be called when the DAW updates the value
    setState(() {
      _slidervalue2 = value;
    });
  }

  double _getGainSliderValue() {
    return js.context.callMethod('gainGetNormalisedValue');
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Slider 1 - native function",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SliderWidget(
                value: _slidervalue,
                onChanged: _onSliderChanged,
              ),
              SizedBox(height: 20),

              const Text(
                "Slider 2 - attached to Juce gain parameter",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SliderWidget(
                  value: _slidervalue2,
                  onChanged: _onGainSliderChanged,
                  onChangeStart: _onGainChangeStart,
                  onChangeEnd: _onGainChangeEnd
              ),
            ],
          ),
        ),
      );
    }
  }