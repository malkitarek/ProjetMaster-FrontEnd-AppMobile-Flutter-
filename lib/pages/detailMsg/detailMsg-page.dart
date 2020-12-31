import 'package:SoinConnect/main.dart';
import 'package:SoinConnect/pages/detailMsg/detailMsg-traitement.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DetailMsgPage extends StatefulWidget {
  var mem;
  var userr;
  DetailMsgPage(this.mem, this.userr);
  @override
  _DetailMsgPageState createState() => _DetailMsgPageState();
}

class _DetailMsgPageState extends State<DetailMsgPage> {
  List<dynamic> messages;
  var user;
  FormGroup form;
  Stream<dynamic> stream=streamControllerMessge.stream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    form = FormGroup({
      'contenu': FormControl(validators: [Validators.required]),
      'idPatient': FormControl(value: widget.mem['id']),
      'idMedecin': FormControl(value: widget.userr['id']),
      'fromQui': FormControl(value: widget.userr['appUser']['role'])
    });
    stream.listen((event) {
      if(event[0]['idPatient']==widget.mem['id']){
        if(mounted) {
          setState(() {
            messages=event;
          });
        }

      }
    });
    DetailMsgTraitement().getMessage(widget.mem['id']).then((value) {
      setState(() {
        messages = DetailMsgTraitement.messages;
        user = DetailMsgTraitement.user;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorBar,
          title: Chip(
            label: Text('${widget.mem['nom']} ${widget.mem['prenom']}'),
            avatar: Icon(Icons.account_circle),
          )),
      body: (messages == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(20),
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = messages[messages.length - 1 - index];
                      final bool isMe =
                          message['fromQui'] == user['appUser']['role'];
                      return _chatBubble(message, isMe);
                    },
                  ),
                ),
                _sendMessageArea(),
              ],
            ),
    );
  }

  _chatBubble(message, bool isMe) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: ColorBar,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, //meant to align elements to the left - seems to be working
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['contenu'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(''),
                        Text(
                          DateFormat("dd/MM/yy HH:mm")
                              .format(DateTime.parse(message['created']))
                              .toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.70,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, //meant to align elements to the left - seems to be working
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['contenu'],
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(''),
                        Text(
                          DateFormat("dd/MM/yy HH:mm")
                              .format(DateTime.parse(message['created']))
                              .toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ],
      );
    }
  }

  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            iconSize: 25,
            color: ColorBar,
            onPressed: null,
          ),
          Expanded(
              child: ReactiveForm(
                  formGroup: form,
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: widthScree(context)*0.6,
                          child: ReactiveTextField(
                            formControlName: 'contenu',
                            decoration: InputDecoration.collapsed(
                              hintText: 'Send a message..',
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        Container(
                          width: widthScree(context)*0.2,
                          child: ReactiveFormConsumer(
                            builder: (context, form, child) {
                              return IconButton(
                                color: ColorBar,
                                icon: Icon(Icons.send),
                                onPressed: form.valid ? ()  {
                                  DetailMsgTraitement().sendMessage(form).then((value){
                                    form.control('contenu').reset();
                                  });
                                } : null,
                              );
                            },
                          ),
                        )

                      ],
                    ),
                  )),
        ],
      ),
    );
  }
}
