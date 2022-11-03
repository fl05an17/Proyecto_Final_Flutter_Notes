import '/aplicacion/perfil.dart';

import '../global.dart' as globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //String uid_usuario = globals.uidLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Editar Perfil',
              onPressed: () {
                Navigator.of(context).pop();
              }),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Salir',
            onPressed: () {
              setState(() {
                _signOut();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PerfilPage(
              uid: globals.uidLogin,
              email: globals.idMail,
            ),
          ],
        ),
      ),
    );
  }
}
