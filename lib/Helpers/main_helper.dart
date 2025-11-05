import 'dart:io';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

var _logger = Logger();

class MainHelper {
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) {
      print("this only works on android ATM");
    }

    final hasStoragePermission = await Permission.manageExternalStorage.isGranted;
    _logger.d((hasStoragePermission));

    // bool isAndroid11OrAbove = await _isAndroid11OrAbove();
    // print(isAndroid11OrAbove);
    // if (!isAndroid11OrAbove) {
    //   final hasStoragePermission = await Permission.manageExternalStorage.isGranted;
    //   if (!hasStoragePermission) {
    //     var res = await Permission.manageExternalStorage.request();
    //     if (res.isPermanentlyDenied) {
    //       openAppSettings();
    //       return false;
    //     }

    //     return res.isGranted;
    //   }
    // }

    // print("above");
    // final hasExternalPermission = await Permission.manageExternalStorage.isGranted;
    // _logger.d(await Permission.storage.isGranted);
    // _logger.d(await Permission.accessMediaLocation);
    // _logger.d(await Permission.manageExternalStorage);

    return false;
    // if (!hasExternalPermission) {
    //   await Permission.manageExternalStorage.request();
    // }
  }

  // static Future<bool> _isAndroid11OrAbove() async {
  //   return (await Permission.manageExternalStorage.isGranted) || Platform.version.contains('API 30');
  // }
}
