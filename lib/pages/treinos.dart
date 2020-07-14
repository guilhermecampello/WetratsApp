import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show get;
import 'package:wetrats/layout.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class Treino {
  final String id;
  final String data, treino,serie;
  Treino({
    this.id,
    this.data,
    this.treino,
    this.serie
  });
factory Treino.fromJson(Map<String, dynamic> jsonData) {
  var date = jsonData['data'].split("-");
  var dataf = date[2] + '/' + date[1] + '/' + date[0];
  var treinof = jsonData['treino'].replaceAll("<br>","");
  return Treino(
    id: jsonData['id'],
    data: dataf,
    treino: treinof,
    serie: jsonData['serie_controle']
    //nomefoto: "https://www.wetrats.com.br/common/uploads/treinos/"+jsonData['nome_foto'],
  );
}
}
class CustomListView extends StatelessWidget {
  final List<Treino> treinos;
  CustomListView(this.treinos);
  
  Widget build(context) {
    
    return ListView.builder(
      itemCount: treinos.length,
      itemBuilder: (context, int currentIndex) {
      return createViewItem(treinos[currentIndex], context);
  },
  );
}

Widget createViewItem(Treino treino, BuildContext context) {
  return new ListTile(
    title: new Card(
      elevation: 5.0,
      child: new Container(
        decoration: BoxDecoration(border: Border.all(color: Layout.secondary())),
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            /* Padding(
              child: Image.network(treino.nomefoto),
                padding: EdgeInsets.only(bottom: 8.0),
                ), */
            Row(children: <Widget>[
              Padding(
                child: Text(
                  treino.data,
                  style: new TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                  ),
                  padding: EdgeInsets.all(1.0)),
                  Text(" | "),
                  Expanded(child:Text(
                      treino.serie,
                      style: new TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.left,
                      )),
                      
              ]),
            ],
          ),
        ),
      ),
      onTap: () {
      //We start by creating a Page Route.
      //A MaterialPageRoute is a modal route that replaces the entire
      //screen with a platform-adaptive transition.
        var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
        new Visualizacao(value: treino),
        );
      //A Navigator is a widget that manages a set of child widgets with
      //stack discipline.It allows us navigate pages.
      Navigator.of(context).push(route);
      });
}
}
//Future is n object representing a delayed computation.
Future<List<Treino>> downloadJSON() async {
  final jsonEndpoint = "https://www.wetrats.com.br/app/treinos.php";
  final response = await get(jsonEndpoint);
  if (response.statusCode == 200) {
    List treinos = json.decode(response.body);
    print("sucesso!");
    return treinos.map((treino) => new Treino.fromJson(treino)).toList();
  } else
      throw Exception('Falha na conexão com o servidor');
  }

class Visualizacao extends StatefulWidget {
  final Treino value;
  
  Visualizacao({Key key, this.value}) : super(key: key);
  @override
  _VisualizacaoState createState() => _VisualizacaoState();
  
  }

class _VisualizacaoState extends State<Visualizacao> {
  @override
  
  Widget build(BuildContext context) {
    
    return Layout.getContent(context, new Container(
        child: new Center(
          child: Column(
            children: <Widget>[
              Padding(
                child: new Text('Descrição do treino',style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.only(bottom: 20.0),
              ),
              
              /* Padding(
//`widget` is the current configuration. A State object's configuration
//is the corresponding StatefulWidget instance.
                child: Image.network('${widget.value.nomefoto}'),
                padding: EdgeInsets.all(12.0),
                ), */
                
              Padding(
                child: new Text(
                'Data : ${widget.value.data}',style: new TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                padding: EdgeInsets.all(20.0),
              ),

              Padding(
                child: new Text(
                '${widget.value.treino}',style: new TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.all(20.0),
              ),

              
          ],   ),
        ),
      ),
    );
  }
}

class TreinosPage extends StatelessWidget{
  static String tag = 'treinos-page';

  @override
  Widget build(BuildContext context){
    return 
    Layout.getContent(context, /* Column(children:[
        Row(  
          children:[        
            Icon(Icons.assignment, color: Layout.secondary(), size:46),
            Text("Treinos", style: TextStyle(
              fontSize: 36, 
              fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Divider()]
          ), */
         Center(
           child: new FutureBuilder<List<Treino>>(
           future: downloadJSON(),
        //we pass a BuildContext and an AsyncSnapshot object which is an
        //Immutable representation of the most recent interaction with
        //an asynchronous computation.
           builder: (context, snapshot) {
           if (snapshot.hasData) {
             List<Treino> treinos = snapshot.data;
             return new CustomListView(treinos);
           } 
           else if (snapshot.hasError) {
             return Text('${snapshot.error}');
           }
           //return  a circular progress indicator.
             return new CircularProgressIndicator();
           },
          ),
         ) 
        ); 
  }
}