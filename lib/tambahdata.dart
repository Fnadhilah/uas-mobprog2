import 'package:flutter/material.dart';
import 'package:flutter_crud/homepage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({super.key});

  @override
  State<TambahData> createState() => _TambahData();
}

class _TambahData extends State<TambahData> {
  final formkey = GlobalKey<FormState>();
  TextEditingController judul = TextEditingController();
  TextEditingController mood = TextEditingController();
  TextEditingController catatan = TextEditingController();

  Future _simpan() async {
    final respone = await http.post(
        Uri.parse(
            'http://192.168.25.157/flutterapi/crudflutter/api/catatanku/create.php'),
        body: {
          "judul": judul.text,
          "mood": mood.text,
          "catatan": catatan.text,
        });

    if (respone.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Data"),
      ),
      body: Form(
          key: formkey,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: judul,
                  decoration: InputDecoration(
                    hintText: "Masukan judul",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Masukan judul";
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: mood,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Masukan mood kamu";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Masukan mood kamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: catatan,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Masukan catatanmu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Masukan catatanmu";
                    }
                  },
                  textInputAction: TextInputAction.newline,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        _simpan().then((value) {
                          if (value) {
                            final snackBar = SnackBar(
                                content: const Text("Data Berhasil Disimpan"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            final snackBar = SnackBar(
                                content: const Text("Data Gagal Disimpan"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false);
                      }
                    },
                    child: Text("Simpan"))
              ],
            ),
          )),
    );
  }
}
