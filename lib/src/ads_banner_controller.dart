import 'package:flutter/services.dart';

import 'ads_event_handler.dart';

class AdsBannerController extends AdsEventHandler {
  final MethodChannel _channel;

  AdsBannerController(int id, Function(AdsAdEvent, Map<String, dynamic>?)? listener)
      : _channel = MethodChannel('admob_flutter/banner_$id'),
        super(listener) {
        if (listener != null) {
          _channel.setMethodCallHandler(handleEvent);
          _channel.invokeMethod('setListener');
        }
      }

  void dispose() {
    _channel.invokeMethod('dispose');
  }
}