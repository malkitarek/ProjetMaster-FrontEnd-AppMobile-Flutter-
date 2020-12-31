

import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';

class MessageTraitement{
   static var user;
   static  List<dynamic> membres;
   static List<dynamic> messages;
   Future getMsgMembre() async{

         await AppService().getUser().then((response){
           user= json.decode(response.body);
         }).catchError((err) {
           print(err);
         });

         await AppService().getMembreMsg(user["id"], user["appUser"]["role"]).then((response) async{
             membres=json.decode(response.body);
             for(int i=0;i<membres.length;i++){

               if(user["appUser"]["role"]=='MEDECIN'){
                 await AppService().getUnreadMsg(user["id"],membres[i]["patient"]["id"],user['appUser']["role"]).then((response){
                   membres[i]['h']=json.decode(response.body);
                 });
               }

               else{
                 await AppService().getUnreadMsg(user["id"],membres[i]["medecin"]["id"],user['appUser']["role"]).then((response){
                   membres[i]['h']=json.decode(response.body);
                 });
               }

             }
         }).catchError((err) {
           print(err);
         });

   }



}
