import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ads_flutter/ads_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Ads.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobInterstitial interstitialAd;


    @override
  void initState() {
  super.initState();
   // bannerSize = AdmobBannerSize.BANNER;
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdsAdEvent event, Map<String, dynamic> args) {
        if (event == AdsAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
  }

  void handleEvent(AdsAdEvent event, Map<String, dynamic> args, String adType) {
    //(AdsAdEvent event, Map<String, dynamic>? args, String adType)
    switch (event) {
      case AdsAdEvent.loaded:
        print('New Ads $adType Ad loaded!');
        break;
      case AdsAdEvent.opened:
        print('Ads $adType Ad opened!');
        break;
      case AdsAdEvent.closed:
        print('Ads $adType Ad closed!');
        break;
      case AdsAdEvent.failedToLoad:
        print('Ads $adType failed to load.');
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Builder(
            builder: (BuildContext context) {
              return Container(
                color: Colors.blueGrey,
                child: SafeArea(
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              if (await (interstitialAd.isLoaded as Future<bool>)) {
                                interstitialAd.show();
                              } else {
                                print(
                                    'Interstitial ad is still loading...');
                              }
                            },
                            child: Text(
                              'Show Interstitial',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ), 
      body: ListView(
        children: [
          AdsBanner(
            adUnitId: getBannerAdUnitId(),
            //adSize: bannerSize!,
            listener: (AdsAdEvent event, Map<String, dynamic> args) {
              handleEvent(event, args, 'Banner');
            },
            onBannerCreated: (AdsBannerController controller) {},
          ),
//-------------------------------------
        ],
      ),
    );
  }


  
  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}
