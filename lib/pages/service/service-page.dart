import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/DetailMedecin/detailMed-page.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/pages/service/service-traitement.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  Stream<dynamic> stream = streamController.stream;
  List<dynamic> notificationsStream;
  Stream<dynamic> streamAllMsg = streamControllerAllMsg.stream;
  List<dynamic> msgStream;
  List<dynamic> services;
  List<dynamic> filteredList;
  TextEditingController _textController = TextEditingController();

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
    ServiceTraitement().getServices().then((value){
      setState(() {
        services=ServiceTraitement.services;
        filteredList=services;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppService().getGuard(page());;
  }
  Widget page(){
    return Scaffold(
      appBar: BarWidget().bar(notificationsStream, msgStream),
      drawer: DrawerWidget(),
      body: (services == null)
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                width: widthScree(context)*0.9,
                child: TextField(
                  decoration: InputDecoration(hintText: 'Taper un nom d\'un service ..'),
                  controller: _textController,
                  onChanged: (text) {
                    text = text.toLowerCase();
                    setState(() {
                      filteredList = services
                          .where((element) => element["nom"].toLowerCase().contains(text))
                          .toList();
                    });
                  },
                ),
              ),
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
                          showModalMedsTrai("Médecins Traitants", filteredList[index]['medt']);
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
                                          "./images/consultation.jpg"),
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
                                              "${filteredList[index]['nomCHU']}",
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
                              ],
                            ),
                          ),
                        ),
                      );
                    }))
        ],
      ),
    );
  }
  /********************************************** showModal Medecins traitants *************************************************/

  void showModalMedsTrai(text, content) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: ColorBar,
                title: Text(text),
              ),
              body: Container(
                child: (content == null)
                    ? Center(
                  child: Text("Aucun"),
                )
                    : ListView.builder(
                    itemCount: content.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap:() {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailMedecinPage(content[index]['id'])));
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
                                          "./images/medecin.png"),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text("${content[index]["nom"]}",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                          Text(
                                              "${content[index]["prenom"]}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                          Text(
                                              "${content[index]["service"]["nom"]}",
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
                    }),
              ),
            ),
          );
        });
  }
}
