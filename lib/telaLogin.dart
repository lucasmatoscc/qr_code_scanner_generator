import 'package:flutter/material.dart';
import 'package:qr_code_scanner_generator/home_screen.dart';
import 'package:qr_code_scanner_generator/styles.dart';
import 'package:qr_code_scanner_generator/scan.dart';
import 'package:qr_code_scanner_generator/usuario.dart';
import 'package:qr_code_scanner_generator/masterPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaLogin extends StatefulWidget {
  static String routeName = "/telalogin";
  TelaLogin({Key key}) : super(key: key);

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

enum LoginType { USER_PASS, USER_CREATE }

class _TelaLoginState extends State<TelaLogin> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _usuario = '38949814587';
  String _senha = '38949814587';

  @override
  Widget build (BuildContext context) {
    return MasterPage(caminhoImagem: 'assets/images/logoTopMenu.png',
      corBackground: whiteColour,
      componentes: Container(child: new Form(
        key: _formKey, autovalidate: _autoValidate, child: formUI(),),),);

    //return Scaffold(body: SingleChildScrollView(child:  formUI(),),);
  }

  Widget formUI () {
    return new Column(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 40.0),
          decoration: new BoxDecoration(color: whiteColour),
          child: new Center(child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[ new Expanded(child: TextFormField(
              style: new TextStyle(color: Colors.white, height: 1.0),
              validator: (valor) => valor.isEmpty
                  ? 'Por favor insira seu usuário'
                  : null,
              onSaved: (valor) => _usuario = valor,
              obscureText: false,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, color: Colors.white,),
                border: InputBorder.none,
                filled: true,
                fillColor: mySecondColour,
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'Usuário',
                hintStyle: TextStyle(color: Colors.white),),),),
            ],),),),
        new Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0),
          decoration: new BoxDecoration(color: whiteColour),
          child: new Center(child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[ new Expanded(child: TextFormField(
              style: new TextStyle(color: Colors.white, height: 1.0),
              validator: (senha) =>
              senha.isEmpty
                  ? 'Por favor insira sua senha'
                  : null,
              onSaved: (senha) => _senha = senha,
              obscureText: true,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key, color: Colors.white,),
                border: InputBorder.none,
                filled: true,
                fillColor: mySecondColour,
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'Senha',
                hintStyle: TextStyle(color: Colors.white),),),),
            ],),),),
        new Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
          decoration: new BoxDecoration(color: whiteColour),
          child: new Center(child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[ new Expanded(child: new RaisedButton(
                child: const Text('Login', textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white, height: 1.4, fontSize: 22,)),
                color: ButtonInicio,
                padding: const EdgeInsets.all(10.0),
                elevation: 4.0,
                splashColor: Colors.white,
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => ScanScreen()),);
                  validateAndSubmit(LoginType.USER_PASS);
                },),),
              ]),),),
        new Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 5.0),
          decoration: new BoxDecoration(color: whiteColour),
          child: new Center(child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[ new Expanded(child: new RaisedButton(
                child: const Text('Sing Up', textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white, height: 1.4, fontSize: 22,)),
                color: ButtonInicio,
                padding: const EdgeInsets.all(10.0),
                elevation: 4.0,
                splashColor: Colors.white,
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => ScanScreen()),);
                  validateAndSubmit(LoginType.USER_CREATE);
                },),),
              ]),),),
        new Container(margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          decoration: new BoxDecoration(color: whiteColour),
          child: new Center(child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //new Image.asset("assets/images/logoGrupoFasitecBranco.png",width: 250.0),
            ],),),),
      ],);
  }

  bool validateAndSave () {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  showMessage(String text, String content) {
    var alert = new AlertDialog(
      title: new Text(text), content: new Text(content),);
    showDialog(context: context, builder: (BuildContext context) {
      // return object of type Dialog
      return alert;
    },);
  }


  void saveUser (Usuario user) {
    saveUserPreference(user).then((bool committed) {
      Navigator.of(context).pushNamed(ScanScreen.routeName);
    });
  }


  Future<Null> validateAndSubmit (LoginType loginType) async {
    if (validateAndSave()) {
      try {
        switch (loginType) {
          case LoginType.USER_PASS:
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _usuario, password: _senha);
        print('Sucesso: ${user.uid} ${user.email}');
        if (user.isEmailVerified) {
          saveUser(Usuario(email: _usuario));

          Navigator.push(
            context, MaterialPageRoute(builder: (context) => ScanScreen()),);
        } else {
          showMessage("Erro",
              "Link de validação foi enviado para o seu email. Por favor fazer login após validar.");
        }
        break;
          case LoginType.USER_CREATE:
          FirebaseUser user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: _usuario, password: _senha);
          user.sendEmailVerification();
          showMessage("Erro",
              "Link de validação foi enviado para o seu email. Por favor fazer login após validar.");
        break;
      }
      } catch (e) {
        print('Error: $e');
        if (e.toString().contains(
            "The email address is badly formatted.")) {
          showMessage(
              "Erro", "O endereço de email está em formato incorreto.");
        } else if (e.toString().contains(
            "There is no user record corresponding to this identifier. The user may have been deleted.")) {
          showMessage("Erro", "Não há registro desse usuário.");
        } else {
          showMessage("Erro", "Por favor verificar email e/ou senha");
        }
        return null;
      }
    }
  }


  Future<String> getUserFromSharedPreferences () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("usuario");
  }

  Future<bool> saveUserPreference (Usuario user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonUser = usuarioToJson(user);

    prefs.setString("usuario", jsonUser);
    print(await getUserFromSharedPreferences());

    return true;
  }

}