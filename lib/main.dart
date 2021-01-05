import 'dart:async';
import 'dart:convert';


import 'package:SoinConnect/pages/device/device-page.dart';
import 'package:SoinConnect/pages/donnee/donnee-page.dart';
import 'package:SoinConnect/pages/home/home-page.dart';
import 'package:SoinConnect/pages/login/login-page.dart';
import 'package:SoinConnect/pages/medecin/medecin-page.dart';
import 'package:SoinConnect/pages/membre/membre-page.dart';
import 'package:SoinConnect/pages/messageMP/message-page.dart';
import 'package:SoinConnect/pages/notification/notification-page.dart';
import 'package:SoinConnect/pages/patient/patient-page.dart';
import 'package:SoinConnect/pages/rendezVous/rendezVous-page.dart';
import 'package:SoinConnect/pages/rendezVousPat/rendezVousPat-page.dart';
import 'package:SoinConnect/pages/service/service-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/services/web-socket.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

StreamController<dynamic> streamController = StreamController.broadcast();
StreamController<dynamic> streamControllerMemMsg = StreamController.broadcast();
StreamController<dynamic> streamControllerAllMsg = StreamController.broadcast();
StreamController<dynamic> streamControllerMessge = StreamController.broadcast();
StreamController<dynamic> streamControllerDonnees = StreamController.broadcast();

void main() {
  runApp(MyApp());
  WebSocketApi().getRealTimeNotif().then((value)=> value.activate());
  WebSocketApi().getRealTimeMemMsg().then((value)=> value.activate());
  WebSocketApi().getRealTimeAllMsg().then((value)=> value.activate());
  WebSocketApi().getRealTimeMessge().then((value)=> value.activate());
  WebSocketApi().getRealTimeDonnees().then((value)=> value.activate());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future:  AppService().getJwtOrEmpty(),
          builder: (context,snapshot){
            if(!snapshot.hasData) return CircularProgressIndicator();
            if(snapshot.data != ""){
              //print("jwtToken == ${snapshot.data}");
              return HomePage();
            }else{
              //print("jwtToken == ${snapshot.data}");
              return LoginPage();
            }
          },),
      routes: <String, WidgetBuilder> {
        '/home' : (BuildContext context) => HomePage(),
        '/patients' : (BuildContext context) => PatientPage(),
        '/membres' : (BuildContext context) => MembrePage(),
        '/rendezVous' : (BuildContext context) => RendezVousPage(),
        '/notifications' : (BuildContext context) => NotificationPage(),
        '/messages' : (BuildContext context) => MessagePage(),
        '/devices' : (BuildContext context) => DevicePage(),
        '/donnees' : (BuildContext context) => DonneePage(),
        '/rendezVousP' : (BuildContext context) => RendezVousPatPage(),
        '/services' : (BuildContext context) => ServicePage(),
        '/medecins' : (BuildContext context) => MedecinPage(),
        /*'/screen4' : (BuildContext context) => new Screen4()*/
      },
    );
  }

}

