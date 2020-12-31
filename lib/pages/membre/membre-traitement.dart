import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';

class MembreTraitement {
  static List<dynamic> membres;
  static var user;

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

  Future supprimePat(idPat) async{
    await AppService().getUser().then((response) {
      user = json.decode(response.body);
      // print("user id==${user["id"]}");
    }).catchError((err) {
      print(err);
    });
    await AppService().suppPatient(idPat, user['id']).then((response) {

    }).catchError((err) {
      print(err);
    });
  }
}
