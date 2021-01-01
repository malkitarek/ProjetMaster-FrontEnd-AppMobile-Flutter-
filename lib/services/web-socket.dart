import 'dart:async';
import 'dart:convert';
import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/patient/patient-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketApi{
  static var apiCommunication='http://192.168.43.17:8083/websocket';
  static var apiDonnees='http://192.168.43.17:8082/websocket';
  static var user;
  Future<StompClient> getRealTimeNotif() async{
    return await StompClient(
        config: StompConfig.SockJS(
          url: apiCommunication,
          onConnect: (StompClient client, StompFrame connectFrame){
            client.subscribe(
                destination: '/topic/notifications',
                headers: {'Content-Type': 'application/json; charset=utf-8'},
                callback: (StompFrame frame) {
                  var notifs = json.decode(frame.body);
                        streamController.add(notifs);
                    }
                  );
                },

          onWebSocketError: (dynamic error) => print("errror==${error.toString()}"),
        ));
  }

  Future<StompClient> getRealTimeMemMsg() async{
    return await StompClient(
        config: StompConfig.SockJS(
          url: apiCommunication,
          onConnect: (StompClient client, StompFrame connectFrame){
            client.subscribe(
                destination: '/topic/msgsMembres',
                headers: {'Content-Type': 'application/json; charset=utf-8'},
                callback: (StompFrame frame) {
                  var membresSocket = json.decode(frame.body);
                      streamControllerMemMsg.add(membresSocket);
                }
            );
          },
          onWebSocketError: (dynamic error) => print("errror==${error.toString()}"),
        ));
  }
  Future<StompClient> getRealTimeAllMsg() async{
    return await StompClient(
        config: StompConfig.SockJS(
          url: apiCommunication,
          onConnect: (StompClient client, StompFrame connectFrame){
            client.subscribe(
                destination: '/topic/allMessages',
                headers: {'Content-Type': 'application/json; charset=utf-8'},
                callback: (StompFrame frame) {
                 // print('dgggd');
                  var messages = json.decode(frame.body);
                  streamControllerAllMsg.add(messages);

                }
            );
          },
          onWebSocketError: (dynamic error) => print("errror==${error.toString()}"),
        ));
  }

  Future<StompClient> getRealTimeMessge() async{
    return await StompClient(
        config: StompConfig.SockJS(
          url: apiCommunication,
          onConnect: (StompClient client, StompFrame connectFrame){
            client.subscribe(
                destination: '/topic/messages',
                headers: {'Content-Type': 'application/json; charset=utf-8'},
                callback: (StompFrame frame) {
                  var messages = json.decode(frame.body);

                  streamControllerMessge.add(messages);
                }
            );
          },
          onWebSocketError: (dynamic error) => print("errror==${error.toString()}"),
        ));
  }

  Future<StompClient> getRealTimeDonnees() async{
    return await StompClient(
        config: StompConfig.SockJS(
          url: apiDonnees,
          onConnect: (StompClient client, StompFrame connectFrame){
            client.subscribe(
                destination: '/topic/donnees',
                headers: {'Content-Type': 'application/json; charset=utf-8'},
                callback: (StompFrame frame) {
                  var donnees = json.decode(frame.body);
                  streamControllerDonnees.add(donnees);
                }
            );
          },
          onWebSocketError: (dynamic error) => print("errror==${error.toString()}"),
        ));
  }



}
