import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';

class DetailMedTraitement{
  static var medecin;
  Future getMed(id) async{
    await AppService().getMedecin(id).then((response){
      medecin=json.decode(utf8.decode(response.bodyBytes));
    });
  }
}
