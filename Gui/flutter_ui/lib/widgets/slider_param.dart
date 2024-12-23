import 'package:flutter/material.dart';
import 'dart:js' as js;

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

    _currentValue = js.context.callMethod('getSliderNormalisedValue', [widget.parameterId]);

    var onValueChangedFromDaw = js.allowInterop((value) {
      setState(() {
        _currentValue = value;
      });
    });

      js.context.callMethod('addSliderListener', [widget.parameterId, onValueChangedFromDaw]);
    }

  void _onChangeStart(double value) {
    js.context.callMethod('sliderDragStarted',
        [widget.parameterId]);
  }

  void _onChangeEnd(double value) {
    js.context.callMethod('sliderDragEnded',
        [widget.parameterId]);
  }

  void _onChanged(double value) {
    js.context.callMethod(
        'setSliderNormalisedValue',
        [widget.parameterId, value]);

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
