

import 'package:capstone_project_intune/ui/profile.dart';
import 'package:capstone_project_intune/ui/tuningReg.dart';
import 'package:capstone_project_intune/ui/updateProfile.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() async{

 WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  // Set Up Mock Firebase Authentication

  final googleSignIn = MockGoogleSignIn();
  final signInAccount = await googleSignIn.signIn();
  final googleAuth = await signInAccount!.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
  );

  final user = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'pls@testthisapp.com',
  );

  final auth = MockFirebaseAuth(mockUser: user);
  final result = await auth.signInWithCredential(credential);

  // Set Up Mock Firestore

  final database = FakeFirebaseFirestore();
  // firestoreInstance.collection(rooms)

  /* await instance.collection('users').add({
    'username': 'Bob',
  });
  final snapshot = await instance.collection('users').get();
  print(snapshot.docs.length); // 1
  print(snapshot.docs.first.get('username')); // 'Bob'
  print(instance.dump()); */

  // Set Up Mock Firebase Storage

  final storage = MockFirebaseStorage();

  // Might need to add stuff


  // Initialize App
  Firebase.initializeApp();

  test("Open Profile to view/update email and password", () {

    final profile = UpdateProfile();
    final account = profile.createState();
    final email = find.text('pls@testthisapp.com');


    expect(email, findsOneWidget);
  });

 test("Update Email", () {

   final profile = UpdateProfile();
   final account = profile.createState();
   account.changeEmail();
   final status = find.text("Email has changed ... Login again");

   // await tester.pumpWidget(const MaterialApp(home: Profile()));
   // await tester.tap(button);
   // await tester.pump();

   expect(status, findsOneWidget);
 });

 test("Update Password", () {

   final profile = UpdateProfile();
   final account = profile.createState();
   account.changePassword();
   final status = find.text("Password has changed ... Login again");

   // await tester.pumpWidget(const MaterialApp(home: Profile()));
   // await tester.tap(button);
   // await tester.pump();

   expect(status, findsOneWidget);
 });

  
}