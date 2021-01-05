import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/pages/rendezVousPat/rendeyVousPat-traitement.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class RendezVousPatPage extends StatefulWidget {
  @override
  _RendezVousPatPageState createState() => _RendezVousPatPageState();
}

class _RendezVousPatPageState extends State<RendezVousPatPage> {
  Stream<dynamic> stream = streamController.stream;
  List<dynamic> notificationsStream;
  Stream<dynamic> streamAllMsg = streamControllerAllMsg.stream;
  List<dynamic> msgStream;
  List<dynamic> rendezVous;
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
    RendezVousPatTraitement().getRendezPat().then((value){
      setState(() {
        rendezVous=RendezVousPatTraitement.rendezVous;
        filteredList=rendezVous;
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
      body: (rendezVous == null)
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
                      filteredList = rendezVous
                          .where((element) => element["medecin"]["nom"].toLowerCase().contains(text))
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
                          showModalRendezVous("Détail Rendez-Vous", filteredList[index]);
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
                                          "./images/rendez-vous.png"),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text("${filteredList[index]["titre"]}",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                          Text(
                                              "${filteredList[index]["medecin"]['service']['nom']}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                          Text(
                                              "${filteredList[index]["medecin"]["nom"]},${filteredList[index]["medecin"]["prenom"]}",
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
  /********************************************** showModal Rendez-Vous *************************************************/

  void showModalRendezVous(text, content) {
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
              body:Stack(children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: avatarDecoration,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: avatarDecoration,
                        padding: EdgeInsets.all(3),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('./images/rendez-vous.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${content["titre"]}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      height: 350,
                      child: ListView(
                        children: <Widget>[
                          Divider(
                            color: Colors.black12,
                          ),
                          ListTile(
                            title: Row(children: [Text("Médecin: ",style: TextStyle(fontWeight: FontWeight.bold),)
                              ,Text("${content["medecin"]["nom"]}, ${content['medecin']["prenom"]}")],),
                            leading: Icon(Icons.people),
                          ),
                          Divider(
                            color: Colors.black12,
                          ),
                          ListTile(
                            title: Row(children: [Text("Service: ",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text("${content["medecin"]["service"]["nom"]}"),],),
                            leading: Icon(Icons.business),
                          ),
                          Divider(
                            color: Colors.black12,
                          ),
                          ListTile(
                            title: Row(children: [Text("Date: ",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text("${DateFormat("d MMM y").format(DateTime.parse(content["dateDebut"]))}"),],),
                            leading: Icon(Icons.calendar_today),
                          ),
                          Divider(
                            color: Colors.black12,
                          ),
                          ListTile(
                            title:Row(children: [Text("Heure: ",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text("${DateFormat("h:mm a").format(DateTime.parse(content["dateDebut"]))}"),],),
                            leading: Icon(Icons.alarm),
                          ),
                          Divider(
                            color: Colors.black12,
                          ),
                          ListTile(
                            title:Row(children: [Text("Etat: ",style: TextStyle(fontWeight: FontWeight.bold),),
                              (content['validation']=="Rendez-Vous validé")
                                  ?Text("Rendez-Vous a validé")
                                  :FlatButton.icon(
                                       textColor: Colors.white,
                                        label: Text('Validé'),
                                        icon: Icon(Icons.check),
                                        color: Colors.green,
                                        onPressed: (){
                                           RendezVousPatTraitement().validerRendez(content['id']).then((value){
                                             Navigator.push(context, MaterialPageRoute(builder: (context)=>RendezVousPatPage()));
                                           });
                                        }),
                            ],),
                            leading: Icon(Icons.exit_to_app),
                          ),
                          Divider(
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ]),
            ),
          );
        });
  }
}
