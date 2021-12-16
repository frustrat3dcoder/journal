import 'dart:io';

import 'package:flutter/material.dart';
import 'package:journal/models/journal.dart';
import 'package:path_provider/path_provider.dart'; // Filesystem locations import 'dart:io'; // Used by File
import 'dart:convert'; // Used by json

class DatabaseFileRoutines {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/local_persistence.json');
  }

  Future<String> readJournals() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        debugPrint("File does not Exist: ${file.absolute}");
        await writeJournals('{"journals": []}');
      }
// Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      debugPrint("error readJournals: $e");
      return "";
    }
  }

  Future<File> writeJournals(String json) async {
    final file = await _localFile;
// Write the file
    return file.writeAsString(json);
  }

  Database databaseFromJson(String str) {
    final dataFromJson = json.decode(str);
    return Database.fromJson(dataFromJson);
  }

// To save and parse to JSON Data - databaseToJson(jsonString);
  String databaseToJson(Database data) {
    final dataToJson = data.toJson();
    return json.encode(dataToJson);
  }
}

class Database {
  List<Journal> journal;
  Database({
    required this.journal,
  });

  factory Database.fromJson(Map<String, dynamic> json) => Database(journal: []
      // journal: List<Journal>.from(
      //     json["journals"].map((x) => Journal.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        // "journals": List<dynamic>.from(journal.map((x) => x.toJson())),
      };
}
