import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const SliderWidget({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Slider Value: ${value.toStringAsFixed(2)}'),
        Slider(
          value: value,
          min: 0,
          max: 100,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
