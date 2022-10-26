import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project_intune/ui/updateProfile.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class PracticeUI extends StatefulWidget {

  const PracticeUI({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<PracticeUI> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: _photo != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _photo!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

// class PracticeUI extends StatefulWidget {

//   @override
//   _PracticeUIState createState() => _PracticeUIState();
// }
//
// class _PracticeUIState extends State<PracticeUI> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
//   String? _fileName;
//   String? _saveAsFileName;
//   List<PlatformFile>? _paths;
//   String? _directoryPath;
//   String? _extension;
//   bool _isLoading = false;
//   bool _userAborted = false;
//   bool _multiPick = false;
//   FileType _pickingType = FileType.any;
//   TextEditingController _controller = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() => _extension = _controller.text);
//   }
//
//   void _pickFiles() async {
//     _resetState();
//     try {
//       _directoryPath = null;
//       _paths = (await FilePicker.platform.pickFiles(
//         type: _pickingType,
//         allowMultiple: _multiPick,
//         onFileLoading: (FilePickerStatus status) => print(status),
//         allowedExtensions: (_extension?.isNotEmpty ?? false)
//             ? _extension?.replaceAll(' ', '').split(',')
//             : null,
//       ))
//           ?.files;
//     } on PlatformException catch (e) {
//       _logException('Unsupported operation' + e.toString());
//     } catch (e) {
//       _logException(e.toString());
//     }
//     if (!mounted) return;
//     setState(() {
//       _isLoading = false;
//       _fileName =
//       _paths != null ? _paths!.map((e) => e.name).toString() : '...';
//       _userAborted = _paths == null;
//     });
//   }
//
//   void _clearCachedFiles() async {
//     _resetState();
//     try {
//       bool? result = await FilePicker.platform.clearTemporaryFiles();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: result! ? Colors.green : Colors.red,
//           content: Text((result
//               ? 'Temporary files removed with success.'
//               : 'Failed to clean temporary files')),
//         ),
//       );
//     } on PlatformException catch (e) {
//       _logException('Unsupported operation' + e.toString());
//     } catch (e) {
//       _logException(e.toString());
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _selectFolder() async {
//     _resetState();
//     try {
//       String? path = await FilePicker.platform.getDirectoryPath();
//       setState(() {
//         _directoryPath = path;
//         _userAborted = path == null;
//       });
//     } on PlatformException catch (e) {
//       _logException('Unsupported operation' + e.toString());
//     } catch (e) {
//       _logException(e.toString());
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _saveFile() async {
//     _resetState();
//     try {
//       String? fileName = await FilePicker.platform.saveFile(
//         allowedExtensions: (_extension?.isNotEmpty ?? false)
//             ? _extension?.replaceAll(' ', '').split(',')
//             : null,
//         type: _pickingType,
//       );
//       setState(() {
//         _saveAsFileName = fileName;
//         _userAborted = fileName == null;
//       });
//     } on PlatformException catch (e) {
//       _logException('Unsupported operation' + e.toString());
//     } catch (e) {
//       _logException(e.toString());
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _logException(String message) {
//     print(message);
//     _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
//     _scaffoldMessengerKey.currentState?.showSnackBar(
//       SnackBar(
//         content: Text(message),
//       ),
//     );
//   }
//
//   void _resetState() {
//     if (!mounted) {
//       return;
//     }
//     setState(() {
//       _isLoading = true;
//       _directoryPath = null;
//       _fileName = null;
//       _paths = null;
//       _saveAsFileName = null;
//       _userAborted = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       scaffoldMessengerKey: _scaffoldMessengerKey,
//       home: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: const Text('File Picker example app'),
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 20.0),
//                     child: DropdownButton<FileType>(
//                         hint: const Text('LOAD PATH FROM'),
//                         value: _pickingType,
//                         items: FileType.values
//                             .map((fileType) => DropdownMenuItem<FileType>(
//                           child: Text(fileType.toString()),
//                           value: fileType,
//                         ))
//                             .toList(),
//                         onChanged: (value) => setState(() {
//                           _pickingType = value!;
//                           if (_pickingType != FileType.custom) {
//                             _controller.text = _extension = '';
//                           }
//                         })),
//                   ),
//                   ConstrainedBox(
//                     constraints: const BoxConstraints.tightFor(width: 100.0),
//                     child: _pickingType == FileType.custom
//                         ? TextFormField(
//                       maxLength: 15,
//                       autovalidateMode: AutovalidateMode.always,
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         labelText: 'File extension',
//                       ),
//                       keyboardType: TextInputType.text,
//                       textCapitalization: TextCapitalization.none,
//                     )
//                         : const SizedBox(),
//                   ),
//                   ConstrainedBox(
//                     constraints: const BoxConstraints.tightFor(width: 200.0),
//                     child: SwitchListTile.adaptive(
//                       title: Text(
//                         'Pick multiple files',
//                         textAlign: TextAlign.right,
//                       ),
//                       onChanged: (bool value) =>
//                           setState(() => _multiPick = value),
//                       value: _multiPick,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
//                     child: Column(
//                       children: <Widget>[
//                         ElevatedButton(
//                           onPressed: () => _pickFiles(),
//                           child: Text(_multiPick ? 'Pick files' : 'Pick file'),
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () => _selectFolder(),
//                           child: const Text('Pick folder'),
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () => _saveFile(),
//                           child: const Text('Save file'),
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () => _clearCachedFiles(),
//                           child: const Text('Clear temporary files'),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Builder(
//                     builder: (BuildContext context) => _isLoading
//                         ? Padding(
//                       padding: const EdgeInsets.only(bottom: 10.0),
//                       child: const CircularProgressIndicator(),
//                     )
//                         : _userAborted
//                         ? Padding(
//                       padding: const EdgeInsets.only(bottom: 10.0),
//                       child: const Text(
//                         'User has aborted the dialog',
//                       ),
//                     )
//                         : _directoryPath != null
//                         ? ListTile(
//                       title: const Text('Directory path'),
//                       subtitle: Text(_directoryPath!),
//                     )
//                         : _paths != null
//                         ? Container(
//                       padding:
//                       const EdgeInsets.only(bottom: 30.0),
//                       height:
//                       MediaQuery.of(context).size.height *
//                           0.50,
//                       child: Scrollbar(
//                           child: ListView.separated(
//                             itemCount: _paths != null &&
//                                 _paths!.isNotEmpty
//                                 ? _paths!.length
//                                 : 1,
//                             itemBuilder: (BuildContext context,
//                                 int index) {
//                               final bool isMultiPath =
//                                   _paths != null &&
//                                       _paths!.isNotEmpty;
//                               final String name =
//                                   'File $index: ' +
//                                       (isMultiPath
//                                           ? _paths!
//                                           .map((e) => e.name)
//                                           .toList()[index]
//                                           : _fileName ?? '...');
//                               final path = kIsWeb
//                                   ? null
//                                   : _paths!
//                                   .map((e) => e.path)
//                                   .toList()[index]
//                                   .toString();
//
//                               return ListTile(
//                                 title: Text(
//                                   name,
//                                 ),
//                                 subtitle: Text(path ?? ''),
//                               );
//                             },
//                             separatorBuilder:
//                                 (BuildContext context,
//                                 int index) =>
//                             const Divider(),
//                           )),
//                     )
//                         : _saveAsFileName != null
//                         ? ListTile(
//                       title: const Text('Save file'),
//                       subtitle: Text(_saveAsFileName!),
//                     )
//                         : const SizedBox(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }