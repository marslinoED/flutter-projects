import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? database;
String path = "series.db";
List<Map> seriesList = [];

Future<void> createDatabase() async {
  var databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, path);

  database = await openDatabase(
    dbPath,
    version: 1,
    onCreate: (db, version) async {
      print("DB Created");
      await db.execute(
        'CREATE TABLE series (id INTEGER PRIMARY KEY, title TEXT, currentindex INTEGER, image TEXT)',
      );
      print("Table Created");
    },
    onOpen: (db) async {
      print("DB Opened");
      seriesList = await getDataFromDatabase(db);
      print(seriesList);
    },
  );
}

Future<void> insertToDatabase({
  required String title,
  required int currentindex,
  String? image,
}) async {
  if (database == null) return;

  await database!.transaction((txn) async {
    int id = await txn.rawInsert(
      'INSERT INTO series (title, currentindex, image) VALUES(?, ?, ?)',
      [title, currentindex, image ?? 'Assets/temp.jpg'],
    );
    getDataFromDatabase(database!).then((data) {
      print(data);
    });
    print('Inserted $id successfully');
  }).catchError((error) {
    print("Error: Inserting, $error");
  });

  seriesList = await getDataFromDatabase(database!);
  print(seriesList);
}

Future<void> incrementIndex({required int id}) async {
  if (database == null) return;

  await database!.rawUpdate(
    'UPDATE series SET currentindex = currentindex + 1 WHERE id = ?',
    [id],
  );

  seriesList = await getDataFromDatabase(database!);
  print(seriesList);
}

Future<void> decrementIndex({required int id}) async {
  if (database == null) return;

  await database!.rawUpdate(
    'UPDATE series SET currentindex = CASE WHEN currentindex > 0 THEN currentindex - 1 ELSE 0 END WHERE id = ?',
    [id],
  );

  seriesList = await getDataFromDatabase(database!);
  print(seriesList);
}

Future<void> deleteData({required int id}) async {
  if (database == null) return;

  await database!.rawDelete(
    'DELETE FROM series WHERE id = ?',
    [id],
  );

  seriesList = await getDataFromDatabase(database!);
  print(seriesList);
}

Future<List<Map>> getDataFromDatabase(Database db) async {
  return await db.rawQuery('SELECT * FROM series'); 
}