import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/messages.dart';
import '../widgets/loader.dart';
import 'default_change_notifier.dart';

class DefaultListenerNotifier {
  DefaultChangeNotifier changeNotifier;

  DefaultListenerNotifier({required this.changeNotifier});

  void listener(
      {required BuildContext context,
      required SuccessVoidCallBack successVoidCallBack,
      EverVoidCallBack? everVoidCallBack,
      ErrorVoidCallBack? errorCallBack}) {
    changeNotifier.addListener(() {
      if (everVoidCallBack != null) {
        everVoidCallBack(changeNotifier, this);
      }
      if (changeNotifier.loading) {
        Loader.show();
      } else {
        Loader.hide();
      }

      if (changeNotifier.hasError) {
        if (errorCallBack != null) {
          errorCallBack(changeNotifier, this);
        }
        Messages.of(context).showError(changeNotifier.error ?? 'Erro interno');
      } else if (changeNotifier.isSuccess) {
        successVoidCallBack(changeNotifier, this);
      }
    });
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SuccessVoidCallBack = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerNotifier);

typedef ErrorVoidCallBack = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerNotifier);

typedef EverVoidCallBack = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerNotifier);
