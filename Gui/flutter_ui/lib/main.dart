import 'package:flutter/material.dart';
import 'widgets/slider_widget.dart';
import 'dart:js' as js;

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  // State variables for the sliders
  double _sliderValue1 = 20.0;
  double _sliderValue2 = 50.0;
  double _sliderValue3 = 80.0;

  // Callbacks for the sliders
  void _onSlider1Changed(double value) {
    setState(() {
      _sliderValue1 = value;
      try {
        js.context.callMethod('sendToJs', ['hello JS from dart code']);
      } catch (e, stack) {
        print('Caught error: $e');
        print('Stack trace: $stack');
      }
    });
  }

  void _onSlider2Changed(double value) {
    setState(() {
      _sliderValue2 = value;
    });
  }

  void _onSlider3Changed(double value) {
    setState(() {
      _sliderValue3 = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Slider 1
            Text('Slider 1: ${_sliderValue1.toStringAsFixed(1)}'),
            SliderWidget(value: _sliderValue1, onChanged: _onSlider1Changed),

            SizedBox(height: 20), // Add some spacing

            // Slider 2
            Text('Slider 2: ${_sliderValue2.toStringAsFixed(1)}'),
            SliderWidget(value: _sliderValue2, onChanged: _onSlider2Changed),

            SizedBox(height: 20), // Add some spacing

            // Slider 3
            Text('Slider 3: ${_sliderValue3.toStringAsFixed(1)}'),
            SliderWidget(value: _sliderValue3, onChanged: _onSlider3Changed),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Do something with all slider values
          debugPrint('Slider values: $_sliderValue1, $_sliderValue2, $_sliderValue3');
        },
        tooltip: 'Log Slider Values',
        child: const Icon(Icons.check),
      ),
    );
  }
}