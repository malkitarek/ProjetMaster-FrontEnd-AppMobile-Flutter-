
import 'package:SoinConnect/pages/login/login-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmTraitement{

  onConfirm(_formKey,code,id,context) async{
    if(_formKey.currentState.validate()){
      dynamic codeConfirm ={
        "code":code.text,
      };
    var res=await AppService().saveCode(codeConfirm, id);
    print(res);
    if(res!=null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }
    }

  }
}
