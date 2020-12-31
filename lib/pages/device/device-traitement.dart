import 'dart:convert';

import 'package:SoinConnect/pages/device/device-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DeviceTraitement{
  static List<dynamic> devices;
  static List<dynamic> patients;

  /******************************************dailog supprimer consultation ****************************************************/

  void displayDialog(context, title, text,device) => showDialog(
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
                  await AppService().deleteDevice(device["id"], device["patient"]['id']);
                  Navigator.pop(context,false);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DevicePage()));
                }),
            RaisedButton(
                child: Text("Cancel"),
                onPressed: (){Navigator.pop(context,false);}),

          ],
        ),
  );
  void showModalCreateDevice(text,device, context) {
    var form = FormGroup({
      'id': FormControl(value: (device != null) ? device['id'] : ''),
      'nom': FormControl(value: (device != null) ? device['nom'] : '', validators: [Validators.required]),
      'description': FormControl(value: (device != null) ? device['description'] : '', validators: [Validators.required]),
      'patientId': FormControl(value: (device != null) ? device['patient']['id'] : null, validators: [Validators.required]),
    });
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
                            formGroup: form,
                            child: Column(children: <Widget>[
                              ReactiveTextField(
                                  formControlName: 'nom',
                                  decoration:
                                  InputDecoration(labelText: "Nom device")),

                              ReactiveTextField(
                                  formControlName: 'description',
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(labelText: "Description")
                              ),
                              ReactiveDropdownField<int>(
                                formControlName: 'patientId',
                                items: [
                                  ...patients.map((e) {
                                    return DropdownMenuItem(
                                      value: e["id"],
                                      child: Text(e["nom"]),
                                    );
                                  })
                                ],
                                decoration: InputDecoration(labelText: "Patient"),
                              ),
                              ReactiveFormConsumer(
                                builder: (context, form, child) {
                                  return RaisedButton(
                                    color: Colors.green,
                                    child: Text("Enregistrer"),
                                    onPressed: form.valid ? () async{
                                      await AppService().saveDevice(form.value);
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DevicePage()));
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


  Future getDevices() async{
    await AppService().getDevices().then((response){
      devices=json.decode(utf8.decode(response.bodyBytes));
    });
    await AppService().getPatients().then((response){
      patients=json.decode(utf8.decode(response.bodyBytes));
    });
  }
}
