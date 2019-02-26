import 'package:flutter/material.dart';

class MasterPage extends StatefulWidget {
  MasterPage({Key key, this.caminhoImagem,this.corBackground,this.componentes}) : super(key: key);

  final String caminhoImagem;
  final MaterialColor corBackground;
  final Widget componentes;

  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage>{
  @override
  Widget build(BuildContext context) {

    return

      Scaffold(
      backgroundColor:  widget.corBackground,
      body:
        SingleChildScrollView(
        child:
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
            ),
            //margin: const EdgeInsets.only(bottom: 40.0),
            alignment: Alignment.topLeft,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage(widget.caminhoImagem),
                fit: BoxFit.fill,
              ),
            ),
          ),
          widget.componentes
        ],
      ),
        ),
      //),
    );
  }
}