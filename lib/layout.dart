import 'package:flutter/material.dart';
import 'package:wetrats/pages/ranking.dart';
import 'pages/home.dart';
import 'pages/treinos.dart';
import 'pages/dividas.dart';
import 'pages/performances.dart';
import 'pages/competicoes.dart';
import 'pages/ranking.dart';
import 'package:provider/provider.dart';


class Layout{

  static final pages = [HomePage.tag , TreinosPage.tag, DividasPage.tag,PerformancesPage.tag,CompeticoesPage.tag, RankingPage.tag];
  static int currItem = 0;

  static Scaffold getContent(BuildContext context, content){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Layout.primary(),
        title: Center(child :Image.asset('assets/images/logo.png', fit: BoxFit.cover, alignment: Alignment.center,),
        )),
      body: content ,
      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: currItem,
        fixedColor: secondary(),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(activeIcon:Icon(Icons.person, color: Colors.amber ),icon: Icon(Icons.person, color: Colors.black, ), title: Text('Perfil', style: TextStyle(color: Colors.black.withOpacity(0.5)) )  ),
          BottomNavigationBarItem(activeIcon:Icon(Icons.assignment, color: Colors.amber ),icon: Icon(Icons.assignment, color: Colors.black), title: Text('Treinos', style: TextStyle(color: Colors.black.withOpacity(0.5)))),
          BottomNavigationBarItem(activeIcon:Icon(Icons.attach_money, color: Colors.amber ),icon: Icon(Icons.attach_money, color: Colors.black), title: Text('Financeiro', style: TextStyle(color: Colors.black.withOpacity(0.5)))),
          BottomNavigationBarItem(activeIcon:Icon(Icons.timeline, color: Colors.amber ),icon: Icon(Icons.timeline, color: Colors.black), title: Text('Performance', style: TextStyle(color: Colors.black.withOpacity(0.5)))),
          BottomNavigationBarItem(activeIcon:Icon(Icons.calendar_today, color: Colors.amber ), icon: Icon(Icons.calendar_today, color: Colors.black, ), title: Text('Competições', style: TextStyle(color: Colors.black.withOpacity(0.5)) )  ),
          BottomNavigationBarItem(activeIcon:Image.asset('assets/images/podium.png', color: Colors.amber, height:55,width:55 ),icon: Image.asset('assets/images/podium.png', height:50, width:50), title: Text('Ranking', style: TextStyle(color: Colors.black.withOpacity(0.5))))
                
        ],
        onTap: (int i) {
            currItem = i;
            Navigator.of(context).pushNamed(pages[currItem]);  
        },),  
    );
  }

  static Scaffold getContent2(BuildContext context, content,floatingactionbutton){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Layout.primary(),
        title: Center(child :Image.asset('assets/images/logo.png', fit: BoxFit.cover, alignment: Alignment.center,),
        )),
      body: content ,
      floatingActionButton: floatingactionbutton,
      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: currItem,
        fixedColor: secondary(),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(activeIcon:Icon(Icons.person, color: Colors.amber ),icon: Icon(Icons.person, color: Colors.black, ), title: Text('Perfil', style: TextStyle(color: Colors.black.withOpacity(0.5)) )  ),
          BottomNavigationBarItem(activeIcon:Icon(Icons.assignment, color: Colors.amber ),icon: Icon(Icons.assignment, color: Colors.black), title: Text('Treinos', style: TextStyle(color: Colors.black.withOpacity(0.5)))),
          BottomNavigationBarItem(activeIcon:Icon(Icons.attach_money, color: Colors.amber ),icon: Icon(Icons.attach_money, color: Colors.black), title: Text('Financeiro', style: TextStyle(color: Colors.black.withOpacity(0.5)))),
          BottomNavigationBarItem(activeIcon:Icon(Icons.timeline, color: Colors.amber ),icon: Icon(Icons.timeline, color: Colors.black), title: Text('Performance', style: TextStyle(color: Colors.black.withOpacity(0.5)))),
          BottomNavigationBarItem(activeIcon:Icon(Icons.calendar_today, color: Colors.amber ), icon: Icon(Icons.calendar_today, color: Colors.black, ), title: Text('Competições', style: TextStyle(color: Colors.black.withOpacity(0.5)) )  ),
          BottomNavigationBarItem(activeIcon:Image.asset('assets/images/podium.png', color: Colors.amber, height:55,width:55 ),icon: Image.asset('assets/images/podium.png', height:50, width:50), title: Text('Ranking', style: TextStyle(color: Colors.black.withOpacity(0.5))))
                
        ],
        onTap: (int i) {
            currItem = i;
            Navigator.of(context).pushNamed(pages[currItem]);  
        },),  
    );
  }

  static Scaffold getContentPDF(BuildContext context, body, floatingActionButton){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Layout.primary(),
        title: Center(child :Image.asset('assets/images/logo.png', fit: BoxFit.cover, alignment: Alignment.center,),
        )),
      body: body ,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: currItem,
        fixedColor: secondary(),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(activeIcon:Icon(Icons.person, color: Colors.amber ),icon: Icon(Icons.person, color: Colors.black, ), title: Text('Perfil', style: TextStyle(color: Colors.black.withOpacity(0.5)) )  ),
          BottomNavigationBarItem(activeIcon:Icon(Icons.assignment, color: Colors.amber ),icon: Icon(Icons.assignment, color: Colors.black), title: Text('Treinos', style: TextStyle(color: Colors.black.withOpacity(0.5)))),
          BottomNavigationBarItem(activeIcon:Icon(Icons.attach_money, color: Colors.amber ),icon: Icon(Icons.attach_money, color: Colors.black), title: Text('Financeiro', style: TextStyle(color: Colors.black.withOpacity(0.5)))),
          BottomNavigationBarItem(activeIcon:Icon(Icons.timeline, color: Colors.amber ),icon: Icon(Icons.timeline, color: Colors.black), title: Text('Performance', style: TextStyle(color: Colors.black.withOpacity(0.5)))),
          BottomNavigationBarItem(activeIcon:Icon(Icons.calendar_today, color: Colors.amber ), icon: Icon(Icons.calendar_today, color: Colors.black, ), title: Text('Competições', style: TextStyle(color: Colors.black.withOpacity(0.5)) )  ),
          BottomNavigationBarItem(activeIcon:Image.asset('assets/images/podium.png', color: Colors.amber, height:55,width:55 ),icon: Image.asset('assets/images/podium.png', height:50, width:50), title: Text('Ranking', style: TextStyle(color: Colors.black.withOpacity(0.5))))
                
        ],
        onTap: (int i) {
            currItem = i;
            Navigator.of(context).pushNamed(pages[currItem]);  
        },),  
    );
  }
  static Color primary([double opacity = 1]) => Color.fromRGBO(15,15,54,1);
  static Color secondary([double opacity = 0.8]) => Color.fromRGBO(255,187,0,0.8);
  

} 

  