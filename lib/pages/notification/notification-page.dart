import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/pages/notification/notification-traitement.dart';
import 'package:SoinConnect/pages/rendezVous/rendezVous-page.dart';
import 'package:SoinConnect/pages/rendezVousPat/rendezVousPat-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/services/web-socket.dart';
import 'package:flutter/material.dart';
class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Stream<dynamic> stream=streamController.stream;
  List<dynamic> notifications;
  var user;
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
    streamAllMsg.listen((event) {
      setState(() {
        msgStream=event;
      });
    });
    NotificationTraitement().getNotifcation().then((value){
      setState(() {
        this.notifications=NotificationTraitement.notifications;
        user=NotificationTraitement.user;
        filteredList=notifications;
      });
    });


  }
  @override
  Widget build(BuildContext context) {
    return AppService().getGuard(page());
  }
  Widget page(){
    return
      Scaffold(
        appBar: BarWidget().bar(notificationsStream,msgStream),
       drawer: DrawerWidget(),
        body:(notifications == null
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: TextField(
                    decoration:(user["appUser"]['role']=="MEDECIN") ? InputDecoration(hintText: 'Taper un nom d\'un patient ..')
                                                                    : InputDecoration(hintText: 'Taper un nom d\'un médecin ..'),
                    controller: _textController,
                    onChanged: (text) {
                      text = text.toLowerCase();
                      setState(() {
                        filteredList = notifications
                            .where((element) => element["contenu"].toLowerCase().contains(text))
                            .toList();
                      });
                    },
                  ),
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
                            (user["appUser"]['role']=="MEDECIN") ?Navigator.push(context, MaterialPageRoute(builder: (context)=>RendezVousPage()))
                                                                 :Navigator.push(context, MaterialPageRoute(builder: (context)=>RendezVousPatPage()));
                          },
                          child: Card(
                            color: (filteredList[index]['readed']==null)?Colors.black12:Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage:(user["appUser"]['role']=="MEDECIN") ?AssetImage("./images/patientNo.png")
                                                                                               :AssetImage("./images/medecin.png"),
                                        ),
                                      ),
                                  Flexible(
                                         child: Text("${filteredList[index]["contenu"]}",
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                       ),

                                    ],
                                  ),
                            ),
                          ),
                        );
                      }))
          ],
        ))
    );
  }
}
