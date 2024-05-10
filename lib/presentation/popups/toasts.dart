import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
///
void _showInfo(String message, BuildContext context) {
  toastification.show(
    alignment: Alignment.topCenter,
    showProgressBar: false,
    type: ToastificationType.info,
    style: ToastificationStyle.flat,
    backgroundColor: Theme.of(context).colorScheme.background,
    foregroundColor: Theme.of(context).colorScheme.onBackground,
    context: context,
    title: message,
    autoCloseDuration: const Duration(seconds: 2),
  );
}