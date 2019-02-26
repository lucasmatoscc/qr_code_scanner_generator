import 'dart:async';
import 'package:qr_code_scanner_generator/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_code_scanner_generator/usuario.dart';
import 'package:qr_code_scanner_generator/masterPage.dart';
import 'package:url_launcher/url_launcher.dart';



class ScanScreen extends StatefulWidget {
  static String routeName = "/telainicial";
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {

  String barcode = "";
  List<Container> listaContainer  = new List<Container>();

  Usuario _user;

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      String user = (prefs.getString('usuario')??'');
      print("_loadUser: " + user);
      _user = usuarioFromJson(user);

    });
  }

  @override
  initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return MasterPage(caminhoImagem: 'assets/images/logoTopMenu.png',
      corBackground: whiteColour,
      componentes: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: RaisedButton(
                color: tableHeaderColour,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scan,
                child: const Text('START CAMERA SCAN')
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child:
            Container(child: Text(barcode) ),),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: RaisedButton(
                color: tableHeaderColour,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: historico,
                child: const Text('VER HISTÓRICO')
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child:
            Container(child:  Column(children:  listaContainer) ),)
            //Text(listaHistorico, textAlign: TextAlign.center,),

          ,
        ],
      ),);
  }

  showMessage(String text, String content) {
    var alert = new AlertDialog(
      title: new Text(text), content: new Text(content),);
    showDialog(context: context, builder: (BuildContext context) {
      // return object of type Dialog
      return alert;
    },);
  }

  Future historico() async {
    var leiturasReference = FirebaseDatabase.instance.reference().child("leituras");

    Query whereEx = leiturasReference.orderByChild("email").equalTo(_user.email);

    List<Container> listaDataCell = new List<Container>();

    whereEx.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        print(values);
        if(values["link"] != null){

          var dataCell = Container(
            margin: EdgeInsets.all(15.0), child: InkWell(
            child: Text(values["link"],style: new TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
            onTap: () async {
              final url =  values["link"];
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                showMessage("Erro",
                    'Não pode abrir $url');
              }
            },
          ),);
          listaDataCell.add(dataCell);
        }
        print(values["link"]);
      });
    });
    setState(() => this.listaContainer = listaDataCell);
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();

      var leiturasReference = FirebaseDatabase.instance.reference().child("leituras");

      leiturasReference.push().set({'email': _user.email,'data': DateTime.now().toIso8601String(), 'link': barcode}
      ).then((_) {

      });

      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

}