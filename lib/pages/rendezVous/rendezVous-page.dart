import 'dart:convert';

import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/navbar/bar.dart';
import 'package:SoinConnect/pages/navbar/drawer.dart';
import 'package:SoinConnect/pages/rendezVous/rendezVous-traitement.dart';
import 'package:SoinConnect/services/app-service.dart';

import 'package:SoinConnect/utilities/constants.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
class RendezVousPage extends StatefulWidget {
  @override
  _RendezVousPageState createState() => _RendezVousPageState();
}

class _RendezVousPageState extends State<RendezVousPage> {
  Stream<dynamic> stream=streamController.stream;
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> patients;
  List<dynamic> notificationsStream;
  Stream<dynamic> streamAllMsg=streamControllerAllMsg.stream;
  List<dynamic> msgStream;
  List<dynamic> rendezVous;
  List<dynamic> _selectedEvents=[];
  var medecin;
  Map<DateTime, List<S>> groupBy<S, DateTime>(Iterable<S> values, DateTime Function(S) key) {
    var map = <DateTime, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController=CalendarController();
    _events = {};
    RendezVousTraitement().getRendez().then((value)  {
      setState(() {
        rendezVous=RendezVousTraitement.rendezVous;
        _events=groupBy(rendezVous, (rendez) => DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(rendez["dateDebut"]))));
        _selectedEvents = _events[DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()))] ?? [];
      });
    });
    RendezVousTraitement().getMems().then((value)  {
      setState(() {
         patients=RendezVousTraitement.membres;
         medecin=RendezVousTraitement.user;
      });
    });
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

  }
  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _selectedEvents = events;
    });
  }

  /******************************************************** showModal "Antecedants, maladies, habitude" ********************************/
 void showModal(rendez,selectedDate) {
    var form=FormGroup({
      'id':FormControl(value: (rendez!=null)?rendez['id']:''),
      'titre': FormControl(value: (rendez!=null)?rendez['titre']:'',validators: [Validators.required]),
      'description': FormControl(value: (rendez!=null)?rendez['description']:'',validators: [Validators.required]),
      'dateDebut': FormControl(value:(selectedDate!=null)?selectedDate:'',validators: [Validators.required]),
      'dateFin': FormControl(value: (rendez!=null)?rendez['dateFin']:'',validators: [Validators.required]),
      'idMedecin':FormControl(value: (medecin!=null)?medecin['id']:''),
      'idPatient': FormControl(value: (rendez!=null)?rendez['idPatient']:null,validators: [Validators.required]),
      'validation':FormControl(value: (rendez!=null)?rendez['validation']:'')
    });
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top:25),
            child: Scaffold(

              appBar: AppBar(
                backgroundColor: ColorBar,
                leading: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  (rendez==null)?Text(""):IconButton(
                      color: Colors.white,
                      iconSize: 36,
                      icon: Icon(Icons.delete),
                      onPressed: () async{
                        await RendezVousTraitement().deleteRendez(rendez['id'], context);
                      }),
                  IconButton(
                      icon: Icon(Icons.done_outline),
                      iconSize: 36,
                      color: Colors.white,
                      onPressed: () async {
                        if(form.valid){
                          await RendezVousTraitement().saveRendez(form, context);
                        }else{
                          form.markAllAsTouched();
                        }
                      })

                ],
              ),
              body: ListView(
                padding:  EdgeInsets.all(16.0),
                children: <Widget>[
                  //add event form
                  ReactiveForm(
                    formGroup: form,
                    child: Column(
                      children: [
                        ReactiveTextField(
                          formControlName: "titre",
                          //initialValue: widget.event?.title,
                          decoration: InputDecoration(labelText: "Titre"),
                        ),
                        ReactiveTextField(
                         formControlName: "description",
                         // initialValue: widget.event?.description,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(labelText: "Description"),
                        ),
                        ReactiveTextField(
                          formControlName: 'dateDebut',
                          decoration: InputDecoration(labelText: "Date début"),
                          onTap: () async{
                              DateTime date = DateTime(1900);
                              FocusScope.of(context).requestFocus(new FocusNode());
                              date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate:  DateTime.parse(selectedDate),
                                  lastDate: DateTime(2100));
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime( DateTime.parse(selectedDate)),
                              );
                              if (date != null) {
                                form.control("dateDebut").value=DateTimeField.combine(date, time).toIso8601String();
                              } else {
                                form.control("dateDebut").value=DateTimeField.combine(DateTime.now(), time).toIso8601String();

                              }
                            }
                        ),
                        ReactiveTextField(
                            formControlName: 'dateFin',
                            decoration: InputDecoration(labelText: "Date fin"),
                            onTap: () async{
                              DateTime date = DateTime(1900);
                              FocusScope.of(context).requestFocus(new FocusNode());
                              date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: (rendez!=null)?DateTime.parse(rendez["dateFin"]):DateTime.parse(selectedDate),
                                  lastDate: DateTime(2100));
                              final time = await showTimePicker(
                                context: context,
                                initialTime: (rendez!=null)?TimeOfDay.fromDateTime(DateTime.parse(rendez["dateFin"])):TimeOfDay.fromDateTime(DateTime.parse(selectedDate)),
                              );
                              if (date != null) {
                                form.control("dateFin").value=DateTimeField.combine(date, time).toIso8601String();
                              } else {
                                form.control("dateFin").value=DateTimeField.combine(DateTime.now(), time).toIso8601String();

                              }
                            }
                        ),
                        ReactiveDropdownField<int>(
                          formControlName: 'idPatient',
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
                        (rendez==null)?Text(""):ReactiveTextField(
                          formControlName: 'validation',
                        )


                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  });
  }
  @override
  Widget build(BuildContext context) {
    return AppService().getGuard(page());
  }

  Widget page(){
    return Scaffold(
      appBar: BarWidget().bar(notificationsStream,msgStream),
      drawer: DrawerWidget(),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.all(8),
              child:  TableCalendar(
                calendarController: _calendarController,

                events: _events,
                initialCalendarFormat: CalendarFormat.month,
                onDaySelected: _onDaySelected,
                weekendDays: [5,6],
                calendarStyle: CalendarStyle(
                  selectedColor: ColorBar,
                  todayColor: Colors.red[200],
                  markersColor: Colors.brown[700],

                ),
                headerStyle: HeaderStyle(
                   formatButtonVisible: false,
                    decoration: BoxDecoration(color: ColorBar),
                    headerMargin: EdgeInsets.only(bottom: 8),
                    titleTextStyle: TextStyle(color: Colors.white),
                    centerHeaderTitle: true,
                    leftChevronIcon: Icon(Icons.chevron_left,color: Colors.white,),
                    rightChevronIcon: Icon(Icons.chevron_right,color: Colors.white,)
                ),
              ),
            ),
            ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: _selectedEvents
                    .map((event) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.8),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text("${event['titre']}"),
                    onTap: () => showModal(event, event['dateDebut']),
                  ),
                )).toList()
            )

          ],
        ),
      ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: ColorBar,
          onPressed: ()=>showModal(null,_calendarController.selectedDay.toString()),
        )
    );


  }
}
