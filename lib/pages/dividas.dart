import 'package:flutter/material.dart';
import 'package:wetrats/layout.dart';
import 'login.dart';
import '../main.dart';
import 'treinos.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Divida {
  final String valor,datacriacao,descricao,status,atualizacao;
  Divida({
    this.valor,
    this.datacriacao,
    this.descricao,
    this.status,
    this.atualizacao,
  });
factory Divida.fromJson(Map<String, dynamic> jsonData) {
  var datacriacao = jsonData['data_criacao'].split("-");
  var datacriacaof = datacriacao[2] + '/' + datacriacao[1] + '/' + datacriacao[0];
  var atualizacao = jsonData['atualizacao'].split("-");
  var atualizacaof = atualizacao[2] + '/' + atualizacao[1] + '/' + atualizacao[0];
  return Divida(
    valor: jsonData['valor'],
    datacriacao: datacriacaof,
    descricao: jsonData['descricao'],
    status: jsonData['status'],    
    atualizacao: atualizacaof,
  );
 }
}

class DividasPage extends StatefulWidget{
   static String tag = 'dividas-page';  //nome da pagina
  
   //variaveis utilizadas
   /* final String id;
   final String nivel;
   DividasPage({this.id, this.nivel}); //variaveis q devem ser passadas
 */
  @override
  _DividasPageState createState() => _DividasPageState();
  
}

class _DividasPageState extends State<DividasPage>{

  String _id= key.currentState.id;
  
  Future<List<Divida>> _downloadDividas() async {

    final response = await http.get("https://www.wetrats.com.br/app/dividas.php?" + "id=" + _id );

  if (response.statusCode == 200) {
    List dados = json.decode(response.body);
    print("sucesso!");
    return dados.map((divida) => new Divida.fromJson(divida)).toList();
  } else
      throw Exception('Falha na conexão com o servidor');
  }

  @override
  Widget build(BuildContext context){
    return 
    Layout.getContent(context,
         Center(
           child: new FutureBuilder<List<Divida>>(
           future: _downloadDividas(),
        //we pass a BuildContext and an AsyncSnapshot object which is an
        //Immutable representation of the most recent interaction with
        //an asynchronous computation.
           builder: (context, snapshot) {
           if (snapshot.hasData) {
             List<Divida> dividas = snapshot.data;
             return         
             new CustomListView(dividas);
           } 
           else if (snapshot.hasError) {
             return Text('${snapshot.error}');
           }
           //return  a circular progress indicator.
             return new CircularProgressIndicator();
           },
          )
          )
          ); 
  }
}

Widget total(List<Divida> dividas){
  double total=0;

  for(var i = 0; i < dividas.length ; i++){
    if(dividas[i].status=="NP") 
      total += double.parse(dividas[i].valor);
  }
  return Center(child:Container(
              child: 
               Text("DÍVIDA: R\$" + total.toStringAsFixed(2),style: TextStyle(fontSize: 32, color: Colors.black)),
              padding: EdgeInsets.all(20.0), )
             ,);
}

class CustomListView extends StatelessWidget {
  final List<Divida> dividas;
  CustomListView(this.dividas);


  Color getColor(String status){
    if (status=="NP"){
    
      return Colors.red;
  }
  else {return Colors.green;
  }
  }
  
  Widget build(context) {
    
    return 
    ListView.builder(
      itemCount: dividas.length,
      itemBuilder: (BuildContext context, int currentIndex) {
        if(currentIndex==0){
          return total(dividas);
        }
        currentIndex -=1;

      return createViewItem(dividas[currentIndex], context);
  },
  );
}

Widget createViewItem(Divida divida, BuildContext context) {
  return new ListTile(
    title: new Card(
      elevation: 5.0,
      child: new Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black), color: getColor(divida.status) ),
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            /* Padding(
              child: Image.network(treino.nomefoto),
                padding: EdgeInsets.only(bottom: 8.0),
                ), */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Container(
                child: Row(children:[ 
                  Text(
                    divida.descricao + " | ",
                    style: new TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
          Text(
                      divida.datacriacao,
                      style: new TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.left,
                  )]),
                padding: EdgeInsets.all(1.0),
                ),

              Container(child:
                Text('R\$' + divida.valor,style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign:TextAlign.right),
              )
              ]),
            ],
          ),
        ),
      ),
      );
}
}