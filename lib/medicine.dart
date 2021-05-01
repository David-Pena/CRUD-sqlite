class Medicine {
  int serial;
  String nombre;
  String laboratorio;
  String fecha;
  String tipo;

  Medicine(this.serial, this.nombre, this.laboratorio, this.fecha, this.tipo);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'serial': serial,
      'nombre': nombre,
      'laboratorio': laboratorio,
      'fecha': fecha,
      'tipo': tipo,
    };
    return map;
  }

  Medicine.fromMap(Map<String, dynamic> map) {
    serial = map['serial'];
    nombre = map['nombre'];
    laboratorio = map['laboratorio'];
    fecha = map['fecha'];
    tipo = map['tipo'];
  }
}
