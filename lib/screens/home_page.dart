// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_database_app/alerts/delete_alert.dart';
import 'package:my_database_app/database/database.dart';
import 'package:my_database_app/screens/add_page.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('crud app')),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigateToAddStudent();
          },
          label: Text('Add Student')),
      body: FutureBuilder(
        builder: (context, snapshot1) {
          if (snapshot1.hasData) {
            return FutureBuilder(
                future: MyDatabase().getStudents(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var student = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            title: Text(student['StudentName'].toString()),
                            subtitle:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(student['StudentRollNumber'].toString()),
                                    Text(student['CityName'].toString()),

                                  ],
                                ),
                            onTap: () {
                              navigateToAddStudent(map: student);
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                final res = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DeleteAlert();
                                    });
                                if (res == true) {
                                  delete(student['StudentID']).then((value) {
                                    setState(() {});
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          } else {
            return Center(child: Text('No data found'));
          }
        },
        future: MyDatabase().copyPasteAssetFileToRoot(),
      ),
    );
  }

  void navigateToAddStudent({map}) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return AddStudent(map);
      },
    )).then((value) {
      setState(() {});
    });
  }

  Future<int> delete(id) async {
    return await MyDatabase().delete(id);
  }
}
