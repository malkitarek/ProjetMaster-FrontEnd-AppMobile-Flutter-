import 'file:///E:/projets-Flutter/SoinConnect/lib/pages/home/home-page.dart';
import 'package:SoinConnect/pages/confirm/confirm-traitement.dart';
import 'package:SoinConnect/pages/login/login-traitement.dart';
import 'package:SoinConnect/pages/register/register-page.dart';
import 'package:SoinConnect/services/app-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SoinConnect/utilities/constants.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:jwt_decoder/jwt_decoder.dart';


class ConfirmPage extends StatefulWidget {
  var userId;
  ConfirmPage(this.userId);
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}


class _ConfirmPageState extends State<ConfirmPage> {
  final TextEditingController codeController = TextEditingController();
  var id;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id=widget.userId;

  }

  Widget _buildCodeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'confirmation code',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: codeController,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.code,
                color: Colors.white,
              ),
              hintText: 'Enter your Code',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildConfirmBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async{
          await ConfirmTraitement().onConfirm(_formKey,codeController,id,context);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'CONFIRM',
          style: TextStyle(
            color: Color(0xfff33155),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppService().getInversGuard(page());
  }
  Widget page(){
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFf33f19),
                      Color(0xFFf33f19),
                      Color(0xFFf33155),
                      Color(0xFFf33155),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage("./images/logo.png"),
                        backgroundColor: Colors.red,
                        radius: 50,
                      ),
                      Form(
                          key: _formKey,
                          child:
                          Column(children: [
                            SizedBox(height: 30.0),
                            _buildCodeTF(),
                          ],)),

                      _buildConfirmBtn(),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
