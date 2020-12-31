import 'dart:convert';
import 'package:SoinConnect/pages/detailChanel/detailChanel-page.dart';
import 'package:SoinConnect/pages/detailMembre/detailMembre-page.dart';
import 'package:SoinConnect/pages/membre/membre-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DetailMemTraitement {
  static var medecinsTraitants;
  static var consultations;
  static var chanels;
  static var user;
  List<String> _values = new List();
  List<bool> _selected = new List();
 /******************************************dailog supprimer consultation ****************************************************/

  void displayDialog(context, title, text,cons) => showDialog(
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
                  await AppService().deleteConsultations(cons);
                  Navigator.pop(context,false);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MembrePage()));
                }),
            RaisedButton(
                child: Text("Cancel"),
                onPressed: (){Navigator.pop(context,false);}),

          ],
        ),
  );

/************************************************** chips contenu taritement *************************************************/
  Widget buildChips(formCons,setState) {
    List<Widget> chips = new List();
    for (int i = 0; i < _values.length; i++) {
      InputChip actionChip = InputChip(
        selected: _selected[i],
        label: Text(_values[i]),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onPressed: () {
          setState(() {
          _selected[i] = !_selected[i];
          });
        },
        onDeleted: () {
          _values.removeAt(i);
          _selected.removeAt(i);
          (formCons.control("traitements") as FormArray).removeAt(i);

          setState(() {
          _values = _values;
          _selected = _selected;

           });
        },
      );

      chips.add(actionChip);
    }

    return Wrap(
      verticalDirection: VerticalDirection.down,
      children: chips,
    );
  }

 /******************************************************** showModal "Antecedants, maladies, habitude" ********************************/
  void showModal(text, content, context) {
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
                          return Column(
                            children: [
                              ListTile(
                                title: Text(content[index]),
                              ),
                              Divider(
                                color: Colors.black12,
                              ),
                            ],
                          );
                        }),
              ),
            ),
          );
        });
  }
/********************************************** showModal Medecins traitants *************************************************/
  
  void showModalMedsTrai(text, content, context) {
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
  /********************************************** showModal Detail consultation *************************************************/

  void showModalDetailCons(text, cons, context) {
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
                child: (cons == null)
                    ? Center(
                  child: Text("Aucun"),
                )
                    : ListView(
                        children: [
                          ListTile(
                            title: Text('Rapport: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            subtitle: Html(
                              data:""" ${cons['rapporte']} """,
                            ) ,
                          ),
                          ListTile(
                            title:Row(
                              children: [
                                Text('Traitement: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                Text("${cons["traitement"]["nom"]}")
                              ],
                            ),
                            subtitle: Container(
                              height: 300,
                              child: ListView.builder(
                                  itemCount: cons["traitement"]["contenu"].length,
                                  itemBuilder: (BuildContext context,int index){

                                    return ListTile(
                                      leading: Icon(Icons.arrow_right),
                                      title: Text("${cons["traitement"]["contenu"][index]}"),
                                    );
                                  }),
                            ),

                          )
                        ],
                )
              ),
            ),
          );
        });
  }




/*************************************** showModalCreateCons*********************************************************/

  void showModalCreateCons(text, patient, medecin, cons, context) {
    _values=[];
    _selected=[];
    var formCons = FormGroup({
      'idCons': FormControl(value: (cons != null) ? cons['id'] : ''),
      'nomTraitement': FormControl(
          value: (cons != null) ? cons['traitement']['nom'] : '',
          validators: [Validators.required]),
      'traitements': FormArray([]),
      'rapporte': FormControl(
          value: (cons != null) ? cons['rapporte'] : '',
          validators: [Validators.required]),
      'traitement': FormControl(),
      'medecin': FormControl(value: medecin),
      'patient': FormControl(value: patient),
    });
   // print("${cons[0]}");
    if(cons!=null){
      (cons["traitement"]["contenu"]).forEach((value){
        (formCons.control("traitements") as FormArray).add(
          FormControl<String>(value: value),
        );
        _values.add(value);
      });
      for(int i=0;i<=_values.length;i++){_selected.add(true);}
    }
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: ColorBar,
                    title: Text(text),
                  ),
                  body:  ListView(
                    padding: EdgeInsets.all(10),
                    children: [
                      ReactiveForm(
                          formGroup: formCons,
                          child: Column(children: <Widget>[
                            ReactiveTextField(
                                formControlName: 'nomTraitement',
                                decoration:
                                InputDecoration(labelText: "Nom traitement")),
                            SizedBox(
                              height: 60,
                            ),
                            Container(
                              child: buildChips(formCons,setState),
                            ),
                            ReactiveTextField(
                                onSubmitted: () {
                                  _values.add(formCons.control("traitement").value);
                                  _selected.add(true);
                                  (formCons.control("traitements") as FormArray)
                                      .add(
                                    FormControl<String>(
                                        value:
                                        formCons.control("traitement").value),
                                  );
                                  // print("eeeeeeeeeeeeee=${formDossier.value}");
                                  formCons.control("traitement").reset();
                                  setState(() {
                                    _values = _values;
                                    _selected = _selected;
                                  });
                                },
                                formControlName: "traitement",
                                decoration:
                                InputDecoration(labelText: "traitements")),
                            ReactiveTextField(
                                formControlName: 'rapporte',
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(labelText: "rapport")),
                            ReactiveFormConsumer(
                              builder: (context, form, child) {
                                return RaisedButton(
                                  color: Colors.green,
                                  child: Text("Enregistrer"),
                                  onPressed: formCons.valid ? () async{
                                    await AppService().saveConsultation(formCons.value);
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailMemPage(patient)));
                                  } : null,
                                );
                              },
                            ),
                          ]))
                    ],
                  ),
                  ),
            );
          });
        });
  }

  List<dynamic> getItemsStepeer(
      pat, medecin, cons, medsTraitant, filteredList, chanels,context) {
    List<Item> items = [
      /******************************** Les informations personnel du patient***************************************************************/
      Item(
          textHeader: "Les informations personnel du patient",
          iconHeader: Icon(Icons.account_circle),
          body: Stack(children: <Widget>[
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
                        title: Text("${pat["appUser"]["email"]}"),
                        leading: Icon(Icons.email),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        title: Text("${pat["appUser"]["phone"]}"),
                        leading: Icon(Icons.phone),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        title: Text("${pat["dateNaissance"]}"),
                        leading: Icon(Icons.calendar_today),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        title: Text("${pat["sexe"]}"),
                        leading: Icon(Icons.accessibility),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        title: Text("${pat["adresse"]}"),
                        leading: Icon(Icons.location_on),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ])),

      /********************************** Les informations du dossier médical ***********************************************/
      Item(
          textHeader: "Les informations du dossier médical",
          iconHeader: Icon(Icons.markunread_mailbox),
          body: Stack(children: <Widget>[
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
                          image: AssetImage('./images/dossierMedical.jpg'),
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
                        title: Text(
                          "Poid: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("${pat["dossierMedecal"]["poid"]}"),
                        leading: Icon(Icons.fitness_center),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        title: Text(
                          "taille: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("${pat["dossierMedecal"]["taille"]}"),
                        leading: Icon(Icons.accessibility),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        title: Text(
                          "Date création: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text("${pat["dossierMedecal"]["dateCreation"]}"),
                        leading: Icon(Icons.calendar_today),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        title: Text(
                          "Date modification: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            "${pat["dossierMedecal"]['dateModification']}"),
                        leading: Icon(Icons.calendar_today),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        onTap: () => showModal(
                            "Antécédents familiaux",
                            pat["dossierMedecal"]["antecedentsFamiliaux"],
                            context),
                        title: Text(
                          "Antécédents familiaux",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(Icons.favorite),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        onTap: () => showModal("Maladies",
                            pat["dossierMedecal"]["maladies"], context),
                        title: Text(
                          "Maladies",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(Icons.coronavirus),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        onTap: () => showModal(
                            "Habitudes toxiques",
                            pat["dossierMedecal"]["habitudesToxiques"],
                            context),
                        title: Text(
                          "Habitudes toxiques",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(Icons.sick),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      ListTile(
                        onTap: () => showModalMedsTrai(
                            "Médecins traitants", medsTraitant, context),
                        title: Text(
                          "Médecins traitants",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(Icons.group),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ])),

      /******************************** La liste des consultations ****************************************************/
      Item(
          textHeader: "La liste des consultations",
          iconHeader: Icon(Icons.list_alt),
          body: Stack(children: <Widget>[
            Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                Widget>[
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
                        image: AssetImage('./images/consultation.jpg'),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Center(
                    child: RaisedButton.icon(
                        color: Colors.green,
                        textColor: Colors.white,
                        icon: Icon(Icons.add),
                        label: Text('Ajouter'),
                        onPressed: () {
                          showModalCreateCons("Ajouter Consultation", pat,
                              medecin, null, context);
                        }),
                  ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: ListView.builder(
                        itemCount:
                            (filteredList == null ? 0 : filteredList.length),
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
                                          backgroundImage:
                                              AssetImage("./images/conslt.png"),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Consultation: ${filteredList[index]["id"]}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  "${filteredList[index]["date"]}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          color: Colors.green,
                                          iconSize: 20,
                                          onPressed: ()=>showModalDetailCons("Détail Consultation", filteredList[index], context)
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Colors.blue,
                                          iconSize: 20,
                                          onPressed: ()=>showModalCreateCons("Modifier Consultation", pat, medecin, filteredList[index], context)
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          color: Colors.red,
                                          iconSize: 20,
                                            onPressed: ()=> displayDialog(context, "Supprimer Consultation", "Veuillez-vous vraimment supprimer cette consultation?",filteredList[index]['id'])
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              )
            ])
          ])),

      /********************************* Exploiration des données ***************************************************/
      Item(
          textHeader: "Exploiration des données",
          iconHeader: Icon(Icons.airplay),
          body: Stack(children: <Widget>[
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: ListView.builder(
                        itemCount:
                        (chanels == null ? 0 : chanels.length),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              if(chanels[index]['capteur']['nom']=="temprature")
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailChanelPage(pat['id'], chanels[index]['id'], 'temp')));
                              else if(chanels[index]['capteur']['nom']=="ECG")
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailChanelPage(pat['id'], chanels[index]['id'], 'ECG wave')));
                              else if(chanels[index]['capteur']['nom']=="Blood Pressure")
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailChanelPage(pat['id'], chanels[index]['id'], 'diastolic')));
                              else if(chanels[index]['capteur']['nom']=="Spo2")
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailChanelPage(pat['id'], chanels[index]['id'], 'spo2')));

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
                  )

            ])
          ])),

    ];

    return items;
  }

  Future getMedsTraitants(idPat) async {
    await AppService().getMedecinsTraitants(idPat).then((response) {
      medecinsTraitants = json.decode(utf8.decode(response.bodyBytes));
    });
  }

  Future getCons(idPat) async {
    await AppService().getUser().then((response) {
      user = json.decode(response.body);
      // print("user id==${user["id"]}");
    });
    await AppService().getConsultations(idPat, user['id']).then((response) {
      consultations = json.decode(utf8.decode(response.bodyBytes));
    });
  }
  Future getChanels(idPat) async {

    await AppService().getChanels(idPat).then((response) {
      chanels = json.decode(utf8.decode(response.bodyBytes));
    });
  }
}
