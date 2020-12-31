
import 'dart:convert';

import 'package:SoinConnect/pages/confirm/confirm-page.dart';
import 'package:SoinConnect/pages/login/login-traitement.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterTraitement{

  onRegister(_formKey,email,password,repassword,context) async{

    if(_formKey.currentState.validate()) {
      dynamic user = {
        "email": email.text,
        "password": password.text,
        "repassword": repassword.text,
      };
      print("user==$user");
      var userRes= await AppService().saveUser(user,0);
      print("userId==${userRes["id"]}");
     if(userRes!=null){
       Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmPage(userRes["id"])));
     }else{
       LoginTraitement().displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
     }
    }

  }
}
