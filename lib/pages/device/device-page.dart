import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/device/device-traitement.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
class DevicePage extends StatefulWidget {
  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  Stream<dynamic> stream=streamController.stream;
  List<dynamic> devices;
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
  DeviceTraitement().getDevices().then((value){
    setState(() {
      devices=DeviceTraitement.devices;
      filteredList=devices;
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
        body: (devices == null
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
                    decoration: InputDecoration(hintText: 'Taper un nom d\'une device ..'),
                    controller: _textController,
                    onChanged: (text) {
                      text = text.toLowerCase();
                      setState(() {
                        filteredList = devices
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
                        DeviceTraitement().showModalCreateDevice("Ajouter device", null, context);
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
                                            "./images/device.png"),
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
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                            Text(
                                                "${filteredList[index]["patient"]["nom"]}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w300)),
                                            Text(
                                                "${filteredList[index]["patient"]["prenom"]}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w300)),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(

                                    children: [
                                      IconButton(icon: Icon(Icons.edit),
                                          color: Colors.blue,
                                          iconSize: 20,
                                          onPressed: (){
                                              DeviceTraitement().showModalCreateDevice(
                                                  "Modifier device",
                                                  filteredList[index],
                                                  context);
                                          }
                                      ),
                                      IconButton(icon: Icon(Icons.delete),
                                          color: Colors.red,
                                          iconSize: 20,
                                          onPressed: (){
                                           DeviceTraitement().displayDialog(context, "Supprimer Device", "Veuillez-vous vraimment supprimer cette device?",filteredList[index]);
                                          }
                                          )
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
