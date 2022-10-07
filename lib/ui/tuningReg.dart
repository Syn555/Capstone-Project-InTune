import 'package:flutter/material.dart';
import '../main.dart';


// List of every note in an octave
// Implement dropdown button for different instruments for ease of use?
const List<String> notes = <String>['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

class TuningReg extends StatelessWidget {
  const TuningReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawerReg(),
      appBar: AppBar(
        title: const Text('Tuning'),
      ),
      body:  Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
          const[
              Text('Tuning FROM UI FOLDER'),
              NoteSelectionDropdown(),
          ]
        ),
      ),
    );
  }
}

// Create Dropdown
class NoteSelectionDropdown extends StatefulWidget {
  const NoteSelectionDropdown({super.key});

  @override
  State<NoteSelectionDropdown> createState() => _NoteSelectionDropdownState();
}

// Create Different States for NoteSelectionDropdown
class _NoteSelectionDropdownState extends State<NoteSelectionDropdown>{
  String dropdownValue = notes.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down_circle_sharp),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? value) {
          // Called when user selects note
          setState(() {
            dropdownValue = value!;

          });
        },

        items: notes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
    );
  }
}

// */