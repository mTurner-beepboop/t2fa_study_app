import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

///Relate enum for objects
enum Objects {pendant, cube, card}

Objects? getEnumObject(String obj) {
  if (obj == "cube"){
    return Objects.cube;
  }
  if (obj == "pendant") {
    return Objects.pendant;
  }
  if (obj == "card") {
    return Objects.card;
  }
  return null;
}

String getStringObject(Objects? obj) {
  if (obj == Objects.cube){
    return "cube";
  }
  if (obj == Objects.pendant){
    return "pendant";
  }
  if (obj == Objects.card){
    return "card";
  }
  return "";
}

///Utility functions for local storage

///Returns the local path to internal app storage
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/init.txt');
}

///Simultaneously checks file exists and return the contents of the file (currently
///assuming file contains only object as most things will be stored in firebase, but
///this will likely change a bit in the future)
Future<String> getObject() async {
  try{
    final f = await _localFile;
    final contents = await f.readAsString();
    return contents;
  }
  catch (e) {
    return "None";
  }
}

///Create and write the object chosen to file
Future<File> writeObject(String obj) async {
  final f = await _localFile;
  return f.writeAsString(obj);
}