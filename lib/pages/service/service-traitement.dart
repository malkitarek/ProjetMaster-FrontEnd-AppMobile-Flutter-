import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';

class ServiceTraitement{
  static var user;
  static List<dynamic> medecins;
  static List<dynamic> services;
  Future getServices() async{
    await AppService().getUser().then((response){
      user=json.decode(response.body);
    });
    await AppService().getMedecinsTraitants(user['id']).then((response){
      medecins=json.decode(utf8.decode(response.bodyBytes));
    });
    await AppService().getServices().then((response){
      services=json.decode(utf8.decode(response.bodyBytes));
    });
    for(int i=0;i<services.length;i++){
      var x=0;
      services[i]['medt']=[];
      for(int j=0;j<medecins.length;j++){
        if(medecins[j]["service"]["nom"]==services[i]['nom']){
          services[i]["medt"].add(medecins[j]);
          x=x+1;
        }
      }
    }
  }
}
