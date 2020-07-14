import 'package:flutter/material.dart';
import 'package:wetrats/layout.dart';
import 'login.dart';
import '../main.dart';
import 'treinos.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';


class Competicao {
  final String evento,data,local,ativo,resultado;
  Competicao({
    this.evento,
    this.data,
    this.local,
    this.ativo,
    this.resultado,
  });
factory Competicao.fromJson(Map<String, dynamic> jsonData) {
  var data = jsonData['data'].split("-");
  data = data[2] + '/' + data[1] + '/' + data[0];
  return Competicao(
    evento: jsonData['evento'],
    data: data,
    local: jsonData['local'],
    ativo: jsonData['ativo'],    
    resultado: jsonData['resultado'],
  );
 }
}

class CompeticoesPage extends StatefulWidget{
   static String tag = 'Competicoes-page';  //nome da pagina
  
   //variaveis utilizadas
   /* final String id;
   final String nivel;
   CompeticaosPage({this.id, this.nivel}); //variaveis q devem ser passadas
 */
  @override
  _CompeticoesPageState createState() => _CompeticoesPageState();
  
}

class _CompeticoesPageState extends State<CompeticoesPage>{
  String download;
  bool downloading;
  String _id= key.currentState.id;

  
  
  Future<List<List>> _downloadCompeticoes() async {

    final response = await http.get("https://www.wetrats.com.br/app/competicoes.php");

  if (response.statusCode == 200) {
    print("sucesso!");
    List futuras = json.decode(response.body)[0];
    List passadas = json.decode(response.body)[1];

    if(futuras.length>1){
      futuras = futuras.map((competicao) => new Competicao.fromJson(competicao)).toList();
      
      passadas = passadas.map((competicao) => new Competicao.fromJson(competicao)).toList();
      
      return [futuras,passadas];
    }
    else{
      passadas = passadas.map((competicao) => new Competicao.fromJson(competicao)).toList();
      return [[],passadas];
    }  
  } 
  else
      throw Exception('Falha na conexão com o servidor');
  }

  @override
  Widget build(BuildContext context){
    return 
    Layout.getContent(context,
          Center(
           child: new FutureBuilder<List<dynamic>>(
           future: _downloadCompeticoes(),
        //we pass a BuildContext and an AsyncSnapshot object which is an
        //Immutable representation of the most recent interaction with
        //an asynchronous computation.
           builder: (context, snapshot) {
           if (snapshot.hasData) {
             List<dynamic> futuras = snapshot.data[0];
             List<dynamic> passadas = snapshot.data[1];
             print(passadas);
             return new CustomListView(passadas);
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
Widget header(){
    return Container(
      padding: EdgeInsets.all(24.0),
    child: Column(children:[
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children:[        
            Icon(Icons.calendar_today, color: Layout.secondary(), size:32),
            Text("  Competições", style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, color: Colors.black),
              ),]
         ),
         Divider()]));
  }

class CustomListView extends StatefulWidget {
  final List<dynamic> competicoes;
  CustomListView(this.competicoes);

@override
  _CustomListViewState createState() => _CustomListViewState(competicoes);
  
}

class _CustomListViewState extends State<CustomListView>{
  final List<dynamic> competicoes;
  _CustomListViewState(this.competicoes);
  String urlPDFPath;
  String assetPDFPath;

  Color getColor(String ativo){
    if (ativo=="1"){
    
      return Layout.secondary();
  }
  else {return Layout.primary();
  }
  }

  Color getColor2(String ativo){
    if (ativo!="1"){
    
      return Layout.secondary();
  }
  else {return Layout.primary();
  }
  }

  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdf.pdf");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }

  Future<File> getFileFromUrl(String arquivo) async {
    try {
      var url = "https://wetrats.com.br/common/uploads/resultados/" + arquivo;
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getExternalStorageDirectory();
      File file = File("${dir.path}/" + arquivo);

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }


  Widget build(context) {
    return 
    ListView.builder(
      itemCount: competicoes.length,
      itemBuilder: (BuildContext context, int currentIndex) {
        if(currentIndex==0){
          return header();
        }
        currentIndex -=1;

      return createViewItem(competicoes[currentIndex], context);
  },
  );
}

Widget createViewItem(Competicao competicao, BuildContext context) {
  return new ListTile(
    title: new Card(
      elevation: 5.0,
      child: new Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black), color: getColor(competicao.ativo)),
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            Container(child:
            Column(
              children:[        
                  Row(children: [Text(competicao.evento, style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:getColor2(competicao.ativo)))],), 
                  Row(children:[
                    Text(
                    competicao.local + " | ",
                    style: new TextStyle(fontWeight: FontWeight.bold,color: getColor2(competicao.ativo)),
                    textAlign: TextAlign.left,
                    ),
                    
                    Text(
                      competicao.data,
                      style: new TextStyle(fontStyle: FontStyle.italic, color: getColor2(competicao.ativo)),
                      textAlign: TextAlign.left,
                    ) ])
              ]
            )),
            Container(child:
              RaisedButton(
              child:Icon(Icons.file_download, color: getColor(competicao.ativo),),
              color: getColor2(competicao.ativo),
              onPressed: (){
                getFileFromUrl(competicao.resultado).then((f) {
                setState(() {
                  urlPDFPath = f.path;
                  print(urlPDFPath);
                });
                if (urlPDFPath != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PdfViewPage(path: urlPDFPath, nome: competicao.resultado)));
                        }
                });
                
                
           }
          )
              ,
              width: 60,          
                  )
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween,)
        )
      )
    );
  }
         
}

class PdfViewPage extends StatefulWidget {
  final String path;
  final String nome;

  const PdfViewPage({Key key, this.path, this.nome}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
   var body = Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: false,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {
                _totalPages = _pages;
                pdfReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {});
            },
            onPageError: (page, e) {},
          ),
          !pdfReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
        ],
      );
      var floatingActionButton=  Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
                  backgroundColor: Layout.primary(),
                  label: Icon(Icons.share, color: Layout.secondary()),
                  onPressed: () {
                    final RenderBox box = context.findRenderObject();
                    Share.file(path: widget.path, title: widget.nome).share(
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) &
                                          box.size);
                  },
                )
          
        ],
      );
    return Layout.getContentPDF(context, body, floatingActionButton);
      
  }
}