import 'dart:convert';

import 'package:SoinConnect/pages/patient/patient-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:flutter/material.dart';

class CreatePatTraitement{
  static var messageErr=null;
  Future savePat(form,formDossier,context) async {

    if (form.valid && formDossier.valid) {
      dynamic patient= {}..addAll(form.value)..addAll(formDossier.value);
      print("$patient");
      await AppService().savePatient(patient).then((res){
        var response=json.decode(res.body);
        if(res.statusCode==200 || res.statusCode==201){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientPage()));
        }else{

          messageErr=response["message"];
          print("$messageErr");
        }

      }).catchError((err){
        print(err);
      });
    }
  }
}
