import 'package:flutter/material.dart';
import 'medicine.dart';
import 'dart:async';
import 'database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App - Parcial 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controllerNAME = TextEditingController();
  TextEditingController controllerLAB = TextEditingController();
  Future<List<Medicine>> medicines;
  DateTime currentDate = DateTime.now();
  String nombre;
  String laboratorio;
  String fecha;
  String tipo;
  num option;

  int curUserId;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DB();
    isUpdating = false;
    refreshList();
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2036));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        fecha = "${currentDate.toLocal()}".split(' ')[0];
      });
  }

  refreshList() {
    setState(() {
      medicines = dbHelper.getMedicines();
    });
  }

  clearFields() {
    controllerNAME.text = '';
    controllerLAB.text = '';
  }

  getType() {
    if (option == 1) {
      tipo = 'Analgésico';
    } else if (option == 2) {
      tipo = 'Antibiótico';
    }

    return tipo;
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Medicine m = Medicine(curUserId, nombre, laboratorio, fecha, getType());
        dbHelper.update(m);
        setState(() {
          isUpdating = false;
        });
      } else {
        Medicine m = Medicine(null, nombre, laboratorio, fecha, getType());
        dbHelper.save(m);
      }
      clearFields();
      refreshList();
    }
  }

  form() {
    return Form(
        key: formKey,
        child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  TextFormField(
                    controller: controllerNAME,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(fontFamily: 'Georgia', fontSize: 15),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(
                        Icons.medical_services_outlined,
                        color: Colors.orange,
                      ),
                      contentPadding: EdgeInsets.all(2),
                    ),
                    validator: (val) =>
                        val.length == 0 ? 'Ingrese Nombre' : null,
                    onSaved: (val) => nombre = val,
                  ),
                  TextFormField(
                    controller: controllerLAB,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontFamily: 'Georgia'),
                    decoration: InputDecoration(
                      labelText: 'Laboratorio',
                      prefixIcon: Icon(
                        Icons.location_city_outlined,
                        color: Colors.orange,
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    validator: (val) =>
                        val.length == 0 ? 'Ingrese Laboratorio' : null,
                    onSaved: (val) => laboratorio = val,
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("${currentDate.toLocal()}".split(' ')[0],
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Georgia',
                              fontWeight: FontWeight.bold)),
                      ElevatedButton(
                          onPressed: () => pickDate(context),
                          child: Text('Seleccionar fecha'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.orange),
                          )),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Radio(
                              value: 1,
                              groupValue: option,
                              onChanged: (value) {
                                setState(() {
                                  option = value;
                                });
                              }),
                          Text("Analgésico",
                              style: TextStyle(
                                  fontSize: 10, fontFamily: 'Georgia')),
                        ]),
                        Column(children: [
                          Radio(
                              value: 2,
                              groupValue: option,
                              onChanged: (value) {
                                setState(() {
                                  option = value;
                                });
                              }),
                          Text("Antibiótico",
                              style: TextStyle(
                                  fontSize: 10, fontFamily: 'Georgia')),
                        ]),
                      ]),
                  Padding(padding: EdgeInsets.all(5)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: validate,
                            child: Text(isUpdating ? 'Actualizar' : 'Agregar'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isUpdating = false;
                              });
                              clearFields();
                            },
                            child: Text('Cancelar'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                            )),
                      ])
                ])));
  }

  SingleChildScrollView dataTable(List<Medicine> medicines) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Center(
                      child: Text('NOMBRE',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center)),
                ),
                DataColumn(
                  label: Center(
                      child: Text('LABORATORIO',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center)),
                ),
                DataColumn(
                  label: Center(
                      child: Text('FECHA',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center)),
                ),
                DataColumn(
                  label: Center(
                      child: Text('TIPO',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center)),
                ),
                DataColumn(
                  label: Center(
                      child: Text('DELETE',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center)),
                ),
              ],
              rows: medicines
                  .map(
                    (medicine) => DataRow(cells: [
                      DataCell(
                          Center(
                              child: Text(medicine.nombre,
                                  style: TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center)), onTap: () {
                        setState(() {
                          isUpdating = true;
                          curUserId = medicine.serial;
                        });
                        controllerNAME.text = medicine.nombre;
                        controllerLAB.text = medicine.laboratorio;
                        fecha = "${currentDate.toLocal()}".split(' ')[0];
                        tipo = getType();
                      }),
                      DataCell(
                        Center(
                            child: Text(medicine.laboratorio,
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center)),
                      ),
                      DataCell(
                        Center(
                            child: Text(medicine.fecha,
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center)),
                      ),
                      DataCell(
                        Center(
                            child: Text(medicine.tipo,
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center)),
                      ),
                      DataCell(IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            dbHelper.delete(medicine.serial);
                            refreshList();
                          })),
                    ]),
                  )
                  .toList(),
            )));
  }

  list() {
    return Expanded(
        child: FutureBuilder(
            future: medicines,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return dataTable(snapshot.data);
              }

              if (null == snapshot.data || snapshot.data.length == 0) {
                return Text("No data found");
              }

              return CircularProgressIndicator();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Sistema de Registro'),
        ),
        body: new Container(
            child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        )));
  }
}
