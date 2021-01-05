import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/detailChanel/detailChanel-page.dart';
import 'package:SoinConnect/pages/donnee/donnee-traitement.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:flutter/material.dart';
class DonneePage extends StatefulWidget {
  @override
  _DonneePageState createState() => _DonneePageState();
}

class _DonneePageState extends State<DonneePage> {
  Stream<dynamic> stream = streamController.stream;
  List<dynamic> notificationsStream;
  Stream<dynamic> streamAllMsg = streamControllerAllMsg.stream;
  List<dynamic> msgStream;
  List<dynamic> chanels;
  var user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream.listen((event) {
      if (mounted) {
        setState(() {
          notificationsStream = event;
        });
      }
    });
    streamAllMsg.listen((event) {
      if (mounted) {
        setState(() {
          msgStream = event;
        });
      }
    });
    DonneeTraitement().getChanels().then((value){
      setState(() {
        chanels=DonneeTraitement.chanels;
        user=DonneeTraitement.user;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return AppService().getGuard(page());
  }
  Widget page(){
    return Scaffold(
      appBar: BarWidget().bar(notificationsStream, msgStream),
      drawer: DrawerWidget(),
      body:(chanels==null)?Center(child: CircularProgressIndicator(),)
      :Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount:
                (chanels == null ? 0 : chanels.length),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      if(chanels[index]['capteur']['nom']=="temprature")
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailChanelPage(user['id'], chanels[index]['id'], 'temp')));
                      else if(chanels[index]['capteur']['nom']=="ECG")
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailChanelPage(user['id'], chanels[index]['id'], 'ECG wave')));
                      else if(chanels[index]['capteur']['nom']=="Blood Pressure")
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailChanelPage(user['id'], chanels[index]['id'], 'diastolic')));
                      else if(chanels[index]['capteur']['nom']=="Spo2")
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailChanelPage(user['id'], chanels[index]['id'], 'spo2')));

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
                                  backgroundImage:
                                  AssetImage("./images/${chanels[index]["capteur"]["image"]}"),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${chanels[index]['capteur']['nom']}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.bold)),
                                      Text(
                                          "${chanels[index]["nom"]}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      )
    );
  }
}
