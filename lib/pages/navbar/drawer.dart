import 'dart:convert';

import 'package:SoinConnect/pages/device/device-page.dart';
import 'package:SoinConnect/pages/home/home-page.dart';
import 'package:SoinConnect/pages/login/login-page.dart';
import 'package:SoinConnect/pages/membre/membre-page.dart';
import 'package:SoinConnect/pages/patient/patient-page.dart';
import 'package:SoinConnect/pages/rendezVous/rendezVous-page.dart';
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
       user=json.decode(response.body);
     });
    }).catchError((err){
      print(err);
    });

  }
  var menus=[
    {"title":"Home","icon":Icon(Icons.home),"page":HomePage()},
    {"title":"Patient","icon":Icon(Icons.people),"page":PatientPage()},
    {"title":"Mes Patient","icon":Icon(Icons.people),"page":MembrePage()},
    {"title":"Rendez-vous","icon":Icon(Icons.calendar_today),"page":RendezVousPage()},
    {"title":"Devices","icon":Icon(Icons.developer_board),"page":DevicePage()},
    {"title":"Déconnecter","icon":Icon(Icons.logout),"page":LoginPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return (user==null)?Center(child: CircularProgressIndicator(),):
    Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("./images/medecin.png"),
                    radius: 50,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${user["nom"]},${user["prenom"]}",style: TextStyle(fontSize: 25,color: Colors.white),),
                    Text("${user["service"]["nom"]}",style: TextStyle(fontSize: 22,color: Colors.white),),
                    Text("${user["appUser"]["email"]}",style: TextStyle(fontSize: 12,color: Colors.white),),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white,ColorBar]
                )
            ),
          ),
          ...menus.map((item) {
            return Column(
              children: [
                MenuItem(item["title"], item["icon"], item["page"]),
                Divider(color: ColorBar,)
              ],
            );
          })
        ],
      ),
    ) ;

  }
}
