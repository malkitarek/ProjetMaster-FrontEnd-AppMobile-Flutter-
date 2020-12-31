import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';
import 'package:flutter/material.dart';

class PatientTraitement{
    static List<dynamic>  patients;
    Future getPats() async{
     await AppService().getPatients().then((response) {

       patients=json.decode(utf8.decode(response.bodyBytes));

     }).catchError((err){
       print(err);
     });
   }
}
