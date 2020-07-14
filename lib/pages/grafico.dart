import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show get;
import 'package:wetrats/layout.dart';
import 'package:wetrats/main.dart';
import './performances.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class GraficoPage extends StatefulWidget{
  final String estilo, metragem,tipo;
  static String tag = 'Grafico-page';
  GraficoPage({
    this.estilo,
    this.metragem,
    this.tipo
  });
  @override
  GraficoPageState createState() => GraficoPageState();
}

class GraficoPageState extends State<GraficoPage>{
  var chartWidget;
  var conteudo = <Widget>[Text("...")];
  List toficiais;
  List ttreino;
  bool show = false;
  String _id= key.currentState.id;
  String _nome = key.currentState.nome;
  dynamic _data;
  dynamic _tempo;
  dynamic _evento;
  

  Future<charts.TimeSeriesChart> downloadTiros() async {
  final jsonEndpoint = "https://www.wetrats.com.br/app/performances.php?id="+key.currentState.id+"&nome="+key.currentState.nome+"&estilo="+widget.estilo+"&metragem="+widget.metragem+"&tipo="+widget.tipo;
  final response = await get(jsonEndpoint);
  if (response.statusCode == 200) {
    toficiais = json.decode(response.body)[1];
    ttreino = json.decode(response.body)[0];
    var dataoficiais = toficiais.map((prova)=>new Prova(DateTime.parse(prova[0]),prova[1],prova[2],Layout.secondary())).toList();
    var datatreino = ttreino.map((prova)=>new Prova(DateTime.parse(prova[0]),prova[1],prova[2],Layout.primary())).toList();
    

    var series = [new charts.Series<Prova,DateTime>(
                            id: 'Placar Eletrônico',
                            domainFn: (Prova prova, _) => prova.data,
                            measureFn: (Prova prova, _) => prova.tempo,
                            colorFn: (Prova prova, _) => prova.cor,
                            data: dataoficiais,
                          ),
                  new charts.Series<Prova,DateTime>(
                            id: 'Outros',
                            domainFn: (Prova prova, _) => prova.data,
                            measureFn: (Prova prova, _) => prova.tempo,
                            colorFn: (Prova prova, _) => prova.cor,
                            data: datatreino,
                          )
                        ];
              var chart = new charts.TimeSeriesChart(
                          series,
                          animate: false,
                          primaryMeasureAxis: new charts.NumericAxisSpec(tickProviderSpec:
                                              new charts.BasicNumericTickProviderSpec(zeroBound: false, desiredMinTickCount:5, desiredMaxTickCount:10 ), 
                                              renderSpec: charts.GridlineRendererSpec(
                                              lineStyle: charts.LineStyleSpec(
                                              dashPattern: [4, 4],),)),
                          selectionModels: [
                                              new charts.SelectionModelConfig(
                                              type: charts.SelectionModelType.info,
                                              changedListener: _onSelectionChanged,
                                            ),],
                                            behaviors:[new charts.SeriesLegend(position: charts.BehaviorPosition.bottom,  outsideJustification: charts.OutsideJustification.middleDrawArea ) ]
                          );
                    
                return chart;
  } 
  else{
      throw Exception('Falha na conexão com o servidor');
  }
  }
  @override

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    var tmp;
    DateTime data;
    final tempo = <String, double>{};
    final evento =<String, String>{};

    if (selectedDatum.isNotEmpty) {
      data = selectedDatum.first.datum.data;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        tempo[datumPair.series.displayName] = datumPair.datum.tempo;
        evento[datumPair.series.displayName] = datumPair.datum.evento;
      });
    }

    // Request a build.
    setState(() {
      _data = data.toString();
      _data = _data.split(" ");
      _data = _data[0].split("-");
      _data = _data[2] + '/' + _data[1] + '/' + _data[0];
      _tempo = tempo;
      tmp=_tempo.values.toList();
      tmp =tmp[0].toString().replaceAll(".", '"');
      _evento = evento.values.toList();
      _evento = _evento[0];
      conteudo = <Widget>[new Row(children:[Icon(Icons.calendar_today,color:Colors.yellow),Text(" " + _data,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))], mainAxisAlignment: MainAxisAlignment.start),
                              Row(children:[Text("          "+_evento, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontStyle: FontStyle.italic))]),
                              
                              Padding(padding: EdgeInsets.only(top:4.0),child:
                              Row(children:[Icon(Icons.alarm,color:Colors.yellow),Text(" " + tmp, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))],mainAxisAlignment: MainAxisAlignment.start))];
    });

  }



  Widget build(BuildContext context){
    return Layout.getContent(context, 
    Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children:[
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children:[        
            Icon(Icons.timeline, color: Layout.secondary(), size:32),
            Text("Evolução", style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, color: Colors.black),
              ),]),
          Divider(),
          Row(children: <Widget>[Text("   " + widget.metragem + " " + widget.estilo,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 24)), 
          Container(
          width:MediaQuery.of(context).size.width*0.5,
          padding: new EdgeInsets.all(4.0),
          child: Column(children: conteudo, crossAxisAlignment: CrossAxisAlignment.end,)),],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
         
          FutureBuilder(
            future: downloadTiros(),
            builder: (context,snapshot){
            if (snapshot.hasData){
              charts.TimeSeriesChart chart = snapshot.data;
              return Container(child: chart,width:MediaQuery.of(context).size.width * 0.9 ,height: MediaQuery.of(context).size.height  * 0.4);
            }
            if (snapshot.hasError) {
             return Text('${snapshot.error}');
           }
            return new CircularProgressIndicator();
            }
          ),
           
          ]
        )));
  
}
}