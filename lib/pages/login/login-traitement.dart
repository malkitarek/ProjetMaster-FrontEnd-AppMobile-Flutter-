import 'package:SoinConnect/pages/home/home-page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:SoinConnect/services/app-service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginTraitement{

  void displayDialog(context, title, text) => showDialog(

          context: context,
          builder: (context) =>
              AlertDialog(
                  title: Text(title),
                  content: Text(text),

              ),
  );

   Future onLogin(_formKey,email,password,context) async{

              if(_formKey.currentState.validate()){
              dynamic user ={
              "email":email.text,
              "password":password.text,
              };
              var jwt = await AppService().login(user);

              if(jwt != null) {
                var role=JwtDecoder.decode(jwt)["roles"][0];
                if(role["authority"]=="MEDECIN" || role["authority"]=="PATIENT"){
                  AppService().saveTokent(jwt);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                }else {
                  displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                }
              } else {
                 displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
              }
              }
  }

}
