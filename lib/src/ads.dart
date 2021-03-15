import 'dart:io';
import 'package:flutter/services.dart';

class Ads{
  
  static const _channel = MethodChannel('ads_flutter');

  Ads.initialize({List<String>? testDeviceIds}) {
    _channel.invokeListMethod('initiakize', testDeviceIds);
  }

  static Future<bool> requestTrackingAuthorization()  async {
    if (!Platform.isIOS) {
      return Future<bool>.value(true);
    }
    //return _channel.invokeMethod('request_tracking_authorization');
    final requestTracking = await _channel.invokeMethod('request_tracking_authorization');
    return requestTracking == true;
  }

}


