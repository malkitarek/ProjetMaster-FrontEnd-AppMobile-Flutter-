import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DetailMsgTraitement{
  static var user;
  static List<dynamic> messages;

  Future getMessage(idMem) async{

    await AppService().getUser().then((response){
      user= json.decode(response.body);
    }).catchError((err) {
      print(err);
    });

    await AppService().getMessages(user['id'], idMem, user['appUser']['role']).then((response){
      messages=json.decode(utf8.decode(response.bodyBytes));
    });

  }

  Future sendMessage(FormGroup message) async{
    if(message.valid){
      await AppService().sendMessage(message.value).then((response){

      });
    }
  }
}
