import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';

class RendezVousPatTraitement{
  static var rendezVous;
  static var medecins;
  static var user;


  Future getRendezPat() async{
    await AppService().getUser().then((response){
      user=json.decode(utf8.decode(response.bodyBytes));
    });
    await AppService().getRendezVousP(user['id']).then((response){
      rendezVous=json.decode(utf8.decode(response.bodyBytes));
    });
    await AppService().getMedecinsTraitants(user['id']).then((response){
      medecins=json.decode(utf8.decode(response.bodyBytes));
    });

    for(int i=0;i<rendezVous.length;i++){
      for(int j=0;j<medecins.length;j++){
        if(medecins[j]["id"]==rendezVous[i]['idMedecin']){
          rendezVous[i]["medecin"]=medecins[j];
          break;
        }
      }
    }
  }

  Future validerRendez(idRendez) async{
   await AppService().validerRendez(idRendez).then((response){
     if(response.statusCode==200 || response.statusCode==201){

     }
   });
  }
}
