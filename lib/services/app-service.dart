import 'dart:convert';
import 'package:SoinConnect/pages/home/home-page.dart';
import 'package:SoinConnect/pages/login/login-page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:reactive_forms/reactive_forms.dart';


final storage = FlutterSecureStorage();
class AppService{
  var jwtToken=null;
  String host="http://192.168.43.17:8888";

/**************************************** Gestion d'authentification ******************************************************/
  Future login(user) async{

        var res = await http.post(
            "$host/login",
            headers:{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body:json.encode(user)
        );
        if(res.statusCode == 200) return res.headers['authorization'];
        return null;
  }


  void saveTokent(jwt){
      storage .write(key: "token", value: jwt);
  }
   Future loadToken() async{
    return  await storage.read(key: "token");

  }
  Future getJwtOrEmpty() async{
    var jwt= await loadToken();
    if(jwt==null)return "";
    else return jwt;
  }
  deleteToken() async{
    await storage.delete(key: "token");
  }

  saveUser(user,etat) async{
    var res = await http.post(
        "$host/register/$etat",
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:json.encode(user)
    );
    if(res.statusCode == 200) return jsonDecode(res.body);
    return null;
  }

  saveCode(code,id) async{
    print("id==$code");
    var res = await http.post(
        "$host/confirme/$id",
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:json.encode(code)
    );
    if(res.statusCode == 200) return res.body;
    return null;
  }

  getEmail() async{
    this.jwtToken= await loadToken();

    if(this.jwtToken!=null) return JwtDecoder.decode(this.jwtToken)["sub"];
    else return null;
  }
  getRole() async{
    this.jwtToken= await loadToken();
    if(this.jwtToken!=null) return JwtDecoder.decode(this.jwtToken)["roles"][0]["authority"];
    else return null;
  }

  Future getUser() async {
    var role = await this.getRole();
    var email = await this.getEmail();
    if (role == "MEDECIN") {
      var jwt = await loadToken();
      return await http.get(
        "$host/suivi-patient-service/medecin/$email",
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': jwt,
        },
      );
    }else if (role == "PATIENT") {
      var jwt = await loadToken();
      return await http.get(
        "$host/suivi-patient-service/patient/$email",
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': jwt,
        },
      );
    }
  }

  Widget getGuard(page){
    var futureBuilder=new FutureBuilder(
      future:  getJwtOrEmpty(),
      builder: (context,snapshot){
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
        if(snapshot.data != ""){
          return page;
        }else{
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),(e) => false);
        }
      },);
    return futureBuilder;
  }
  Widget getInversGuard(page){
    var futureBuilder=new FutureBuilder(
      future:  getJwtOrEmpty(),
      builder: (context,snapshot){
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
        if(snapshot.data != ""){
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()),(e) => false);
        }else{
          return page;
        }
      },);
    return futureBuilder;
  }

/***************************************************** Gestion des patients *************************************************/
  Future getPatients()async{
    var jwt=await loadToken();
    return await http.get(
        "$host/suivi-patient-service/patients",
        headers:{
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization':jwt,
        },
    );
  }
  Future getMembres(idMed)async{
    var jwt=await loadToken();
    return await http.get(
      "$host/suivi-patient-service/membres/$idMed",
      headers:{
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization':jwt,
      },
    );
  }
  Future savePatient(patient) async{
    var jwt=await loadToken();
    return  await http.post(
        "$host/suivi-patient-service/patients",
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':jwt,
        },
        body:json.encode(patient)
    );

  }

  Future updatePatient(patient,idPat) async{
    var jwt=await loadToken();
    return  await http.put(
        "$host/suivi-patient-service/patients/$idPat",
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':jwt,
        },
        body:json.encode(patient)
    );

  }

  Future suppPatient(idPat,idMed) async{
    var jwt=await loadToken();
    return  await http.get(
        "$host/suivi-patient-service/supprimer/$idPat/$idMed",
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':jwt,
        },

    );

  }

  Future affilPatient(idPat,idMed) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/suivi-patient-service/affilier/$idPat/$idMed",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }

  Future getMedecinsTraitants(idPat) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/suivi-patient-service/medecinsTraitants/$idPat",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
}

Future getConsultations(idPat,idMed) async{
  var jwt=await loadToken();
  return  await http.get(
    "$host/suivi-patient-service/consulations/$idPat/$idMed",
    headers:{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':jwt,
    },

  );
}

  Future saveConsultation(consultation) async{
    var jwt=await loadToken();
    return  await http.post(
        "$host/suivi-patient-service/consulations",
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':jwt,
        },
        body:json.encode(consultation)
    );

  }

  Future deleteConsultations(idCons) async{
    var jwt=await loadToken();
    return  await http.delete(
      "$host/suivi-patient-service/consulations/$idCons",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }

/*********************************** Gestion Communication ***************************************************/
  Future getRendezVous(idMed) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/communication-service/rendezVous/$idMed",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }

  Future saveRendezVous(rendez) async{
    var jwt=await loadToken();
    return  await http.post(
        "$host/communication-service/rendezVous",
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':jwt,
        },
        body:json.encode(rendez)
    );

  }

  Future deleteRendezVous(idRendez) async{
    var jwt=await loadToken();
    return  await http.delete(
      "$host/communication-service/rendezVous/$idRendez",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }

  Future getNotifications(idUser,role) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/communication-service/notifications/$idUser/$role",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }

  Future getMembreMsg(idUser,role) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/communication-service/membresMsg/$idUser/$role",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }

  Future getUnreadMsg(idUser,idMem,role) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/communication-service/messagesUnread/$idUser/$idMem/$role",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }
  Future getAllMsgNoReaded(idUser,fromQui) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/communication-service/allmessagesUnread/$idUser/$fromQui",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }
  Future getMessages(idUser,idMem,role) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/communication-service/messages/$idUser/$idMem/$role",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }

  Future sendMessage(message) async{
    var jwt=await loadToken();
    return  await http.post(
        "$host/communication-service/messages",
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':jwt,
        },
        body:json.encode(message)
    );

  }
 /************************************************************Gestion device*****************************************************/
  Future getDevices() async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/device-service/devices",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }
  Future saveDevice(device) async{
    var jwt=await loadToken();
    return  await http.post(
        "$host/device-service/devices",
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':jwt,
        },
        body:json.encode(device)
    );

  }
  Future deleteDevice(idDevice,idPat) async{
    var jwt=await loadToken();
    return  await http.delete(
      "$host/device-service/devices/$idDevice/$idPat",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }
  Future getChanels(idPat) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/device-service/chanels/$idPat",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }

  Future getDonnees(idPat, idChanel,nomFeild) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/device-service/donnees?patient_id=$idPat&chanel_id=$idChanel&feild_nom=$nomFeild",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }

  Future getLastMesures(idPat, idChanel,nomFeild) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/device-service/lastDonnees?patient_id=$idPat&chanel_id=$idChanel&feild_nom=$nomFeild",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }

  Future getFeilds(idPat, idChanel) async{
    var jwt=await loadToken();
    return  await http.get(
      "$host/device-service/feilds?patient_id=$idPat&chanel_id=$idChanel",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },

    );
  }







  Future<Map<String, dynamic>> uniqueEmail(AbstractControl control) async {
    final error = {'unique': false};
    var  tt=false;
    var jwt=await loadToken();
    await http.get(
        "$host/suivi-patient-service/patient/${control.value}/${control.parent.value["id"]}",
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':jwt,
        },
    ).then((response) {
      print("respooonse===${response.body}");
      if (response.body=="true") {
        tt=true;

      }
    });
    if(tt==true){
      control.markAsTouched();
      return error;
    }


    return null;
  }

  Future<Map<String, dynamic>> uniqueNumIdentite(AbstractControl control) async {

    final error = {'unique': false};

    var  tt=false;
    var jwt=await loadToken();
    await http.get(
      "$host/suivi-patient-service/patientNIden/${control.value}/${control.parent.value["id"]}",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },
    ).then((response) {
      print("respooonse===${response.body}");
      if (response.body=="true") {
        tt=true;

      }
    });
    if(tt==true){

      control.markAsTouched();
      return error;
    }


    return null;
  }

  Future<Map<String, dynamic>> uniqueNumAssurance(AbstractControl control) async {
    final error = {'unique': false};
    var  tt=false;
    var jwt=await loadToken();
    await http.get(
      "$host/suivi-patient-service/patientNAssu/${control.value}/${control.parent.value["id"]}",
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':jwt,
      },
    ).then((response) {
      print("respooonse===${response.body}");
      if (response.body=="true") {
        tt=true;

      }
    });
    if(tt==true){

        control.markAsTouched();
        return error;
    }


    return null;
  }


}
