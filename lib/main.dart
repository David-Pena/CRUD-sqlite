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
  MyHomePage();

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  // Controllers to TextFormFields
  TextEditingController controllerNAME = TextEditingController();
  TextEditingController controllerLAB = TextEditingController();
  // List of Objects
  Future<List<Medicine>> medicines;
  // Default value from a datepicker from flutter API
  DateTime currentDate = DateTime.now();
  // Vars to save values given by inputs
  String name;
  String laboratory;
  String date;
  String type;
  num optionType;

  int curUserId;

  final formKey = new GlobalKey<FormState>();
  var aide;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    aide = DataBase();
    isUpdating = false;
    refresh();
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
        date = "${currentDate.toLocal()}".split(' ')[0];
      });
  }

  refresh() {
    setState(() {
      medicines = aide.getMedicines();
    });
  }

  clear() {
    controllerNAME.text = '';
    controllerLAB.text = '';
  }

  getType() {
    return optionType == 1 ? 'Analgésico' : 'Antibiótico';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Medicine m = Medicine(curUserId, name, laboratory, date, getType());
        aide.update(m);
        setState(() {
          isUpdating = false;
        });
      } else {
        Medicine m = Medicine(null, name, laboratory, date, getType());
        aide.save(m);
      }
      clear();
      refresh();
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
                              groupValue: optionType,
                              onChanged: (value) {
                                setState(() {
                                  optionType = value;
                                });
                              }),
                          Text("Analgésico",
                              style: TextStyle(
                                  fontSize: 10, fontFamily: 'Georgia')),
                        ]),
                        Column(children: [
                          Radio(
                              value: 2,
                              groupValue: optionType,
                              onChanged: (value) {
                                setState(() {
                                  optionType = value;
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
                              clear();
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
                              child: Text(medicine.name,
                                  style: TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center)), onTap: () {
                        setState(() {
                          isUpdating = true;
                          curUserId = medicine.serial;
                        });
                        controllerNAME.text = medicine.name;
                        controllerLAB.text = medicine.laboratory;
                        date = "${currentDate.toLocal()}".split(' ')[0];
                        type = getType();
                      }),
                      DataCell(
                        Center(
                            child: Text(medicine.laboratory,
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center)),
                      ),
                      DataCell(
                        Center(
                            child: Text(medicine.date,
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center)),
                      ),
                      DataCell(
                        Center(
                            child: Text(medicine.type,
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center)),
                      ),
                      DataCell(IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            aide.delete(medicine.serial);
                            refresh();
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
