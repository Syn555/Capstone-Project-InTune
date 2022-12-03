import 'package:mockito/annotations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:capstone_project_intune/ui/updateProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth{}
class MockFirebaseUser extends Mock implements FirebaseUser{}
class MockAuthResults extends Mock implements AuthResult{}

void main(){
  MockFirebaseAuth auth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> user = BehaviorSubject<MockFirebaseUser>();
  UserRepository repo = UserRepository.instance(auth: auth);

  group("User Tests", (){
    test("Sign in with email and password", () async {

    });

    test("Sign out", (){

    });
  });
}

