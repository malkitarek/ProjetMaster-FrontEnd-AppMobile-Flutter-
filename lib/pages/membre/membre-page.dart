import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/createPatient/createPat-page.dart';
import 'package:SoinConnect/pages/detailMembre/detailMembre-page.dart';
import 'package:SoinConnect/pages/detailPatient/detailPatient-page.dart';
import 'package:SoinConnect/pages/membre/membre-traitement.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/pages/updatePatient/updatePat-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/services/web-socket.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
class MembrePage extends StatefulWidget {
  @override
  _MembrePageState createState() => _MembrePageState();
}

class _MembrePageState extends State<MembrePage> {
  Stream<dynamic> stream=streamController.stream;
  List<dynamic> membres;
  List<dynamic> notificationsStream;
  Stream<dynamic> streamAllMsg=streamControllerAllMsg.stream;
  List<dynamic> msgStream;
  TextEditingController _textController = TextEditingController();
  List<dynamic> filteredList = List();
  void displayDialog(context, title, text,patient) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
                RaisedButton(
                    color: Colors.red,
                    child: Text("Supprimer"),
                    onPressed: () async{
                      await MembreTraitement().supprimePat(patient["id"]).then((value){
                        Navigator.pop(context,false);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MembrePage()));
                      });
                    }),
                RaisedButton(
                    child: Text("Cancel"),
                    onPressed: (){Navigator.pop(context,false);}),

          ],
        ),
  );

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
    MembreTraitement().getMems().then((data) {
      setState(() {
        membres = MembreTraitement.membres;
        //print(membres);
        filteredList=membres;
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
        body: (membres == null
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
                        filteredList = membres
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
                      }),
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

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                 Row(
                                   children: [
                                     IconButton(icon: Icon(Icons.remove_red_eye),
                                         color: Colors.green,
                                         iconSize: 25,
                                         onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailMemPage(filteredList[index])))
                                     ),
                                     IconButton(icon: Icon(Icons.edit),
                                         color: Colors.blue,
                                         iconSize: 25,
                                         onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdatePatPage(filteredList[index])))
                                     ),
                                     IconButton(icon: Icon(Icons.delete),
                                         color: Colors.red,
                                         iconSize: 25,
                                         onPressed: ()=> displayDialog(context, "Supprimer Patient", "Veuillez-vous vraimment supprimer ce patient?",filteredList[index])),
                                   ],
                                 )

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
