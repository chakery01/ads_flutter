import 'dart:async';
import 'package:flutter/services.dart';

import 'ads_events.dart';
export 'ads_events.dart';

abstract class AdsEventHandler {
  final Function(AdsAdEvent, Map<String, dynamic>?)? _listener;

  AdsEventHandler(Function(AdsAdEvent, Map<String, dynamic>?)? listener) : _listener = listener;

  Future<void> handleEvent(MethodCall call) async {
    if (_listener == null) {
      return;
    }
    switch (call.method) {
      case 'loaded':
        _listener!(AdsAdEvent.loaded, null);
        break;
      case 'failedToLoad':
        _listener!(AdsAdEvent.failedToLoad,
            Map<String, dynamic>.from(call.arguments));
        break;
      case 'clicked':
        _listener!(AdsAdEvent.clicked, null);
        break;
      case 'impression':
        _listener!(AdsAdEvent.impression, null);
        break;
      case 'opened':
        _listener!(AdsAdEvent.opened, null);
        break;
      case 'leftApplication':
        _listener!(AdsAdEvent.leftApplication, null);
        break;
      case 'closed':
        _listener!(AdsAdEvent.closed, null);
        break;
      case 'completed':
        _listener!(AdsAdEvent.completed, null);
        break;
      case 'rewarded':
        _listener!(
            AdsAdEvent.rewarded, Map<String, dynamic>.from(call.arguments));
        break;
      case 'started':
        _listener!(AdsAdEvent.started, null);
        break;
    }
  }
}