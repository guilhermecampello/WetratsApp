import 'package:flutter/material.dart';
import 'package:wetrats/layout.dart';
import 'treinos.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LoginPage extends StatefulWidget{
  LoginPage({ Key key }) : super(key: key);
  static String tag = 'Login-page';
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  String _email='';
  String _senha='';
  String _nome='';
  String _id= '';
  String _nivel = '';
  bool _loading=false;
  int tentativa=0;

  TextEditingController email = new TextEditingController();
  TextEditingController senha = new TextEditingController();

  String mensagem = '';
  
  bool isHidden = true;

  verifica_login() async{
    print("verifica");
    _email = await FlutterSecureStorage().read(key: 'email');
    _senha = await FlutterSecureStorage().read(key: 'senha');
    if(_email!=null){
        email.text=_email;
        senha.text=_senha; 
        setState(() {
        tentativa +=1;
        _loading=true; 
      });
      final response = await http.get("https://www.wetrats.com.br/app/login.php?" + "email=" +  email.text +  "&senha="  + senha.text );

      var dados = json.decode(response.body);

      if(dados[0]=="ERRO"){
        await FlutterSecureStorage().deleteAll();
        setState((){
          mensagem = "Login Inválido";
          _loading = false;
        });
      }
      else{
          setState(() {
            _nome = dados[0]['nome'];
            _nivel = dados[0]['nivel'];
            //sexo = dados[0]['sexo'];
            _id = dados[0]['id'];
            //apelido = dados[0]['apelido'];
            //aniversario = dados[0]['aniversario'];
            //rg = dados[0]['rg'];
            //endereco = dados[0]['endereco'];
            //apelido = dados[0]['apelido'];
            //celular = dados[0]['celular'];
            _loading =false;    
          });
          final storage = new FlutterSecureStorage();
          await storage.write(key: 'email', value: email.text);
          await storage.write(key: 'senha', value: senha.text);

          Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage()));
        }
        return dados;

    }
    else return null;
  }
  
  void toggleVisibility(){
    setState(() {
      isHidden = !isHidden;
    });
  }

  Widget loading(_loading){
    if(tentativa==0)verifica_login();
    if(_loading)
      return CircularProgressIndicator();
    else return Container();
  }

  Future<List> login() async {
    print("https://www.wetrats.com.br/app/login.php?" + "email=" +  email.text +  "&senha="  + senha.text );
    setState(() {
      tentativa+=1;
     _loading=true; 
    });
    final response = await http.get("https://www.wetrats.com.br/app/login.php?" + "email=" +  email.text +  "&senha="  + senha.text );

  var dados = json.decode(response.body);

  if(dados[0]=="ERRO"){
    await FlutterSecureStorage().deleteAll();
    setState((){
      mensagem = "Login Inválido";
      _loading = false;
    });
  }
  else{
    if(dados[0]['nivel']=="1" || dados[0]['nivel']=="3"){
      setState(() {
        _nome = dados[0]['nome'];
        _nivel = dados[0]['nivel'];
        //sexo = dados[0]['sexo'];
        _id = dados[0]['id'];
        //apelido = dados[0]['apelido'];
        //aniversario = dados[0]['aniversario'];
        //rg = dados[0]['rg'];
        //endereco = dados[0]['endereco'];
        //apelido = dados[0]['apelido'];
        //celular = dados[0]['celular'];
        _loading =false;
        
      });
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'email', value: email.text);
      await storage.write(key: 'senha', value: senha.text);

      Navigator.push(context ,MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
  return dados;
  }
  String get id => _id;
  String get nome => _nome;
  String get nivel => _nivel;

  @override


  Widget build(BuildContext context){
    
    return Scaffold(
      backgroundColor: Layout.primary(),
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, right: 20.0, left: 20.0, bottom: MediaQuery.of(context).size.height*0.075),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: MediaQuery.of(context).size.height*0.2,child: 
            Image.asset('assets/images/logo.png', fit: BoxFit.cover, alignment: Alignment.center,)),  
            SizedBox(height: MediaQuery.of(context).size.height*0.08,width: MediaQuery.of(context).size.height*0.08, child: loading(_loading)),
            buildTextField("Email",email),
            SizedBox(height: MediaQuery.of(context).size.height*0.03,),
            buildTextField("Senha",senha),
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            Text(mensagem,style: TextStyle(fontSize: 20.0,color: Layout.secondary(), fontWeight: FontWeight.bold), ),
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            buildButtonContainer(),
            
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, controller){
    return TextField(
      keyboardType: hintText == "Email" ? TextInputType.emailAddress : TextInputType.text,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Layout.secondary(),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          
          borderRadius: BorderRadius.circular(20.0),
          
        ),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Layout.secondary()) ),
        prefixIcon: hintText == "Email" ? Icon(Icons.email,) : Icon(Icons.lock),
        suffixIcon: hintText == "Senha" ? IconButton(
          onPressed: toggleVisibility,
          icon: isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        ) : null,
      ),
      obscureText: hintText == "Senha" ? isHidden : false,
    );
  }

  Widget buildButtonContainer(){
    return Center(
        child: RaisedButton(
          color: Layout.secondary(),
          padding: const EdgeInsets.all(8.0),
          onPressed: (){
              login(); 
          },
          child:Text(
          "LOGIN",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );

  }
}