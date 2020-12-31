import 'package:SoinConnect/pages/detailPatient/detailPatTraitement.dart';
import 'package:SoinConnect/pages/membre/membre-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailPatient extends StatefulWidget {
  var patientt;
  DetailPatient(this.patientt);
  @override
  _DetailPatientState createState() => _DetailPatientState();
}

class _DetailPatientState extends State<DetailPatient> {
  var pat;

  void displayDialog(context, title, text,patient) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            RaisedButton(
                color: Colors.green,
                child: Text("Affilier"),
                onPressed: () async{
                  await DetailPatTraitement().affilierPat(patient["id"]).then((value){
                    //Navigator.pop(context,false);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MembrePage()),(e) => false);
                  });
                }),
            RaisedButton(
                child: Text("Cancel"),
                onPressed: (){
                  Navigator.pop(context,false);
                }),

          ],
        ),
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DetailPatTraitement().getPat(widget.patientt).then((data) {
      setState(() {
        pat=widget.patientt;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return AppService().getGuard(page());
  }
  Widget page(){
    return Scaffold(
        appBar: AppBar(
          title: Text('Détail patient'),
          backgroundColor: ColorBar,
        ),
        body: (pat==null)?Center(child: CircularProgressIndicator(),)
            :Stack(children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: widthScree(context)*0.5,
                height: 150,
                padding: EdgeInsets.all(8),
                decoration: avatarDecoration,
                child: Container(
                  decoration: avatarDecoration,
                  padding: EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('./images/patient2.png'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "${pat["nom"]},${pat["prenom"]}",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Divider(color: Colors.black12,),
                    ListTile(
                      title: Text("${pat["appUser"]["email"]}"),
                      leading: Icon(Icons.email),
                    ),
                    Divider(color: Colors.black12,),
                    ListTile(
                      title: Text("${pat["appUser"]["phone"]}"),
                      leading: Icon(Icons.phone),
                    ),
                    Divider(color: Colors.black12,),
                    ListTile(
                      title: Text("${pat["dateNaissance"]}"),
                      leading: Icon(Icons.calendar_today),
                    ),
                    Divider(color: Colors.black12,),
                    ListTile(
                      title: Text("${pat["sexe"]}"),
                      leading: Icon(Icons.accessibility),
                    ),
                    Divider(color: Colors.black12,),
                    ListTile(
                      title: Text("${pat["adresse"]}"),
                      leading: Icon(Icons.location_on),
                    ),
                    Divider(color: Colors.black12,),
                    if(pat["x"]==1)
                      ListTile(
                        title: Text("Membre"),
                        leading: Icon(Icons.add_circle),
                      ),
                    if(pat["x"]==0)
                      ListTile(
                        title: RaisedButton.icon(
                          textColor: Colors.white,
                          color: Colors.green,
                          onPressed: ()=> displayDialog(context, "Affilier Patient", "Veuillez-vous vraimment affilier ce patient?",pat),
                          icon: Icon(Icons.add, size: 18),
                          label: Text("Ajouter à liste des membres"),
                        ),
                        leading: Icon(Icons.add_circle),
                      ),
                  ],
                ),
              )
            ],
          )
        ]));
  }
}
