import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ads_banner_controller.dart';
import 'ads_events.dart';


class AdsBanner extends StatefulWidget {
  final String adUnitId;
  //final AdsBannerSize adSize;
  final void Function(AdsAdEvent, Map<String, dynamic>?)? listener;
  final void Function(AdsBannerController)? onBannerCreated;
  final bool nonPersonalizedAds;

  AdsBanner({
    Key? key,
    required this.adUnitId,
    //required this.adSize,
    this.listener,
    this.onBannerCreated,
    this.nonPersonalizedAds = false,
  }) : super(key: key);

  @override
  _AdmobBannerState createState() => _AdmobBannerState();
}

class _AdmobBannerState extends State<AdsBanner> {
  final UniqueKey _key = UniqueKey();
  late AdsBannerController _controller;
  Future<Size>? adSize;

  @override
  void initState() {
    super.initState();

    /* if (!widget.adSize.hasFixedSize) {
      adSize = Ads.bannerSize(widget.adSize);
    } else {
      adSize = Future.value(Size(
        widget.adSize.width.toDouble(),
        widget.adSize.height.toDouble(),
      ));
    } */
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Size>(
      future: adSize,
      builder: (context, snapshot) {
        final adSize = snapshot.data;
        if (adSize == null) {
          return SizedBox.shrink();
        }

        if (defaultTargetPlatform == TargetPlatform.android) {
          return SizedBox.fromSize(
            size: adSize,
            child: AndroidView(
              key: _key,
              viewType: 'admob_flutter/banner',
              creationParams: bannerCreationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: _onPlatformViewCreated,
            ),
          );
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          return SizedBox.fromSize(
            size: adSize,
            child: UiKitView(
              key: _key,
              viewType: 'admob_flutter/banner',
              creationParams: bannerCreationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: _onPlatformViewCreated,
            ),
          );
        }

        return Text('$defaultTargetPlatform is not yet supported by the plugin');
      },
    );
  }

  void _onPlatformViewCreated(int id) {
    _controller = AdsBannerController(id, widget.listener);

    if (widget.onBannerCreated != null) {
      widget.onBannerCreated!(_controller);
    }
  }

  Map<String, dynamic> get bannerCreationParams => <String, dynamic>{
    'adUnitId': widget.adUnitId,
    //'adSize': widget.adSize.toMap,
    'nonPersonalizedAds': widget.nonPersonalizedAds,
  };
}
