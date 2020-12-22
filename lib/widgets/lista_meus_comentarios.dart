import 'package:Confidence/telas/conto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MeusComentarios extends StatefulWidget {
  List<QueryDocumentSnapshot> listaComentarios;

  MeusComentarios(this.listaComentarios);

  @override
  _MeusComentariosState createState() => _MeusComentariosState();
}

class _MeusComentariosState extends State<MeusComentarios> {
  int comentariosNum;
  int comentarioNovoNum;

  String autor;

  recuperarUsuario() {
    setState(() {
      autor = FirebaseAuth.instance.currentUser.uid;
    });
  }

 
  excluirComentario(String idConto, String idComentario, index) async {
    
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('contos')
        .doc(idConto)
        .get();
      comentariosNum = documentSnapshot.data()['comentarios'];
      comentarioNovoNum = comentariosNum - 1;
    print('numero de comentarios : ' + comentariosNum.toString());
    print('numero de comentarios : ' + comentarioNovoNum.toString());

    if (comentariosNum != null) {
      print('comentariosNãoNum');
      String idConto = widget.listaComentarios[index]['conto'];
      String idComentario = widget.listaComentarios[index].reference.id;
      print('idConto : ' + idConto);
      print('idComentario : ' + idComentario);

      FirebaseFirestore.instance
          .collection('comentarios')
          .doc(autor)
          .collection('comentarios')
          .doc(idComentario)
          .delete();

      FirebaseFirestore.instance
          .collection('contos')
          .doc(idConto)
          .collection('comentarios')
          .doc(idComentario)
          .delete();

      FirebaseFirestore.instance
          .collection('contos')
          .doc(idConto)
          .update({'comentarios': comentarioNovoNum});

      Navigator.of(context).pop();
    } else if (comentariosNum == null) {
      print('comentariosNum');
      String idConto = widget.listaComentarios[index]['conto'];
      String idComentario = widget.listaComentarios[index].reference.id;
      print('idConto : ' + idConto);
      print('idComentario : ' + idComentario);
      FirebaseFirestore.instance
          .collection('comentarios')
          .doc(autor)
          .collection('comentarios')
          .doc(idComentario)
          .delete();
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    recuperarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.listaComentarios.length,
      separatorBuilder: (context, index) => Divider(
        height: 1.0,
        color: Colors.black,
        thickness: 1.0,
      ),
      itemBuilder: (context, index) {
        initializeDateFormatting('pt_BR');
        var formatador = DateFormat('d/M/y H:mm');
        String dataFormatada =
            formatador.format(widget.listaComentarios[index]['data'].toDate());

        return Container(
          padding: EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Text(
                  widget.listaComentarios[index]['titulo'],
                  maxLines: 3,
                  style: TextStyle(color: Colors.grey[200], fontSize: 14.0),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Conto(widget.listaComentarios[index]['conto'])));
                },
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                widget.listaComentarios[index]['texto'],
                style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    dataFormatada.toString(),
                    style: TextStyle(color: Color(0xffb34700), fontSize: 14.0),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.more_vert_outlined,
                            color: Color(0xffb34700),
                          ),
                          onPressed: () {
                            showDialog(
                                context: (context),
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Excluir comentario',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancelar')),
                                      FlatButton(
                                          onPressed: () {
                                            String idConto = widget.listaComentarios[index]['conto'];
                                            String idComentario = widget.listaComentarios[index].reference.id;

                                            excluirComentario(idConto, idComentario, index);
                                          },
                                          child: Text('Excluir')),
                                    ],
                                  );
                                });
                          }),
                    ],
                  ))
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
