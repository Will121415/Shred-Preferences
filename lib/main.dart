import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Example',
      debugShowCheckedModeBanner: false,
      home: SharedPreferencesExample(),
    );
  }
}

class SharedPreferencesExample extends StatefulWidget {
  SharedPreferencesExample({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SharedPreferencesExampleState();
}

class _SharedPreferencesExampleState extends State<SharedPreferencesExample> {
  Future<int> _counter; // numero que mostraremos en pantalla....

  //Metodo onPressed para aumentar el contador
  Future<void> _incrementCounter() async {
    //Obtener preferencias compartidas
    final prefs = await SharedPreferences.getInstance();
    final int counter =
        (prefs.getInt('contador') ?? 0) + 1; // Aumentar contador

    //Actualizar estado
    setState(() {
      _counter = _increment(prefs, counter);
    });
  }

  Future<int> _increment(SharedPreferences prefs, int counter) async {
    await prefs.setInt("contador", counter); // Guarda el numero en
    return counter;
  }

  //Metodo onPressed para limpiar los datos de la app
  Future<void> _removeCounter() async {
    final prefs = await SharedPreferences
        .getInstance(); //Obtener preferencias compartidas

    prefs.remove('contador'); // Remover los datos.

    setState(() {
      _counter = _counterInitial();
    });
  }

  // Estado inicial
  @override
  void initState() {
    super.initState();
    _counter = _counterInitial();
  }

  Future<int> _counterInitial() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getInt('contador') ?? 0); // El contador inicia en 0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SharedPreferences Example"),
      ),
      body: Center(
          child: FutureBuilder<int>(
              future: _counter,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                switch (snapshot.connectionState) {
                  // estado del Future _counter
                  case ConnectionState.waiting: // Esperando...
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Contador - Shared Preferences',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CircleAvatar(
                              child: Text(
                                '${snapshot.data}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Esto debería persistir en los reinicios.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }
                }
              })),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                child: Icon(Icons.highlight_remove),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: _removeCounter),
            ElevatedButton(
                child: Icon(Icons.add),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: _incrementCounter),
          ],
        )
      ],
    );
  }
}
