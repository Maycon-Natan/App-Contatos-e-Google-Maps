import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_final/models/pessoa.dart';

class PessoaPage extends StatefulWidget {
  final Pessoa pessoa;
  PessoaPage({this.pessoa});

  @override
  _PessoaPageState createState() => _PessoaPageState();
}

class _PessoaPageState extends State<PessoaPage> {
  final _nomeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _nomeFocus = FocusNode();

  bool editado = false;
  Pessoa _editaPessoa;
  File _imagem;

  Future _getImage() async {
    final imagem = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagem = imagem;
      if (_imagem == null) return;
      setState(() {
        _editaPessoa.imagem = _imagem.path;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.pessoa == null) {
      _editaPessoa = Pessoa(null, '', '', '', null);
    } else {
      _editaPessoa = Pessoa.fromMap(widget.pessoa.toMap());

      _nomeController.text = _editaPessoa.nome;
      _latitudeController.text = _editaPessoa.latitude.toString();
      _longitudeController.text = _editaPessoa.longitude.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title:
            Text(_editaPessoa.nome == '' ? 'Novo Contato' : _editaPessoa.nome),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_editaPessoa.nome != null &&
              _editaPessoa.nome.isNotEmpty &&
              _editaPessoa.latitude != null &&
              _editaPessoa.latitude.isNotEmpty &&
              _editaPessoa.longitude != null &&
              _editaPessoa.longitude.isNotEmpty) {
            Navigator.pop(context, _editaPessoa);
          } else {
            _exibeAviso();
            FocusScope.of(context).requestFocus(_nomeFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _editaPessoa.imagem != null
                          ? FileImage(File(_editaPessoa.imagem))
                          : AssetImage('images/pessoa.png')),
                ),
              ),
              onTap: () {
                _getImage();
              },
            ),
            TextField(
              controller: _nomeController,
              focusNode: _nomeFocus,
              decoration: InputDecoration(labelText: 'Nome'),
              onChanged: (text) {
                editado = true;
                setState(() {
                  _editaPessoa.nome = text;
                });
              },
            ),
            TextField(
              controller: _latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
              onChanged: (text) {
                editado = true;
                setState(
                  () {
                    _editaPessoa.latitude = text;
                  },
                );
              },
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
              onChanged: (text) {
                editado = true;
                setState(
                  () {
                    _editaPessoa.longitude = text;
                  },
                );
              },
              keyboardType: TextInputType.number,
            )
          ],
        ),
      ),
    );
  }

  void _exibeAviso() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Informações'),
          content: new Text('Verificar de adicionar todas as informações'),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text('Fechar'))
          ],
        );
      },
    );
  }
}
