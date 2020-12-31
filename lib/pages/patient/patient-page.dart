import 'dart:convert';

import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/createPatient/createPat-page.dart';
import 'package:SoinConnect/pages/detailPatient/detailPatient-page.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/pages/patient/patient-traitement.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/services/web-socket.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {

  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  Stream<dynamic> stream=streamController.stream;
  List<dynamic> patients;
  List<dynamic> notificationsStream;
  Stream<dynamic> streamAllMsg=streamControllerAllMsg.stream;
  List<dynamic> msgStream;
  TextEditingController _textController = TextEditingController();
  List<dynamic> filteredList = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream.listen((event) {
      setState(() {
        notificationsStream=event;
      });
    });
    PatientTraitement().getPats().then((data) {
      setState(() {
        patients = PatientTraitement.patients;
        //print(patients);
        filteredList=patients;
      });
    });
    streamAllMsg.listen((event) {
      setState(() {
        msgStream=event;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return AppService().getGuard(page());
  }

  Widget page() {
    
    return Scaffold(
        appBar: BarWidget().bar(notificationsStream,msgStream),
        drawer: DrawerWidget(),
        body: (patients == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        width: widthScree(context)*0.65,
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Taper un nom d\'un patient ..'),
                          controller: _textController,
                          onChanged: (text) {
                            text = text.toLowerCase();
                            setState(() {
                              filteredList = patients
                                  .where((element) => element["nom"].toLowerCase().contains(text))
                                  .toList();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: widthScree(context)*0.3,
                        child:RaisedButton.icon(
                            color: Colors.green,
                            textColor: Colors.white,
                            icon: Icon(Icons.add),
                            label: Text('Ajouter'),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatePatPage()));
                            }
                        ),
                      )
                    ],
                  ),

                  if (filteredList.length==0 && _textController.text.isNotEmpty)
                    Expanded(
                      child: Container(
                        child: Text('Aucune donnée'),
                      ),
                    )
                  else
                    Expanded(
                        child: ListView.builder(
                            itemCount: (filteredList == null ? 0 : filteredList.length),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPatient(filteredList[index])));
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "./images/patient2.png"),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text("${filteredList[index]["nom"]}",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      "${filteredList[index]["prenom"]}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      "${filteredList[index]["appUser"]["email"]},${filteredList[index]["appUser"]["phone"]}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }))
                ],
              )));
  }
}
