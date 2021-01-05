import 'dart:convert';

import 'package:SoinConnect/pages/device/device-page.dart';
import 'package:SoinConnect/pages/donnee/donnee-page.dart';
import 'package:SoinConnect/pages/home/home-page.dart';
import 'package:SoinConnect/pages/login/login-page.dart';
import 'package:SoinConnect/pages/medecin/medecin-page.dart';
import 'package:SoinConnect/pages/membre/membre-page.dart';
import 'package:SoinConnect/pages/patient/patient-page.dart';
import 'package:SoinConnect/pages/rendezVous/rendezVous-page.dart';
import 'package:SoinConnect/pages/rendezVousPat/rendezVousPat-page.dart';
import 'package:SoinConnect/pages/service/service-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'menu-item.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  static var user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppService().getUser().then((response) {
      setState(() {
        user = json.decode(response.body);
      });
    }).catchError((err) {
      print(err);
    });
  }

  var menusMed = [
    {"title": "Home", "icon": Icon(Icons.home), "page": HomePage()},
    {"title": "Patient", "icon": Icon(Icons.people), "page": PatientPage()},
    {"title": "Mes Patient", "icon": Icon(Icons.people), "page": MembrePage()},
    {"title": "Rendez-vous", "icon": Icon(Icons.calendar_today), "page": RendezVousPage()},
    {"title": "Devices", "icon": Icon(Icons.developer_board), "page": DevicePage()},
    {"title": "Déconnecter", "icon": Icon(Icons.logout), "page": LoginPage()},
  ];
  var menusPat = [
    {"title": "Home", "icon": Icon(Icons.home), "page": HomePage()},
    {"title": "Données", "icon": Icon(Icons.bar_chart), "page": DonneePage()},
    {"title": "Rendez-vous", "icon": Icon(Icons.calendar_today), "page": RendezVousPatPage()},
    {"title": "Services", "icon": Icon(Icons.business), "page": ServicePage()},
    {"title": "Médecins", "icon": Icon(Icons.people), "page": MedecinPage()},
    {"title": "Déconnecter", "icon": Icon(Icons.logout), "page": LoginPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return (user == null)
        ? Center(
            child: CircularProgressIndicator(),
          )
        :
        /*********************************Médecin ***************************************************/
        (user["appUser"]['role'] == "MEDECIN")
            ? Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("./images/medecin.png"),
                              radius: 30,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user["nom"]},${user["prenom"]}",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                "${user["service"]["nom"]}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              Text(
                                "${user["appUser"]["email"]}",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: [Colors.white, ColorBar])),
                    ),
                    ...menusMed.map((item) {
                      return Column(
                        children: [
                          MenuItem(item["title"], item["icon"], item["page"]),
                          Divider(
                            color: ColorBar,
                          )
                        ],
                      );
                    })
                  ],
                ),
              )
            /********************************************************** Patient ************************************/
            : Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("./images/patient3.jpg"),
                              radius: 30,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user["nom"]},${user["prenom"]}",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                "${user["appUser"]["email"]}",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: [Colors.white, ColorBar])),
                    ),
                    ...menusPat.map((item) {
                      return Column(
                        children: [
                          MenuItem(item["title"], item["icon"], item["page"]),
                          Divider(
                            color: ColorBar,
                          )
                        ],
                      );
                    })
                  ],
                ),
              );
  }
}
