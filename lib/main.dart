import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'ui/authentication.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'InTune',
      home: MyHomePage(title: 'InTune'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Authentication();;
              }));
            },
            child: const Text('Login'),
          ),

          ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Tuning(title: 'Tuning');
              }));
            },
            child: const Text('Tuning'),
          ),
        ],
      ),
    );
  }
}


class Tuning extends StatelessWidget {
  const Tuning({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Home'),
        ),
      ),
    );
  }
}


class LockedFeatures extends StatelessWidget {
  const LockedFeatures({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Comp(title: 'Comp');
              }));
            },
            child: const Text('Comp'),
          ),

          ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Int(title: 'Int');
              }));
            },
            child: const Text('Int'),
          ),
        ],
      ),
    );
  }
}

class Comp extends StatelessWidget {
  const Comp({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back to LockedFeatures'),
        ),
      ),
    );
  }
}

class Int extends StatelessWidget {
  const Int({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back to LockedFeatures'),
        ),
      ),
    );
  }
}