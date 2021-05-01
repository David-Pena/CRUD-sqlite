class Medicine {
  int serial;
  String name;
  String laboratory;
  String date;
  String type;

  Medicine(this.serial, this.name, this.laboratory, this.date, this.type);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'serial': serial,
      'name': name,
      'laboratory': laboratory,
      'date': date,
      'type': type,
    };
    return map;
  }

  Medicine.fromMap(Map<String, dynamic> map) {
    serial = map['serial'];
    name = map['nombre'];
    laboratory = map['laboratory'];
    date = map['date'];
    type = map['type'];
  }
}
