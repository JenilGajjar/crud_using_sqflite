// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_database_app/database/database.dart';
import 'package:my_database_app/model/city_model.dart';

class AddStudent extends StatefulWidget {
  AddStudent(this.map, {Key? key}) : super(key: key);
  Map? map;

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  String title = 'Add Student';
  final nameController = TextEditingController();
  final rollNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int position = 0;
  bool _isSelected = true;
  late CityModel _ddSelectedValue;

  @override
  void initState() {
    if (widget.map != null) {
      nameController.text = widget.map!['StudentName'];
      rollNumberController.text = widget.map!['StudentRollNumber'].toString();
      title = 'Edit Student';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Valid Name';
                }
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: rollNumberController,
              decoration: InputDecoration(hintText: 'Roll number'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Valid Roll Number';
                }
              },
            ),
            SizedBox(height: 20),
            FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (_isSelected) {
                      _isSelected = false;
                      if(widget.map!=null){
                        position = getPosition(snapshot.data!);
                      }
                      _ddSelectedValue = snapshot.data![position];
                    }
                    return DropdownButton(
                      value: _ddSelectedValue,
                      items: snapshot.data!.map((e) {
                        return DropdownMenuItem(
                            value: e, child: Text(e.CityName));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _ddSelectedValue = value!;
                        });
                      },
                    );
                  } else {
                    return Text('no data');
                  }
                },
                future: _isSelected ? MyDatabase().getCities() : null),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.map != null) {
                      update(widget.map!['StudentID']).then((value) {
                        Navigator.pop(context);
                      });
                    } else {
                      insert().then((value) {
                        Navigator.pop(context);
                      });
                    }
                  }
                },
                child: Text(title.split(' ')[0]))
          ]),
        ),
      ),
    );
  }

  Future<int> insert() async {
    Map<String, Object?> map = {};
    map['StudentName'] = nameController.text;
    map['StudentRollNumber'] = int.parse(rollNumberController.text);
    map['CityID'] = 1;
    return await MyDatabase().insert(map);
  }

  Future<int> update(id) async {
    Map<String, Object?> map = {};
    map['StudentName'] = nameController.text;
    map['StudentRollNumber'] = int.parse(rollNumberController.text);
    map['CityID'] = _ddSelectedValue.CityID;

    return await MyDatabase().update(map, id);
  }
  int getPosition(list){
    for(int i=0;i<list.length;i++){
      if(widget.map!['CityName'] == list[i].CityName){
        return i;
      }
    }
    return 0;
  }
}
