import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show get;
import 'package:wetrats/layout.dart';
import 'package:wetrats/main.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import './grafico.dart';

class Prova {
  final DateTime data;
  final double tempo;
  final String evento;
  final charts.Color cor;
  
  Prova(this.data,this.tempo,  this.evento, Color cor)
    : this.cor = new charts.Color(
            r: cor.red, g: cor.green, b: cor.blue, a: cor.alpha);
}


class PerformancesPage extends StatefulWidget{
  static String tag = 'Performances-page';
  @override
  PerformancesPageState createState() => PerformancesPageState();
}

class PerformancesPageState extends State<PerformancesPage>{
  var chartWidget;
  List toficiais;
  bool show = false;
  String _id= key.currentState.id;
  String _nome = key.currentState.nome;
  
  String selectedRadio;
  String selectedRadioTile;
  String _estiloselecionado;
  String _metragemselecionada;
  String estilo = "";
  String metragem = "";
  String tipo = '';


  var estilos=['Borboleta','Costas','Peito','Crawl','Medley'];
  var metragens=['25','50','75','100','150','200','400','800','1500'];



  @override
  void initState(){
    super.initState();
    selectedRadio='';
    selectedRadioTile='';
  }
  setSelectedRadio(String valor){
    setState(() {
     selectedRadio = valor; 
     tipo=valor;
    });
  }

  setSelectedRadioTile(String valor){
    setState(() {
     selectedRadioTile = valor; 
     tipo = valor;
    });
  }

  
  Widget build(BuildContext context){
    return Layout.getContent(context, 
    Container(padding: EdgeInsets.all(24.0),
    child: Column(children:[
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children:[        
            Icon(Icons.timeline, color: Layout.secondary(), size:32),
            Text("  Performance", style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, color: Colors.black),
              ),]
         ),
         Divider(),
         
         Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: <Widget>[
         DropdownButton<String>(
           hint: Text('Estilo', style:TextStyle(fontWeight: FontWeight.bold)),
           items: estilos.map((String dropDownStringItem){
             return DropdownMenuItem<String>(
               value: dropDownStringItem,
               child: Text(dropDownStringItem),);
               }).toList(),
           onChanged: (String newValueSelected){
             setState((){
               this._estiloselecionado = newValueSelected;
               estilo = newValueSelected;
             });
           },
           value: _estiloselecionado,
        ),

        DropdownButton<String>(
           hint: Text('Metragem', style:TextStyle(fontWeight: FontWeight.bold)),
           items: metragens.map((String dropDownStringItem){
             return DropdownMenuItem<String>(
               value: dropDownStringItem,
               child: Text(dropDownStringItem),);
               }).toList(),
           onChanged: (String newValueSelected){
             setState((){
               this._metragemselecionada = newValueSelected;
               metragem = newValueSelected;
             });
           },
           value: _metragemselecionada,
        )
        ]
    ),
    ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(children:[
          Radio(
          value: 'Tiro',
          groupValue: selectedRadio,
          activeColor: Colors.yellow,
          onChanged: (valor){
            setSelectedRadio(valor);
          },),
          Text("Tiro"),],
          crossAxisAlignment: CrossAxisAlignment.center),
        Column(children:[
          Radio(
          value: 'Melhor Média',
          groupValue: selectedRadio,
          activeColor: Colors.yellow,
          onChanged: (valor){
            setSelectedRadio(valor);
          },),Text("Melhor Média")],
          crossAxisAlignment: CrossAxisAlignment.center),
        Column(children:[
          Radio(
          value: 'BT',
          groupValue: selectedRadio,
          activeColor: Colors.yellow,
          onChanged: (valor){
            setSelectedRadio(valor);
          },),Text("BT")],
          crossAxisAlignment: CrossAxisAlignment.center,),]
      ),
      SizedBox(height: 20,),
      
      Row(children: <Widget>[
        RaisedButton(
          child: Text("FILTRAR", style: TextStyle(color:Layout.secondary(), )),
          disabledColor: Layout.primary(),
          color: Layout.primary(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: () {
              Navigator.push(context ,MaterialPageRoute(builder: (context) => GraficoPage(estilo: estilo, metragem: metragem, tipo: tipo)));  
          }) 
      ],
      mainAxisAlignment: MainAxisAlignment.center,)
             
        
      
     ]
      )
      )
      )
      ;
      }
}




