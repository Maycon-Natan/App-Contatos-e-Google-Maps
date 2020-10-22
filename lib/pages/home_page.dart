import 'package:flutter/material.dart';
import 'package:projeto_final/pages/home_page_contatos.dart';
import 'package:projeto_final/pages/home_page_maps.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("MENU PRINCIPAL"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(60),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'images/ifpi.png',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 160,
                  height: 150,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Contatos()));
                    },
                    child: Text('Contatos',
                        style: TextStyle(color: Colors.black, fontSize: 30)),
                  ),
                  color: Colors.greenAccent,
                ),
                Container(
                  width: 160,
                  height: 150,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AppMaps()));
                    },
                    child: Text('Mapas',
                        style: TextStyle(color: Colors.black, fontSize: 30)),
                  ),
                  color: Colors.greenAccent,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
