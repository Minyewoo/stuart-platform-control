import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stuart_platform_control/presentation/platform_control/widgets/sinus_chart.dart';
///
class PlatformControlPage extends StatelessWidget {
  ///
  const PlatformControlPage({super.key});
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilledButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.save), 
              label: const Text('Load settings'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilledButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.play_arrow), 
              label: const Text('Start movement'),
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, right: 16.0),
                  child: SinusChart(),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, right: 16.0),
                  child: SinusChart(
                    amplitude: 2,
                    period: pi,
                    shift: pi/2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, right: 16.0),
                  child: SinusChart(
                    amplitude: 0.5,
                    period: pi/2,
                    shift: pi,
                    center: pi,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
