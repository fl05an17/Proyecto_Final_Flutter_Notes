import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

CollectionReference users =
    FirebaseFirestore.instance.collection('perilUsuarios');

Future<void> perfilUsuario(String documento, String nombre, int edad,
    String email, String ciudad, String direccion) {
  return users
      .doc(documento)
      .set({
        'nombre': nombre,
        'edad': edad,
        'email': email,
        'ciudad': ciudad,
        'direccion': direccion,
      })
      .then((value) => print("Perfil de usuario modificado.."))
      .catchError(
          (error) => print("Fallo la creación de datos de perfil: $error"));
}

Future<void> perfilUsuarioNuevo(String documento, String email) {
  return users
      .doc(documento)
      .set({
        'nombre': "",
        'edad': 0,
        'email': email,
        'ciudad': "",
        'direccion': "",
      })
      .then((value) => print("Perfil de usuario creado.."))
      .catchError(
          (error) => print("Fallo la creación de datos de perfil: $error"));
}

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key, required this.uid, required this.email})
      : super(key: key);
  final String uid;
  final String email;

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ciudadController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  String nombreUsuario = "";
  int edadUsuario = 0;
  String emailUsuario = "";
  String ciudadUsuario = "";
  String direccionUsuario = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Algo esta saliendo mal :(");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          perfilUsuarioNuevo(widget.uid, widget.email);

          return const Text(
              "El usuario no existe  y se creo un perfil nuevo:(");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          nombreController.text = data['nombre'];
          nombreUsuario = nombreController.text;

          edadController.text = data['edad'].toString();
          edadUsuario = int.parse(edadController.text);

          emailController.text = data['email'];
          emailUsuario = emailController.text;

          ciudadController.text = data['ciudad'];
          ciudadUsuario = ciudadController.text;

          direccionController.text = data['direccion'];
          direccionUsuario = direccionController.text;

          return AlertDialog(
              title: const Text('AlertDialog Title'),
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: nombreController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre',
                        ),
                        onChanged: (text) {
                          nombreUsuario = text;
                        },
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: edadController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Edad',
                        ),
                        onChanged: (text) {
                          edadUsuario = int.parse(text);
                        },
                      )),

                  Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'email',
                        ),
                        onChanged: (text) {
                          emailUsuario = text;
                        },
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: ciudadController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ciudad',
                        ),
                        onChanged: (text) {
                          ciudadUsuario = text;
                        },
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: direccionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Dirección',
                        ),
                        onChanged: (text) {
                          direccionUsuario = text;
                        },
                      )), // */
                  //====[Boton]===================
                  TextButton(
                    onPressed: (() => perfilUsuario(
                        widget.uid,
                        nombreUsuario,
                        edadUsuario,
                        emailUsuario,
                        ciudadUsuario,
                        direccionUsuario)),
                    child: const Text(
                      "Actualizar perfil",
                    ),
                  ),
                ],
              )));
        }

        return const Text("Cargando datos.....");
      },
    );
  }
}
