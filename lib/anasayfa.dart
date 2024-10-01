import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulkeler/favoriler.dart';
import 'package:ulkeler/ortakliste.dart';
import 'package:ulkeler/ulke.dart';
import 'package:http/http.dart' as http;
import 'package:ulkeler/ulkedetay.dart';

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final String _apiUrl =
      "https://restcountries.com/v3.1/all?fields=name,flags,cca2,capital,region,languages,population";

  List<Ulke> _butunUlkeler = [];

  List<String> _favoriUlkeKodlari = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _favorileriCihazHafizasindanCek().then((value) {
        _ulkeleriInternettenCek();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Tüm Ülkeler",
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
      centerTitle: true,
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          icon: Icon(Icons.favorite,color: Colors.red,),
          onPressed: (){
            _favorilerSayfasiniAc(context);
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return _butunUlkeler.isEmpty
        ? Center(child: CircularProgressIndicator())
        :OrtakListe(_butunUlkeler, _favoriUlkeKodlari);
  }



  void _ulkeleriInternettenCek() async {
    Uri uri = Uri.parse(_apiUrl);
    http.Response response = await http.get(uri);

    List<dynamic> parsedResponse = jsonDecode(response.body);

    for (int i = 0; i < parsedResponse.length; i++) {
      Map<String, dynamic> ulkeMap = parsedResponse[i];
      Ulke ulke = Ulke.fromMap(ulkeMap);
      _butunUlkeler.add(ulke);
    }
    setState(() {});
  }

  void _ulkeTiklandi(BuildContext context, Ulke ulke) {
    MaterialPageRoute sayfaYolu = MaterialPageRoute(builder: (context) {
      return UlkeDetay(ulke);
    });
    Navigator.push(context, sayfaYolu);
  }

  void _favoriTiklandi(Ulke ulke) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_favoriUlkeKodlari.contains(ulke.ulkeKodu)) {
      _favoriUlkeKodlari.remove(ulke.ulkeKodu);
    } else {
      _favoriUlkeKodlari.add(ulke.ulkeKodu);
    }

    await prefs.setStringList("favoriler", _favoriUlkeKodlari);

    setState(() {});
  }

  Future<void> _favorileriCihazHafizasindanCek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? favoriler = prefs.getStringList("favoriler");

    if (favoriler != null) {
      for (String ulkeKodu in favoriler) {
        _favoriUlkeKodlari.add(ulkeKodu);
      }

      setState(() {});
    }
  }

  void _favorilerSayfasiniAc(BuildContext context) {
    MaterialPageRoute sayfaYolu = MaterialPageRoute(builder: (context) {
      return Favoriler(_butunUlkeler,_favoriUlkeKodlari);
    });
    Navigator.push(context, sayfaYolu);
  }
}
