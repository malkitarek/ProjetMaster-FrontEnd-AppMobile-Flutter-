import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';

class DonneeTraitement{
  static var chanels;
  static var user;
  Future getChanels() async {
    await AppService().getUser().then((response) {
      user = json.decode(utf8.decode(response.bodyBytes));
    });
    await AppService().getChanels(user['id']).then((response) {
      chanels = json.decode(utf8.decode(response.bodyBytes));
    });
  }
}
