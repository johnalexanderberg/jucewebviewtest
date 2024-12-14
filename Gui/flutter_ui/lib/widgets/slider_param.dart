import 'package:flutter/material.dart';
import 'dart:js_interop';

@JS()
@anonymous
@staticInterop
class JsSliderInterop {}

@JS('getSliderNormalisedValue')
external double getSliderNormalisedValue(String parameterId);

@JS('setSliderNormalisedValue')
external void setSliderNormalisedValue(String parameterId, double value);

@JS('sliderDragStarted')
external void sliderDragStarted(String parameterId);

@JS('sliderDragEnded')
external void sliderDragEnded(String parameterId);

// @JS()
// external void addSliderListener(String parameterId, JSFunctionRepType callback);
//
// // A wrapper to allow Dart function to work with JS interop.
// @JS()
// @staticInterop
// class JSFunctionRepType {
//   external factory JSFunctionRepType(void Function(double) callback);
// }

class SliderParam extends StatefulWidget {
  final String parameterId;

  const SliderParam({
    super.key,
    required this.parameterId,
  });

  @override
  State<SliderParam> createState() => _SliderParamState();
}

class _SliderParamState extends State<SliderParam> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();

    // Fetch the initial value from JavaScript.
    _currentValue = getSliderNormalisedValue(widget.parameterId);

  //   // Register a listener for updates from JavaScript
  //   addSliderListener(widget.parameterId, JSFunctionRepType((double value) {
  //     setState(() {
  //       _currentValue = value;
  //     });
  //   }));
  }

  void _onChangeStart(double value) {
    sliderDragStarted(widget.parameterId);
  }

  void _onChangeEnd(double value) {
    sliderDragEnded(widget.parameterId);
  }

  void _onChanged(double value) {
    setSliderNormalisedValue(widget.parameterId, value);

    setState(() {
      _currentValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${widget.parameterId} Value: ${_currentValue.toStringAsFixed(4)}'),
        Slider(
          value: _currentValue,
          min: 0,
          max: 1,
          onChanged: _onChanged,
          onChangeStart: _onChangeStart,
          onChangeEnd: _onChangeEnd,
        ),
      ],
    );
  }
}
