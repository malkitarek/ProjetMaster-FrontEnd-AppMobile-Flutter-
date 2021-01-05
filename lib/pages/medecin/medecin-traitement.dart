import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';

class MedecinTraitement{
  static List<dynamic> medecins;
  static var user;

  Future getMedecinsTraitants() async{
    await AppService().getUser().then((response){
      user=json.decode(response.body);
    });
    await AppService().getMedecinsTraitants(user['id']).then((response){
      medecins=json.decode(utf8.decode(response.bodyBytes));
    });
  }
}
