// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/pages/dashboard.dart';
import 'package:sparks/pages/guest.dart';
import 'package:sparks/pages/login.dart';
import 'package:sparks/pages/received_reports.dart';
import 'package:sparks/pages/signup.dart';
import 'package:sparks/widgets/bgimage.dart';
import 'package:sparks/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'widget/local_notification.dart';

void main() async {
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "basic_channel",
      channelName: "Basic Notification",
      channelDescription: "Basic notifications channel",
    )
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Basic Group",
    )
  ]);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      navigatorKey: navigatorKey,
      routes: {
        '/received_reports': (context) => ReceivedReports()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String token;
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    _loadToken();
  }

  Future<void> _loadToken() async {
    final storage = FlutterSecureStorage();
    String? retrievedToken = await storage.read(key: 'token');
    if (retrievedToken != null) {
      setState(() {
        token = retrievedToken;
      });
    } else {
      setState(() {
        token = '';
      });
    }
  }

  Future<void> _verifyToken() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Center(
        child: LoadingAnimationWidget.halfTriangleDot(
            color: Colors.green, size: 40),
      ),
    );
    final uri = Uri.parse('http://192.168.254.104:5173/api/tokenVerifier');
    final body = jsonEncode({'token': token});
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.post(uri, body: body, headers: headers);
      var json = jsonDecode(response.body);
      if (mounted) {
        Navigator.pop(context);
      }
      if (json['resp']) {
        if (mounted) {
          Navigator.push(
            context,
            PageTransition(
                child: Dashboard(
                  token: token,
                ),
                type: PageTransitionType.fade),
          );
        }
      } else {
        if (mounted) {
          Navigator.push(
            context,
            PageTransition(child: LoginPage(), type: PageTransitionType.fade),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'An error has occurred. Please check your connection and try again. $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          //front page
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 440,
                        ),

                        //Login Button
                        MaterialButton(
                          minWidth: 200,
                          height: 50,
                          splashColor: Color.fromARGB(255, 178, 255, 174),
                          elevation: 10,
                          onPressed: () async {
                            await _verifyToken();
                          },
                          color: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //Sign Up Button
                        MaterialButton(
                          minWidth: 190,
                          height: 50,
                          elevation: 10,
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: SignPage(),
                              ),
                            );
                          },
                          color: Color.fromARGB(255, 58, 208, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'Sign  Up',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 25),
                          ),
                        ),

                        SizedBox(
                          height: 25,
                        ),

                        //Guest Mode
                        Container(
                          color: const Color.fromARGB(255, 69, 68, 68),
                          width: MediaQuery.of(context).size.width / 4,
                          padding: EdgeInsets.all(3),
                          child: RichText(
                              text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: ' Guest Mode ',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    Navigator.of(context).push(PageTransition(
                                        child: GuestMode(),
                                        type: PageTransitionType.fade));
                                  }),
                          ])),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
