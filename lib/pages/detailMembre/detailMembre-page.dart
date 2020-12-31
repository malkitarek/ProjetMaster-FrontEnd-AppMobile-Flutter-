import 'package:SoinConnect/pages/detailMembre/detailMemTraitement.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';

class DetailMemPage extends StatefulWidget {
  var patient;
  DetailMemPage(this.patient);
  @override
  _DetailMemPageState createState() => _DetailMemPageState();
}

class _DetailMemPageState extends State<DetailMemPage> {
  var pat;
  var medecin;
  List<Item> items;
  List<dynamic> medsTraitant;
  List<dynamic> cons;
  List<dynamic> chanels;
  List<dynamic> filteredList = List();
  @override
  void initState() {
      //TODO: implement initState
      super.initState();
      pat = widget.patient;

      DetailMemTraitement().getMedsTraitants(pat["id"]).then((value) {
        setState(() {
          medsTraitant = DetailMemTraitement.medecinsTraitants;
        });
      });
      DetailMemTraitement().getChanels(pat["id"]).then((value) {
        setState(() {
          chanels = DetailMemTraitement.chanels;
        });
      });
      DetailMemTraitement().getCons(pat["id"]).then((value) {
        setState(() {
          medecin=DetailMemTraitement.user;
          cons=DetailMemTraitement.consultations;

          filteredList=cons;
          items=DetailMemTraitement().getItemsStepeer(pat, medecin,cons, medsTraitant, filteredList, chanels,context);
        });
      });

  }

  @override
  Widget build(BuildContext context) {
    return AppService().getGuard(page());
  }

  Widget page() {
    return Scaffold(
        appBar: AppBar(
          title: Text("Détail Membre"),
          backgroundColor: ColorBar,
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: (items==null)?Center(child: CircularProgressIndicator(),)
          :ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionPanelList(
                    expansionCallback: (int item, bool isExpanded) {
                      setState(() {
                        items[index].isExpanded = !items[index].isExpanded;
                        items.forEach((element) {
                          if (element != items[index])
                            element.isExpanded = false;
                        });
                      });
                    },
                    children: [

                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  items[index].textHeader,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                items[index].iconHeader
                              ],
                            ),
                          );
                        },
                        body: items[index].body,
                        isExpanded: items[index].isExpanded,
                      )
                    ]);
              }),
        ));
  }
}

class Item {
  bool isExpanded;
  String textHeader;
  Widget iconHeader;
  Widget body;
  Item({this.isExpanded: false, this.textHeader, this.iconHeader, this.body});
}
