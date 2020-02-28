import 'package:flutter/material.dart';
import 'package:exercise_app/dbhelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExerciseListPage(),
    );
  }
}

class ExerciseListPage extends StatefulWidget {
  @override
  ExerciseListPageState createState() => ExerciseListPageState();
}

class ExerciseListPageState extends State<ExerciseListPage> {
  final dbHelper = DBHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises')
      ),
      body: FutureBuilder<List<Exercise>>(
        future: dbHelper.allExercises(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data.map((ex) => ListTile(
              title: Text(ex.name),
              subtitle: Text(ex.desc())
            )).toList(),
          );
        },
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewExercisePage())
            );
          },
          child: Icon(Icons.add)
        )
    );
  }
}

class NewExercisePage extends StatefulWidget {
  @override
  NewExercisePageState createState() => NewExercisePageState();
}

class NewExercisePageState extends State<NewExercisePage> {
  final dbHelper = DBHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new exercise'),

      ),
      body: Column (
        children: [
          Container (
            padding: const EdgeInsets.all(32),
            child: TextField(
            ),
          ),
          RaisedButton(
            child: Text('Create'),
            onPressed: () {
              _insert();
              Navigator.pop(context);
              },
          ),
        ],
      ),
    );
  }

  void _insert() async {
    Exercise ex = Exercise('situp', Exercise.repeated, 10, 30);
    final id = await dbHelper.insertExercise(ex);
  }
}