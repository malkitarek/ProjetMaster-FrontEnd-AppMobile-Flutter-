import 'package:SoinConnect/pages/DetailMedecin/detailMed-traitement.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
class DetailMedecinPage extends StatefulWidget {
  var id;
  DetailMedecinPage(this.id);
  @override
  _DetailMedecinPageState createState() => _DetailMedecinPageState();
}

class _DetailMedecinPageState extends State<DetailMedecinPage> {
  var medecin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DetailMedTraitement().getMed(widget.id).then((value){
      setState(() {
        medecin=DetailMedTraitement.medecin;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détail Médecin'),backgroundColor: ColorBar,),
      body: (medecin==null)?Center(child: CircularProgressIndicator(),)
          :Stack(children: <Widget>[
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
                      image: AssetImage('./images/medecin.png'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${medecin["nom"]},${medecin["prenom"]}",
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
                    title: Text("${medecin["appUser"]["email"]}"),
                    leading: Icon(Icons.email),
                  ),
                  Divider(
                    color: Colors.black12,
                  ),
                  ListTile(
                    title: Text("${medecin["appUser"]["phone"]}"),
                    leading: Icon(Icons.phone),
                  ),
                  Divider(
                    color: Colors.black12,
                  ),
                  ListTile(
                    title: Text("${medecin["service"]['nom']}"),
                    leading: Icon(Icons.business),
                  ),
                  Divider(
                    color: Colors.black12,
                  ),
                  ListTile(
                    title: Row(children: [Text('Numéro de bureau: ',style: TextStyle(fontWeight: FontWeight.bold),),Text("${medecin["numeroBureau"]}"),],),
                    leading: Icon(Icons.meeting_room),
                  ),
                  Divider(
                    color: Colors.black12,
                  ),
                  ListTile(
                    title: Row(children: [Text("Numéro d'étage: ",style: TextStyle(fontWeight: FontWeight.bold),),Text("${medecin["numeroEtage"]}"),],),
                    leading: Icon(Icons.business),
                  ),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}
