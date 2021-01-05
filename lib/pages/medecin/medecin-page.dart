import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/DetailMedecin/detailMed-page.dart';
import 'package:SoinConnect/pages/medecin/medecin-traitement.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
class MedecinPage extends StatefulWidget {
  @override
  _MedecinPageState createState() => _MedecinPageState();
}

class _MedecinPageState extends State<MedecinPage> {
  Stream<dynamic> stream = streamController.stream;
  List<dynamic> notificationsStream;
  Stream<dynamic> streamAllMsg = streamControllerAllMsg.stream;
  List<dynamic> msgStream;
  List<dynamic> medecins;
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

    MedecinTraitement().getMedecinsTraitants().then((value){
      setState(() {
        medecins=MedecinTraitement.medecins;
        filteredList=medecins;
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
      body: (medecins == null)
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
                  decoration: InputDecoration(hintText: 'Taper un nom d\'un medecin ..'),
                  controller: _textController,
                  onChanged: (text) {
                    text = text.toLowerCase();
                    setState(() {
                      filteredList = medecins
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
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailMedecinPage(filteredList[index]['id'])));
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
                                              "${filteredList[index]['service']['nom']}",
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
      ),
    );
  }
}

