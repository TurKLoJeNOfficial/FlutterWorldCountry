import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ulkeler/ulke.dart';

class UlkeDetay extends StatelessWidget {
  final Ulke _ulke;

  UlkeDetay(this._ulke);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text(
        _ulke.isim,
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_outlined,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 32,
        ),
        _buildBayrak(context),
        SizedBox(height: 24),
        _buildUlkeIsmi(),
        SizedBox(
          height: 40,
        ),
        _buildTumDetaylar()
      ],
    );
  }

  Widget _buildTumDetaylar(){
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Column(
        children: [
          _buildDetayRow("Ülke İsmi: ", _ulke.isim),
          _buildDetayRow("Başkent: ", _ulke.baskent),
          _buildDetayRow("Bölge: : ", _ulke.bolge),
          _buildDetayRow("Nüfus: ", _ulke.nufus.toString()),
          _buildDetayRow("Dil: : ", _ulke.dil),
        ],
      ),
    );
  }

  Widget _buildBayrak(BuildContext context) {
    return Image.network(
      _ulke.bayrak,
      width: MediaQuery.sizeOf(context).width / 2,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildUlkeIsmi() {
    return Text(
      _ulke.isim,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDetayRow(String baslik, String detay) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            baslik,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            detay,
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }
}
