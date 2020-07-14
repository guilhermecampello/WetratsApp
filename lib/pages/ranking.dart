import 'package:flutter/material.dart';
import 'package:wetrats/layout.dart';
import 'login.dart';
import '../main.dart';
import 'treinos.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RankingPage extends StatefulWidget{
   static String tag = 'Ranking-page';  //nome da pagina
  
   //variaveis utilizadas
   /* final String id;
   final String nivel;
   RankingPage({this.id, this.nivel}); //variaveis q devem ser passadas
 */
  @override
  _RankingPageState createState() => _RankingPageState();
  
}

class _RankingPageState extends State<RankingPage>{

  String _id= key.currentState.id;
  int prova = 0;
  bool isloading=true;
  
  String getprova(int numero){
    if(numero==0) return "50 Borboleta";
    if(numero==1) return "50 Costas";
    if(numero==2) return "50 Peito";
    if(numero==3) return "50 Livre";
    if(numero==4) return "100 Medley";
  }
  Future<List<dynamic>> _downloadRanking() async {

    final response = await http.get("https://www.wetrats.com.br/app/ranking.php");

  if (response.statusCode == 200) {
    List<dynamic> dados = json.decode(response.body);
    print("sucesso!");
    setState(() {
              isloading = false; 
             });
    return dados;
  } else
      throw Exception('Falha na conexão com o servidor');
  }
  
  
  Widget loading(bool isloading){
    if(isloading){
      return SizedBox.fromSize(size: Size(10,10),
        child: CircularProgressIndicator());
    }
      else return SizedBox(height:1);
    }

  Widget montaTabela(dynamic dados) {

  return Container(child:

    Column(children: <Widget>[
    //feminino
    SizedBox(height: 10,),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text("Feminino", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Layout.secondary())) ],),
    SizedBox(height: 10,),
    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      Column(children: <Widget>[ //colocação
        Text("#1", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#2", style: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color: Layout.secondary()),),
        Text("#3", style: TextStyle(fontSize:14, fontWeight: FontWeight.w500, color: Layout.secondary()),),
        Text("#4", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#5", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#6", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#7", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#8", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#9", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#10", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
      ]),
      Column(children: <Widget>[// nome
        Text(dados[0][0][0], style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
        Text(dados[0][1][0], style: TextStyle(fontSize:16, fontWeight: FontWeight.bold)),
        Text(dados[0][2][0], style: TextStyle(fontSize:14, fontWeight: FontWeight.bold)),
        Text(dados[0][3][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][4][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][5][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][6][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][7][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][8][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][9][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
      ]),
      Column(children: <Widget>[//tempo
        Text(dados[0][0][1], style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
        Text(dados[0][1][1], style: TextStyle(fontSize:16, fontWeight: FontWeight.bold)),
        Text(dados[0][2][1], style: TextStyle(fontSize:14, fontWeight: FontWeight.bold)),
        Text(dados[0][3][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][4][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][5][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][6][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][7][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][8][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][9][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
      ]),

      Column(children: <Widget>[//ano
        Text(dados[0][0][3], style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
        Text(dados[0][1][3], style: TextStyle(fontSize:16, fontWeight: FontWeight.bold)),
        Text(dados[0][2][3], style: TextStyle(fontSize:14, fontWeight: FontWeight.bold)),
        Text(dados[0][3][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][4][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][5][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][6][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][7][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][8][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[0][9][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
      ]),

  
    ],),
    SizedBox(height: 20,),
    //Masculino
    Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text("Masculino", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Layout.secondary())) ],),
    SizedBox(height: 10,),
    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      Column(children: <Widget>[ //colocação
        Text("#1", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#2", style: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color: Layout.secondary()),),
        Text("#3", style: TextStyle(fontSize:14, fontWeight: FontWeight.w500, color: Layout.secondary()),),
        Text("#4", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#5", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#6", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#7", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#8", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#9", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
        Text("#10", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: Layout.secondary()),),
      ]),
      Column(children: <Widget>[// nome
        Text(dados[1][0][0], style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
        Text(dados[1][1][0], style: TextStyle(fontSize:16, fontWeight: FontWeight.bold)),
        Text(dados[1][2][0], style: TextStyle(fontSize:14, fontWeight: FontWeight.bold)),
        Text(dados[1][3][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][4][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][5][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][6][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][7][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][8][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][9][0], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
      ]),
      Column(children: <Widget>[//tempo
        Text(dados[1][0][1], style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
        Text(dados[1][1][1], style: TextStyle(fontSize:16, fontWeight: FontWeight.bold)),
        Text(dados[1][2][1], style: TextStyle(fontSize:14, fontWeight: FontWeight.bold)),
        Text(dados[1][3][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][4][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][5][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][6][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][7][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][8][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][9][1], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
      ]),

      Column(children: <Widget>[//ano
        Text(dados[1][0][3], style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
        Text(dados[1][1][3], style: TextStyle(fontSize:16, fontWeight: FontWeight.bold)),
        Text(dados[1][2][3], style: TextStyle(fontSize:14, fontWeight: FontWeight.bold)),
        Text(dados[1][3][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][4][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][5][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][6][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][7][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][8][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
        Text(dados[1][9][3], style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
      ]),

  
    ],)
    ],));
  }
  Color corbotao(botao){
    if (prova==botao){return Layout.secondary();}
    else return Layout.primary();

  }

  Color cortxtbotao(botao){
    if (prova==botao){return Layout.primary();}
    else return Layout.secondary();

  }
  
  @override
  Widget build(BuildContext context){
    return 
    Layout.getContent(context,
         ListView(padding: EdgeInsets.only(top:20),
           children:[
        Row(children:[        
            Image.asset('assets/images/podium.png', color: Colors.amber, height:55,width:55 ),
            Text("  Ranking", style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, color: Colors.black),
              ),],
              mainAxisAlignment: MainAxisAlignment.center,
         ),
         
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: <Widget>[
             RaisedButton(child: Text("50 Borboleta", style: TextStyle(color: cortxtbotao(0) , fontWeight: FontWeight.bold),), 
                          color: corbotao(0),
                          onPressed: (){
                            setState(() {
                             prova = 0; 
                            });
                          },),
              RaisedButton(child: Text("50 Costas", style: TextStyle(color: cortxtbotao(1), fontWeight: FontWeight.bold),), 
                          color: corbotao(1),
                          onPressed: (){
                            setState(() {
                             prova = 1; 
                            });
                          },),
              RaisedButton(child: Text("50 Peito", style: TextStyle(color: cortxtbotao(2), fontWeight: FontWeight.bold),), 
                          color: corbotao(2),
                          onPressed: (){
                            setState(() {
                             prova = 2; 
                            });
                          },)]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              RaisedButton(
                child: Text("  50 Livre  ", style: TextStyle(color: cortxtbotao(3), fontWeight: FontWeight.bold),), 
                          color: corbotao(3),
                          onPressed: (){
                            setState(() {
                             prova = 3; 
                            });
                          },),
              RaisedButton(child: Text("100 Medley", style: TextStyle(color: cortxtbotao(4), fontWeight: FontWeight.bold),), 
                          color: corbotao(4),
                          onPressed: (){
                            setState(() {
                             prova = 4; 
                            });
                          },)
           ]),
           Divider(),
           
         FutureBuilder<List<dynamic>>(
           future: _downloadRanking(),
           builder: (context, snapshot) {
           if (snapshot.hasData) {
             List<dynamic> ranking = snapshot.data;
             print(ranking[prova]);
             return montaTabela(ranking[prova]);
           } 
           else if (snapshot.hasError) {
             return Text('${snapshot.error}');
           }
           return Stack(alignment: Alignment.center ,children:[ CircularProgressIndicator()],);
           },
          )
           
    ])
          ); 
  }
}


