import 'dart:async';
import 'dart:convert';

import 'package:SoinConnect/pages/home/home-page.dart';
import 'package:SoinConnect/pages/notification/notification-traitement.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/services/web-socket.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_frame.dart';


class BarWidget  {
  static var notifications;
  static var notfNoReaded;
  static var msgNoReaded;
  static var user;
  Future getNotifs(notifcationsStream) async{
    await NotificationTraitement().getNotifcation().then((value) async{
      notifications=  await NotificationTraitement.notifications;
    });
    var y=0;
    if(notifications!=null){
      for(int i=0;i<notifications.length;i++){
        if (notifications[i]['readed']==null)y=y+1;
      }
    }

    return y;
  }
  Future getAllMessageNoReaded(msgNoReadedStream) async{
   await AppService().getUser().then((response){
     user=json.decode(response.body);

   });
   await AppService().getAllMsgNoReaded(user['id'], user['appUser']['role']).then((response){
     if(response.statusCode == 200 && response.statusCode == 201) msgNoReaded=json.decode(response.body);
   });


    return msgNoReaded;
  }

  Widget bar(notificationsStream,msgNoReadedStream) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            './images/logo.png',
            fit: BoxFit.contain,
            height: 32,
          ),
          Container(
              padding: const EdgeInsets.all(6.0), child: Text('SoinConnect')
          ),
        ],

      ),
      actions: <Widget>[
        FutureBuilder(
            future: getNotifs(notificationsStream),
            builder: (context,snapshot){
              return Badge(
                position: BadgePosition.topEnd(top: 0, end: 3),
                animationDuration: Duration(milliseconds: 300),
                showBadge: (snapshot.data==null || snapshot.data==0)?false:true,
                animationType: BadgeAnimationType.slide,
                badgeColor: Colors.greenAccent,
                badgeContent:(snapshot.data==null || snapshot.data==0)?null
                                    :Text('${snapshot.data}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                child: IconButton(
                  padding: EdgeInsets.all(5.0),
                  icon:(ModalRoute.of(context).settings.name!="/notifications")?Icon(Icons.notifications_none):Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/notifications");
                  },
                ),);
            }),

        FutureBuilder(
            future: getAllMessageNoReaded(msgNoReadedStream),
            builder: (context,snapshot){
              return Badge(
                position: BadgePosition.topEnd(top: 0, end: 3),
                animationDuration: Duration(milliseconds: 300),
                showBadge: (snapshot.data==null || snapshot.data==0)?false:true,
                animationType: BadgeAnimationType.slide,
                badgeColor: Colors.greenAccent,
                badgeContent:(snapshot.data==null || snapshot.data==0)?null
                    :Text('${snapshot.data}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                child: IconButton(
                  padding: EdgeInsets.all(5.0),
                  icon:(ModalRoute.of(context).settings.name!="/messages")?Icon(Icons.message_outlined):Icon(Icons.message),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/messages");
                  },
                ),);
            }),
      ],
      backgroundColor: ColorBar,
    );

  }



}




