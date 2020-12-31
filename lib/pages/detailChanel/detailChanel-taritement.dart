import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';

class DetailChanelTraitement{
  static List<dynamic> data;
  static List<dynamic> lastData;
  static List<dynamic> feilds;
  Future getDonnees(idPat, idChanel, nomFeild,dateCalen,heure) async{
    var donnees;
    var dateVal;
     await AppService().getDonnees(idPat, idChanel, nomFeild).then((response) async{
       data=List<dynamic>();
       donnees=await json.decode(response.body);
       for(int i=0;i<donnees.length;i++){
         dateVal=donnees[i]['time'];
         if(dateVal.split("T")[0]==dateCalen){
           if( ((int.parse(dateVal.split("T")[1].split(":")[0]))+1)==int.parse(heure.toString())){
             data.add(donnees[i]);
           }

         }

       }
       return data;
     });
  }

  Future getLastMesures(idPat, idChanel, nomFeild) async{

    await AppService().getLastMesures(idPat, idChanel, nomFeild).then((response){
      //print('response=${response.bodyBytes}');
      lastData=json.decode(utf8.decode(response.bodyBytes));
    });

  }

  Future getFeilds(idPat,idChanel) async{
    await AppService().getFeilds(idPat, idChanel).then((response){
      feilds=json.decode(utf8.decode(response.bodyBytes));
    });
  }

}
