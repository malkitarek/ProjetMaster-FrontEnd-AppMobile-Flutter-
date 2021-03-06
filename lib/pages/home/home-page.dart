import 'dart:convert';

import 'package:SoinConnect/pages/donnee/donnee-page.dart';
import 'package:SoinConnect/pages/login/login-page.dart';
import 'package:SoinConnect/pages/membre/membre-page.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/pages/navbar/menu-item.dart';
import 'package:SoinConnect/pages/patient/patient-page.dart';
import 'package:SoinConnect/pages/rendezVous/rendezVous-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/services/web-socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<dynamic> stream = streamController.stream;
  List<dynamic> notificationsStream;
  Stream<dynamic> streamAllMsg = streamControllerAllMsg.stream;
  List<dynamic> msgStream;
  var user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppService().getUser().then((response) {
      setState(() {
        user = json.decode(utf8.decode(response.bodyBytes));
      });
    });
    stream.listen((event) {
      if (mounted) {
        setState(() {
          notificationsStream = event;
        });
      }
    });
    streamAllMsg.listen((event) {
      if (mounted) {
        setState(() {
          msgStream = event;
        });
      }
    });
  }

  var homeTabMed = ['Patient', 'Mes Patient', 'Rendez-Vous', 'Devices'];
  var homeTabPat = ['Données', 'Rendez-Vous', 'Services', 'Médecins'];
  @override
  Widget build(BuildContext context) {
    return AppService().getGuard(page());
  }

  Widget page() {
    return Scaffold(
      appBar: BarWidget().bar(notificationsStream, msgStream),
      drawer: DrawerWidget(),
      body: (user == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ((user['appUser']['role'] == 'MEDECIN')
              /***************************************************Medecin *****************************************************/
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: GridView.builder(
                            itemCount: 4,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 480 / 700),
                            itemBuilder: (BuildContext context, int index) {
                              return new GestureDetector(
                                onTap: () {
                                  if (index == 0)
                                    return Navigator.pushNamed(
                                        context, "/patients");
                                  else if (index == 1)
                                    return Navigator.pushNamed(
                                        context, "/membres");
                                  else if (index == 2)
                                    return Navigator.pushNamed(
                                        context, "/rendezVous");
                                  else
                                    return Navigator.pushNamed(
                                        context, "/devices");
                                },
                                child: new Card(
                                    color: Color(0xfff33150),
                                    elevation: 5.0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            "./images/homeImage$index.png"),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              "${homeTabMed[index]}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ))
                                      ],
                                    )),
                              );
                            }),
                      ),
                    )
                  ],
                ))
              /********************************************************Patient******************************************/
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: GridView.builder(
                            itemCount: 4,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 480 / 700),
                            itemBuilder: (BuildContext context, int index) {
                              return new GestureDetector(
                                onTap: () {
                                  if (index == 0)
                                    return Navigator.pushNamed(
                                        context, "/donnees");
                                  else if (index == 1)
                                    return Navigator.pushNamed(
                                        context, "/rendezVousP");
                                  else if (index == 2)
                                    return Navigator.pushNamed(
                                        context, "/services");
                                  else
                                    return Navigator.pushNamed(
                                        context, "/medecins");
                                },
                                child: new Card(
                                    color: Color(0xfff33150),
                                    elevation: 5.0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            "./images/homeImgPat$index.png"),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              "${homeTabPat[index]}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ))
                                      ],
                                    )),
                              );
                            }),
                      ),
                    )
                  ],
                ))),
    );
  }
}
