import 'dart:convert';

import 'package:SoinConnect/services/app-service.dart';

class NotificationTraitement{
  static var user;
  static var notifications;

  Future getNotifcation() async{

        await AppService().getUser().then((response){
          user = json.decode(response.body);
        }).catchError((err) {
          print(err);
        });
        await AppService().getNotifications(user["id"],user["appUser"]["role"]).then((response) {
          json.decode(utf8.decode(response.bodyBytes));
          notifications = json.decode(utf8.decode(response.bodyBytes));
        }).catchError((err) {
          print(err);
        });

  }
}
