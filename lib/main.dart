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
      home: Tuning(),
    );
  }
}
/*
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
              }));},
            child: const Text('Login'),
          ),

          ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Tuning();
              }));
            },
            child: const Text('Tuning'),
          ),
        ],
      ),
    );
  }
}
*/
//Locked Features
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
          //Practice
          ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Practice();
              }));
            },
            child: const Text('Practice'),
          ),
          //Composition
          ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Composition();
              }));
            },
            child: const Text('Composition'),
          ),

          //Virtual Band
          ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const VirtualBand();
              }));
            },
            child: const Text('Virtual Band'),
          ),
        ],
      ),
    );
  }
}

//Nav Bar (Side Bar)
class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Center(
                child: Text(
                  'InTune',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),

          //Login
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Login/Register'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                //return const SignIn();
                return const Authentication();
              },),),},
          ),
          //Tuning
          ListTile(
            //leading: const Icon(Icons.home),
            title: const Text('Tuning'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Tuning();
              },),),},
          ),
          //Practice
          ListTile(
             leading: const Icon(Icons.lock),
            title: const Text('Practice'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Practice();
              },),),},
          ),
          //Composition
          ListTile(
             leading: const Icon(Icons.lock),
            title: const Text('Composition'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Composition();
              },),),},
          ),
          //Virtual Band
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Virtual Band'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const VirtualBand();
              },),),},
          ),
        ],
      ),
    );
  }
}

//Tuning Widget
class Tuning extends StatelessWidget {
  const Tuning({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Tuning'),
      ),
      body: const Center(
        child: Text('Tuning'),
      ),
    );
  }
}

//Practice Widget
class Practice extends StatelessWidget {
  const Practice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Practice'),
      ),
      body: const Center(
        child: Text('Practice'),
      ),
    );
  }
}

//Composition Widget
class Composition extends StatelessWidget {
  const Composition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text("Composition"),
      ),
      body: const Center(
        child: Text('Composition'),
      ),
    );
  }
}

//Virtual Band Widget
class VirtualBand extends StatelessWidget {
  const VirtualBand({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Virtual Band'),
      ),
      body: const Center(
        child: Text('Virtual Band'),
      ),
    );
  }
}

//Account Widget
class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Sign In/Sign Up'),
      ),
      body: const Center(
        child: Text('Sign In/Sign Up'),
      ),
    );
  }
}