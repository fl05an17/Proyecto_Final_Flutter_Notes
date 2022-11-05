import 'package:base_tortas/aplicacion/note_editor.dart';
import 'package:base_tortas/aplicacion/note_reader.dart';
import 'package:base_tortas/styles/app_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:base_tortas/widgets/note_card.dart';

class NotesHome extends StatefulWidget {
  const NotesHome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tus Notas recientes',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //Validar el estado de la conexion
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  //Iteramos a traves de un map la lista de notas y las msotramos en pantalla
                  if (snapshot.hasData) {
                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      children: snapshot.data!.docs
                          .map((note) => noteCard(() {
                                //Navigator nos permite navegar entre diferentes screens de acuerdo a nuestro flujo
                                //Para este caso esta navegacion nos lleva hacia la pantalla de lectura de la nota
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NoteReaderScreen(note),
                                    ));
                              }, note))
                          .toList(),
                    );
                  }
                  //Retornamos un texto en caso de que no existan notas
                  return Text(
                    'No hay notas',
                    style: GoogleFonts.nunito(color: Colors.white),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoteEditorScreen()));
        },
        label: Text("Nueva Nota"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
