import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud/editdata.dart';
import 'package:flutter_crud/tambahdata.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listdata = [];
  bool _isloading = true;

  Future _getdata() async {
    try {
      final respone = await http.get(Uri.parse(
          'http://192.168.25.157/flutterapi/crudflutter/api/catatanku/read.php'));
      if (respone.statusCode == 200) {
        //print(respone.body);
        final data = jsonDecode(respone.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _delete(String id) async {
    try {
      final respone = await http.post(
          Uri.parse(
              'http://192.168.25.157/flutterapi/crudflutter/api/catatanku/delete.php'),
          body: {
            "judul": id,
          });
      if (respone.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    //print(_listdata);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Catatanku")),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: _isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0),
                itemCount: _listdata.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditData(
                                  ListData: {
                                    "id": _listdata[index]["id"],
                                    "judul": _listdata[index]["judul"],
                                    "mood": _listdata[index]["mood"],
                                    "catatan": _listdata[index]["catatan"],
                                  },
                                ),
                              ));
                        },
                        child: ListTile(
                          title: Text(_listdata[index]['mood']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_listdata[index]['judul']),
                              Text(_listdata[index]['catatan']),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      content: Text("Hapus catatan ini?"),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              _delete(_listdata[index]['judul'])
                                                  .then((value) {
                                                if (value) {
                                                  final snackBar = SnackBar(
                                                      content: const Text(
                                                          "Data Berhasil di Hapus"));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                } else {
                                                  final snackBar = SnackBar(
                                                      content: const Text(
                                                          "Data Gagal di Hapus"));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              });
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(),
                                                  ),
                                                  (route) => false);
                                            },
                                            child: Text("Ya")),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Tidak"))
                                      ],
                                    );
                                  }));
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TambahData(),
              ));
        },
      ),
    );
  }
}
