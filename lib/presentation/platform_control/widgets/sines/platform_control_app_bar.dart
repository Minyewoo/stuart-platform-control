import 'package:flutter/material.dart';
///
class PlatformControlAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool _isPlatformMoving;
  final void Function() _onSaveSines;
  final void Function() _onStartFluctuations;
  final void Function() _onPlatformStop;
  @override
  final Size preferredSize;
  ///
  const PlatformControlAppBar({
    super.key,
    required void Function() onSave,
    required void Function() onStartFluctuations,
    required void Function() onPlatformStop,
    required bool isPlatformMoving, 
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  }) :
    _isPlatformMoving = isPlatformMoving, 
    _onPlatformStop = onPlatformStop,
    _onStartFluctuations = onStartFluctuations,
    _onSaveSines = onSave;
  //
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight = constraints.maxWidth < 1000;
        return AppBar(
          actions: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: isTight ? IconButton(
            //     onPressed: _onSaveSines, 
            //     icon: const Icon(Icons.save),
            //     tooltip: 'Сохранить параметры',
            //   ) : FilledButton.icon(
            //     onPressed: _onSaveSines, 
            //     icon: const Icon(Icons.save), 
            //     label: isTight ? const SizedBox() : const Text('Сохранить параметры'),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: isTight ? Tooltip(
                message: _isPlatformMoving 
                  ? 'Движение в процессе' 
                  : 'Движение остановлено',
                child: Icon(
                    Icons.circle, 
                    color: _isPlatformMoving ? Colors.greenAccent : null,
                  ),
              ) : OutlinedButton.icon(
                onPressed: _isPlatformMoving ? () {} : null,
                icon: Icon(
                  Icons.circle, 
                  color: _isPlatformMoving ? Colors.greenAccent : null,
                ), 
                label: const Text('Движение в процессе'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: isTight ? IconButton(
                onPressed: _isPlatformMoving ? null : _onStartFluctuations,
                icon: const Icon(Icons.play_arrow),
                tooltip: 'Начать движение',
              ) : FilledButton.icon(
                onPressed: _isPlatformMoving ? null : _onStartFluctuations,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Начать движение'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: isTight ? IconButton(
                onPressed: _onPlatformStop,
                icon: const Icon(Icons.stop),
                tooltip: 'Остановить движение',
              ) : FilledButton.icon(
                onPressed: _onPlatformStop, 
                icon: const Icon(Icons.stop), 
                label: const Text('Остановить движение'),
              ),
            ),
          ],
        );
      },
    );
  }
}