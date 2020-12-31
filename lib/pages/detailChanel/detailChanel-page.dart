import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/detailChanel/detailChanel-taritement.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
class DetailChanelPage extends StatefulWidget {
  var idPat;
  var idChanel;
  var nomFeild;
  DetailChanelPage(this.idPat,this.idChanel,this.nomFeild);
  @override
  _DetailChanelPageState createState() => _DetailChanelPageState();
}

class _DetailChanelPageState extends State<DetailChanelPage> {
  final format = DateFormat("yyyy-MM-dd HH");
  var date=DateFormat('yyyy-MM-dd').format(DateTime.now());
  var heure=TimeOfDay.fromDateTime(DateTime.now()).hour;
  TextEditingController textEditingController=TextEditingController();
  //textEditingController.text="ff";
  List<dynamic> data;
  List<dynamic> lastData;
  List<dynamic> feilds;
  var values;
  List<charts.Series<MyRow,DateTime>> seriesList;
  Stream<dynamic> stream=streamControllerDonnees.stream;
  var donneesStream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController.text="${DateFormat('yyyy-MM-dd HH').format(DateTimeField.combine(DateTime.now(),TimeOfDay.fromDateTime(DateTime.now())))}";
    stream.listen((event) {
      if(mounted){
        setState(() {
          donneesStream=event;
          if (donneesStream['feild']['chanel']["patientId"]==widget.idPat && donneesStream['feild']['nom']==widget.nomFeild) {
            data.add(donneesStream);
            (data!=null)?values =data.map((d) => MyRow(DateTime.parse(d['time']), d['valeur'].toInt())).toList():[];
            seriesList=[
              new charts.Series<MyRow, DateTime>(
                id: 'Cost',
                colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                domainFn: (MyRow row, _) => row.timeStamp,
                measureFn: (MyRow row, _) => row.cost,
                data:(values!=null)?values:[],
              )
            ];
          }
        });
      }
    });
    DetailChanelTraitement().getLastMesures(widget.idPat, widget.idChanel, widget.nomFeild).then((value) {
       setState(() {
         lastData=DetailChanelTraitement.lastData;
       });
    });
    DetailChanelTraitement().getFeilds(widget.idPat, widget.idChanel).then((value) {
      setState(() {
        feilds=DetailChanelTraitement.feilds;
      });
    });
    DetailChanelTraitement().getDonnees(widget.idPat, widget.idChanel, widget.nomFeild,date,heure).then((value) {
      setState(() {
        data=DetailChanelTraitement.data;
        (data!=null)?values =data.map((d) => MyRow(DateTime.parse(d['time']), d['valeur'].toInt())).toList():[];
          seriesList=[
            new charts.Series<MyRow, DateTime>(
              id: 'Cost',
              colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
              domainFn: (MyRow row, _) => row.timeStamp,
              measureFn: (MyRow row, _) => row.cost,
              data:(values!=null)?values:[],
            )
          ];

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text('Détail chanel ${widget.nomFeild}'),
        backgroundColor: ColorBar,),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:20),
          child: Column(
              children: <Widget>[
                DateTimeField(
                  format: format,
                  controller: textEditingController,
                  decoration: new InputDecoration(
                    icon:  Icon(Icons.calendar_today,color: ColorBar,),
                    labelText: "Enter Date and Hour...",
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  initialValue: DateTime.now(),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      await DetailChanelTraitement().getDonnees(widget.idPat, widget.idChanel, widget.nomFeild,DateFormat('yyyy-MM-dd').format(date),time.hour).then((value) {
                       //print("${time.hour}");
                        setState(() {
                          data=DetailChanelTraitement.data;
                          (data!=null)?values =data.map((d) => MyRow(DateTime.parse(d['time']), d['valeur'].toInt())).toList():[];
                          seriesList=[
                            new charts.Series<MyRow, DateTime>(
                              id: 'Cost',
                              colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                              domainFn: (MyRow row, _) => row.timeStamp,
                              measureFn: (MyRow row, _) => row.cost,
                              data: (values!=null)?values:[],
                            )
                          ];
                        });
                      });

                      return DateTimeField.combine(date, time);
                    } else {
                      return DateTime.now();
                    }
                  },
                ),
                Container(
                    width: double.infinity,
                    height: 250,
                    child: charts.TimeSeriesChart(
                      (data!=null)?seriesList:[new charts.Series<MyRow, DateTime>(
                        id: 'Cost',
                        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                        domainFn: (MyRow row, _) => row.timeStamp,
                        measureFn: (MyRow row, _) => row.cost,
                        data: [],
                      )],
                      animate: false,
                      defaultRenderer: new charts.LineRendererConfig(includePoints: true),

                      // Sets up a currency formatter for the measure axis.
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: widthScree(context)*0.95,
                        height: 50,
                        child: Card(
                          color: ColorBar,
                          child: Center(child:
                                   Text('Derniéres mesures',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
                        ),
                      ),
                      Container(
                        width: widthScree(context)*0.95,
                        height: 140,
                        child:(lastData==null)?Text('Aucune donnée'):ListView.builder(
                            itemCount: lastData.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                  onTap: () async{

                                    var datee=DateFormat('yyyy-MM-dd').format(DateTime.parse(lastData[index]['time']));
                                    var heuree=DateFormat('HH').format(DateTime.parse((lastData[index]['time'])).toLocal());
                                    var editDateCntr=DateFormat('yyyy-MM-dd HH').format(DateTimeField.combine(DateTime.parse(lastData[index]['time']).toLocal(),TimeOfDay.fromDateTime(DateTime.parse(lastData[index]['time']).toLocal())));
                                    textEditingController.text="${editDateCntr}";
                                    await DetailChanelTraitement().getDonnees(widget.idPat, widget.idChanel, widget.nomFeild,datee,heuree).then((value) {
                                      setState(() {
                                        data=DetailChanelTraitement.data;
                                        (data!=null)?values =data.map((d) => MyRow(DateTime.parse(d['time']), d['valeur'].toInt())).toList():[];
                                        seriesList=[
                                          new charts.Series<MyRow, DateTime>(
                                            id: 'Cost',
                                            colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                                            domainFn: (MyRow row, _) => row.timeStamp,
                                            measureFn: (MyRow row, _) => row.cost,
                                            data: (values!=null)?values:[],
                                          )
                                        ];
                                      });
                                    });
                                      },
                                  child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:Text('${DateFormat("MMM d, y, h a").format(DateTime.parse(lastData[index]['time']).toLocal())}')
                              ),
                              )
                              );
                            }),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: widthScree(context)*0.95,
                        height: 50,
                        child: Card(
                          color: ColorBar,
                          child: Center(child:
                          Text('Feilds',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
                        ),
                      ),
                      Container(
                        width: widthScree(context)*0.95,
                        height: 140,
                        child:(feilds==null)?Text('Aucune donnée'):ListView.builder(
                            itemCount: feilds.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                  onTap: () async{
                                    var datee=DateFormat('yyyy-MM-dd').format(DateTime.parse(textEditingController.value.text));
                                    var heuree=DateFormat('HH').format(DateTime.parse(textEditingController.value.text));
                                    print('here=$heuree');
                                    await DetailChanelTraitement().getDonnees(widget.idPat, widget.idChanel, feilds[index]["nom"],datee,heuree).then((value) {
                                      setState(() {
                                        data=DetailChanelTraitement.data;
                                        (data!=null)?values =data.map((d) => MyRow(DateTime.parse(d['time']), d['valeur'].toInt())).toList():[];
                                        seriesList=[
                                          new charts.Series<MyRow, DateTime>(
                                            id: 'Cost',
                                            colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                                            domainFn: (MyRow row, _) => row.timeStamp,
                                            measureFn: (MyRow row, _) => row.cost,
                                            data: (values!=null)?values:[],
                                          )
                                        ];
                                      });
                                    });
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:Text('${feilds[index]['nom']}')
                                    ),
                                  )
                              );
                            }),
                      )
                    ],
                  ),
                )

              ]),
        ),
      )
    );
  }
}
class MyRow {
  final DateTime timeStamp;
  final int cost;
  MyRow(this.timeStamp, this.cost);
}
