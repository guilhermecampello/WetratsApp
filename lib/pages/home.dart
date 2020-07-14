import 'package:flutter/material.dart';
import 'package:wetrats/layout.dart';
import 'login.dart';
import '../main.dart';
import 'treinos.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:math';

class Perfil {
  final bool temfoto;
  final String nome,aniversario,rg,celular,endereco,foto;
  Perfil({
    this.nome,
    this.aniversario,
    this.rg,
    this.celular,
    this.endereco,
    this.foto,
    this.temfoto
  });
factory Perfil.fromJson(Map<String, dynamic> jsonData) {
  bool flagfoto;
  String nomefoto;

  var aniversario = jsonData['aniversario'].split("-");
  var aniversariof = aniversario[2] + '/' + aniversario[1] + '/' + aniversario[0];
  if (jsonData['foto'].length>4){
    flagfoto = true;
    nomefoto = "https://www.wetrats.com.br/common/uploads/fotosdeperfil/"+jsonData['foto']; 
  }
  else{
    flagfoto = false;
    nomefoto = "null";
  }
  return Perfil(
    nome: jsonData['nome'],
    aniversario: aniversariof,
    rg: jsonData['RG'],
    celular: jsonData['celular'],
    endereco: jsonData['endereco'],
    foto: nomefoto,
    temfoto: flagfoto
  );
}
}

class VisualizaPerfil extends StatelessWidget{
  final Perfil perfil;
  VisualizaPerfil(this.perfil);
  
  Widget getFoto(bool temfoto,String foto, context){
    if (perfil.temfoto){
      return Image.network(perfil.foto, fit: BoxFit.fitHeight,);
      }
  else {
    return (IconTheme(child:Icon(Icons.pool, color: Colors.black,),data:IconThemeData(size:MediaQuery.of(context).size.height*0.2)));
  }
  }
  Widget build(context) => Container(decoration: new BoxDecoration(border: Border.all(color: Colors.grey,width:2.0), gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.amber[50],
            Colors.amber[100],
            Colors.amber[200],
            Colors.amber[300],
          ],)) ,
  child: Column(children:[
      Container(child: getFoto(perfil.temfoto, perfil.foto,context), 
                height:MediaQuery.of(context).size.height*0.2 ,padding:EdgeInsets.all(8.0)),
      
      Row(children:[
        Expanded(child:Text(perfil.nome ,style: TextStyle(fontSize: 28, color: Colors.black)))]),
      Divider(),
      Row(children:[
        Text('RG',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Layout.primary())),
        Text(perfil.rg ,style: TextStyle(fontSize: 14, color: Colors.black))]),
      Row(children:[
        Icon(Icons.cake, color: Layout.primary()),
        Text(perfil.aniversario ,style: TextStyle(fontSize: 14, color: Colors.black))]),
      Row(children:[
        Icon(Icons.phone, color: Layout.primary()),
        Text(perfil.celular ,style: TextStyle(fontSize: 14, color: Colors.black))]),
      Row(children:[
        Icon(Icons.home, color: Layout.primary()),
        Expanded(child:Text(perfil.endereco ,style: TextStyle(fontSize: 14, color: Colors.black)))
        ])] 
  ));
}

class HomePage extends StatefulWidget{
   static String tag = 'home-page'; //nome da pagina
  
  @override
  _HomePageState createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage>{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _id = key.currentState.id;
  String _nome = key.currentState.nome;
  bool _pse = false;

  @override
  void initState(){
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('mipmap/logo');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload){
    debugPrint("payload: $payload");
    showDialog(context: context,
                builder: (_)=> new AlertDialog(
                  title: new Text("LEMBRETE:"),
                  content: new Text("Não se esqueça da PSE"),
                ));
  }

  showNotification() async{
    
    var time = new Time(13,30, 0);
var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
var platformChannelSpecifics = new NotificationDetails(
    androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
await flutterLocalNotificationsPlugin.showDailyAtTime(
    0,
    "PSE",
    "Já respondeu hoje?",
    time,
    platformChannelSpecifics);
    print("notificacao"+ Time(13,30).hour.toString()+":"+Time(13,30).minute.toString());
  }

  Future<Perfil> _perfil() async {
    showNotification();

    final response = await http.get("https://www.wetrats.com.br/app/perfil.php?" + "id=" + _id );

  if (response.statusCode == 200) {
    List dados = json.decode(response.body);
    print("sucesso!");
    return dados.map((perfil) => new Perfil.fromJson(perfil)).toList()[0];
  } else
      throw Exception('Falha na conexão com o servidor');
  }
  botao(){
    if(!_pse) return 
    FloatingActionButton(
      backgroundColor: Layout.primary(),
      child: Text("PSE",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      onPressed: ()async{
        var pse =await showDialog(context: context, builder: (context) => StatusPickerDialog());
        if(pse=="ok") setState(() {
          _pse=true; 
        });
        },);
        else { 
        return FloatingActionButton(backgroundColor: Layout.primary(),child: Icon(Icons.check, color: Colors.white,),onPressed: (){
        },);
      } 
  }
  
  Widget build(BuildContext context){

    final content = 
    Container(padding: EdgeInsets.all(24.0),
    child: Column(children:[
        Stack(children: <Widget>[
          FlatButton(child: Text("LOGOUT",style: TextStyle(color: Layout.primary(), fontWeight: FontWeight.bold),),onPressed: ()async{
            await FlutterSecureStorage().deleteAll();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(key:key)), (Route<dynamic> route) => false);
          },),
        Row(children:[        
            Icon(Icons.person, color: Layout.secondary(), size:32),
            Text("  Perfil", style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, color: Colors.black),
              ),],
              mainAxisAlignment: MainAxisAlignment.center,
         )]),
         Divider(),
        Container( 
        child: new FutureBuilder<Perfil>(
           future: _perfil(),
           builder: (context, snapshot) {
           if (snapshot.hasData) {
             Perfil perfil = snapshot.data;
             return VisualizaPerfil(perfil);
           } 
           else if (snapshot.hasError) {
             return Text('${snapshot.error}');
           }
           //return  a circular progress indicator.
             return new CircularProgressIndicator();
           },
          ))]));

    return Layout.getContent2(context, content,botao()
    
    );
  }
}

class StatusPickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final int psesessao=5;


  @override
  _StatusPickerDialogState createState() => _StatusPickerDialogState();
}

class _StatusPickerDialogState extends State<StatusPickerDialog> {
  /// current selection of the slider
  TextEditingController _psedesc= TextEditingController(text: '');
  int _psesessao;
  bool _loading=false;
  
  
  Future pse(sessao,descanso)async{
    final response = await http.get("https://www.wetrats.com.br/app/PSE.php?ses=" + sessao+"&descs="+descanso);

    if (response.statusCode == 200) {
      List dados = json.decode(response.body);
      print("pse sucesso!");
      return dados[0];
    } else
        throw Exception('Falha na conexão com o servidor');
    } 



  @override
  void initState() {
    super.initState();
    _psesessao = widget.psesessao;
  }

  Widget carregando(_loading){
    if(_loading) return CircularProgressIndicator();
    else return Container();

  }

  @override
  Widget build(BuildContext context) {

  return AlertDialog(backgroundColor: Layout.primary(),title: Text("ADICIONAR PSE", style: TextStyle(fontWeight: FontWeight.bold, color: Layout.secondary()),),
                    content: Column(mainAxisSize: MainAxisSize.min,
                      
                      children: <Widget>[

                                                                
                            Slider(activeColor: Layout.secondary(),
                                    label: _psesessao.toString() ,
                                    value: _psesessao.toDouble(),
                                    min: 0.0,
                                    max:10.0,
                                    divisions: 10,
                                    onChanged: (valor){
                                      setState(() {
                                        _psesessao = valor.toInt();
                                      });

                                    },
                                    ),
                            Text("Treino", style: TextStyle(color: Colors.white),),

                            SizedBox(height: MediaQuery.of(context).size.height*0.08,width:MediaQuery.of(context).size.height*0.08 ,child: carregando(_loading),),       
                            
                            SizedBox(width: MediaQuery.of(context).size.width*0.3,child: 
                            TextField(controller: _psedesc,
                                      
                                      cursorColor: Layout.secondary(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(filled: true,
                                                                  fillColor: Colors.white,
                                                                  hintText: "DESCANSO", 
                                                                  hintStyle: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Layout.secondary()) )),
                                    )),
  
                                    
                                    ButtonBar(alignment: MainAxisAlignment.spaceBetween,children: <Widget>[
                                    
                                      IconButton(highlightColor: Layout.primary(),color:Colors.white,icon: Icon(Icons.arrow_back),
                                      onPressed: (){
                                            Navigator.pop(context);}
                                      ),
                                      
                                      IconButton(icon: Icon(Icons.send, color: Colors.white,),onPressed:()async{ 
                                        setState(() {
                                          _loading = true; 
                                        });
                                        print("PSE:"+_psesessao.toString());
                                        print("Descanso:"+_psedesc.text);
                                        var query = await pse(_psesessao.toString(),_psedesc.text);
                                        print(query);
                                        if(query=="OK")
                                          Navigator.pop(context,"ok");
                                        else setState(() {
                                         _loading = false;
                                         Scaffold.of(context).showSnackBar(SnackBar(content: Text("Falha ao adicionar PSE"),)); 
                                        });
                                      },)
                                    ],)
                                    ],
                                    ),
                                  );                                  
  }
}

