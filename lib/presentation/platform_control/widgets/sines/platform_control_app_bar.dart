import 'package:flutter/material.dart';
///
class PlatformControlAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool _isPlatformMoving;
  // final void Function() _onSaveSines;
  final void Function() _onStartFluctuations;
  final void Function() _onInitialPositionRequest;
  final void Function() _onPlatformStop;
  @override
  final Size preferredSize;
  ///
  const PlatformControlAppBar({
    super.key,
    required void Function() onSave,
    required void Function() onStartFluctuations,
    required void Function() onInitialPositionRequest,
    required void Function() onPlatformStop,
    required bool isPlatformMoving, 
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  }) :
    _isPlatformMoving = isPlatformMoving, 
    _onPlatformStop = onPlatformStop,
    _onStartFluctuations = onStartFluctuations,
    _onInitialPositionRequest = onInitialPositionRequest;
    // _onSaveSines = onSave;
  //
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight = constraints.maxWidth < 1000;
        return AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: isTight ? IconButton(
                onPressed: _isPlatformMoving ? null : _onInitialPositionRequest,
                icon: const Icon(Icons.restart_alt),
                tooltip: 'Нулевая позиция',
              ) : FilledButton.icon(
                onPressed: _isPlatformMoving ? null : _onInitialPositionRequest,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Нулевая позиция'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: isTight ? IconButton(
                onPressed: _isPlatformMoving ? null : _onStartFluctuations,
                icon: const Icon(Icons.play_arrow),
                tooltip: 'Старт',
              ) : FilledButton.icon(
                onPressed: _isPlatformMoving ? null : _onStartFluctuations,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Старт'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: isTight ? IconButton(
                onPressed: _onPlatformStop,
                icon: const Icon(Icons.stop),
                tooltip: 'Стоп',
              ) : FilledButton.icon(
                onPressed: _onPlatformStop, 
                icon: const Icon(Icons.stop), 
                label: const Text('Стоп'),
              ),
            ),
          ],
        );
      },
    );
  }
}