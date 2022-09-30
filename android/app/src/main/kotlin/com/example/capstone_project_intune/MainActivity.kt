package com.example.capstone_project_intune

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    // Write a message to the database
    val database = Firebase.database
    val myRef = database.getReference("message")

    myRef.setValue("Hello, World!")
}
