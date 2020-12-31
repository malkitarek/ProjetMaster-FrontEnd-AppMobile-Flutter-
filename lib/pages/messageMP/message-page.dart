import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/detailMsg/detailMsg-page.dart';
import 'package:SoinConnect/pages/detailPatient/detailPatient-page.dart';
import 'package:SoinConnect/pages/messageMP/message-traitement.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Stream<dynamic> stream=streamController.stream;
  Stream<dynamic> streamMemMsg=streamControllerMemMsg.stream;
  List<dynamic> membres;
  Stream<dynamic> streamAllMsg=streamControllerAllMsg.stream;
  List<dynamic> msgStream;
  List<dynamic> notificationsStream;
  TextEditingController _textController = TextEditingController();
  List<dynamic> filteredList = List();
  List<dynamic> messages;
  var user;
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
    streamMemMsg.listen((event) {
      MessageTraitement().getMsgMembre().then((value){
        if(mounted){
          setState(() {
            membres=MessageTraitement.membres;
            user=MessageTraitement.user;
            filteredList=membres;
          });
        }
      });
    });

    MessageTraitement().getMsgMembre().then((value){
      setState(() {
        membres=MessageTraitement.membres;
        user=MessageTraitement.user;
        filteredList=membres;
      });
    });


  }
  @override
  Widget build(BuildContext context) {
    return AppService().getGuard(page());;
  }

  Widget page() {
    return Scaffold(
        appBar: BarWidget().bar(notificationsStream,msgStream),
        drawer: DrawerWidget(),
        body: (membres == null
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Column(
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
                        filteredList = membres
                            .where((element) => element["patient"]["nom"].toLowerCase().contains(text))
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
                          onTap: () async{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailMsgPage(filteredList[index]['patient'],user)));
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child:Row(
                                    children: [
                                      Badge(
                                        animationDuration: Duration(milliseconds: 300),
                                        showBadge: (filteredList[index]['h']!=0 && filteredList[index]['h']!=null)?true:false,
                                        animationType: BadgeAnimationType.slide,
                                        badgeColor: ColorBar,
                                        badgeContent: (filteredList[index]['h']!=0 && filteredList[index]['h']!=null)?Text("${filteredList[index]['h']}"
                                                  ,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),):null,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                              "./images/patientNo.png"),
                                        ),
                                      ),
                                      Flexible(
                                          child:Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text("${filteredList[index]["patient"]["nom"]}, ${filteredList[index]['patient']["prenom"]}",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    )),

                                                Text(
                                                    "${filteredList[index]['contenu']}",
                                                    maxLines: 5,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: (filteredList[index]['h']!=0 && filteredList[index]['h']!=null)?FontWeight.bold:FontWeight.normal,
                                                      color: Colors.black,
                                                    )),

                                              ],
                                            ),

                                          ),)
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
