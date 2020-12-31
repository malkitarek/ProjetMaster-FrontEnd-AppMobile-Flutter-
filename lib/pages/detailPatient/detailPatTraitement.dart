
import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';

class DetailPatTraitement{
  static List<dynamic> membres;
  static var user;

  Future getPat(patient) async {
    await AppService().getUser().then((response) {
      user = json.decode(response.body);
      // print("user id==${user["id"]}");
    }).catchError((err) {
      print(err);
    });
    await AppService().getMembres(user["id"]).then((response) {
      membres = json.decode(utf8.decode(response.bodyBytes));
      var y = 0;
      for (var i = 0; i < membres.length; i++) {
        if (patient["id"] == membres[i]["id"]) {
          y = 1;
        }
        if (y == 1) patient["x"] = 1;
        else patient["x"] = 0;
      }

    }).catchError((err) {
      print(err);
    });
  }

  Future affilierPat(idPat) async{
    await AppService().getUser().then((response) {
      user = json.decode(response.body);
      // print("user id==${user["id"]}");
    }).catchError((err) {
      print(err);
    });
    await AppService().affilPatient(idPat, user['id']).then((response) {

    }).catchError((err) {
      print(err);
    });
  }

}
