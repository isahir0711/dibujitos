// import 'dart:io';

// import 'package:path_provider/path_provider.dart';

// class LocalStorageService {
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();

//     return directory.path;
//   }

//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/counter.txt');
//   }

//   Future<File> writeCounter(List<) async {
//     final file = await _localFile;

//     // Write the file
//     return file.writeAsBytes(bytes);
//   }
// }
