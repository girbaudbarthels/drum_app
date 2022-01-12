import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AddSoundRepository {
  Future<String?> addSoundToMidiNote(
    String _midiNote,
  ) async {
    //Pick a file
    final result = await FilePicker.platform.pickFiles();
    //Get path of our device
    final databasesPath = await getDatabasesPath();
    //Add the midinote.db to the devicepath
    final path = join(databasesPath, '$_midiNote.db');

    Database db;

    if (result != null) {
      //The filepath of the chosen sound
      final soundPath = result.files.single.path;

      //Open the databse and create a table
      db = await openDatabase(path, version: 1, onCreate: _createDb);
      final queryExists = await db.query('Instrument');
      //Delete the contents of the table if its already filled
      if (queryExists.isNotEmpty) await db.delete('Instrument');
      //Insert the filepath and midinote into the table

      final instrument = {'midiNote': _midiNote, 'soundPath': soundPath};

      await db.insert(
        'Instrument',
        instrument,
      );

      return soundPath;
    } else {
      // User canceled the picker
      return '';
    }
  }

  //Create a database if it does not exist and add a table to it.
  Future _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE Instrument(midiNote TEXT, soundPath TEXT)');
  }

  Future<String> getSound(String _midiNote) async {
    Database db;

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, '$_midiNote.db');
    db = await openDatabase(path);
    final resultQuery = await db.query('Instrument');
    final soundPath = resultQuery.first['soundPath'];
    if (soundPath == null) return '';
    return soundPath as String;
  }
}
