import 'dart:convert';
import 'package:exchangerate/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Exchange Rate",
      theme: ThemeData(
          primaryColor: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Currency> _data;
  String _base = "USD";
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _data = fetchAPI(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Exchange Rate",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                setState(() {
                  _base = value.toString();

                  _data = fetchAPI(http.Client());
                });
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("USD"),
                      value: "USD",
                    ),
                    PopupMenuItem(
                      child: Text("EUR"),
                      value: "EUR",
                    ),
                    PopupMenuItem(
                      child: Text("CAD"),
                      value: "CAD",
                    ),
                    PopupMenuItem(
                      child: Text("INR"),
                      value: "INR",
                    ),
                    PopupMenuItem(
                      child: Text("AUD"),
                      value: "AUD",
                    ),
                  ])
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Spacer(),
                Text(
                  "Base $_base",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                )
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: _data,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data.rates.length,
                            itemBuilder: (BuildContext context, int index) {
                              return rowView(
                                  context, snapshot.data.rates[index]);
                            })
                        : Center(
                            child: CupertinoActivityIndicator(),
                          );
                  }))
        ],
      ),
    );
  }

  Widget rowView(BuildContext context, MapEntry<String, dynamic> rate) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Icon(
            Icons.monetization_on,
            size: 45,
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(rate.key,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Text(
                  rate.value.toString(),
                  style: TextStyle(fontWeight: FontWeight.w700),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<Currency> fetchAPI(http.Client client) async {
    final responce =
        await client.get("https://api.exchangeratesapi.io/latest?base=$_base");
    final parceData = jsonDecode(responce.body).cast<String, dynamic>();
    return Currency.createJASON(parceData);
  }
}
