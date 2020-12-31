
import 'dart:convert';
import 'package:SoinConnect/pages/rendezVous/rendezVous-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RendezVousTraitement {

  static List<dynamic> membres;
  static List<dynamic> rendezVous;
  static var user;

  Future getRendez() async {
    await AppService().getUser().then((response) {
      user = json.decode(response.body);
    }).catchError((err) {
      print(err);
    });
    await AppService().getRendezVous(user["id"]).then((response) {
      rendezVous = json.decode(utf8.decode(response.bodyBytes));
    }).catchError((err) {
      print(err);
    });
  }

  Future getMems() async {
    await AppService().getUser().then((response) {
      user = json.decode(response.body);
      // print("user id==${user["id"]}");
    }).catchError((err) {
      print(err);
    });
    await AppService().getMembres(user["id"]).then((response) {
      membres = json.decode(utf8.decode(response.bodyBytes));
    }).catchError((err) {
      print(err);
    });
  }
  Future saveRendez(form,context) async {
    if (form.valid) {
      dynamic rendez= form.value;
      await AppService().saveRendezVous(rendez).then((res){
        var response=json.decode(res.body);
        if(res.statusCode==200 || res.statusCode==201){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RendezVousPage()));
        }else{

          print("errrror==${response["message"]}");
        }

      }).catchError((err){
        print(err);
      });
    }
  }
  Future deleteRendez(idRendez,context) async{
    await AppService().deleteRendezVous(idRendez).then((res){
      var response=json.decode(res.body);
      if(res.statusCode==200 || res.statusCode==201){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RendezVousPage()));
      }else{

        print("errrror==${response["message"]}");
      }

    }).catchError((err){
      print(err);
    });
  }
}
