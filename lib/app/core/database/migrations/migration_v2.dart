import 'package:sqflite/sqflite.dart';

import 'migration.dart';

class MigrationV2 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
      create table teste(
        id Integer
      )
''');
  }

  @override
  void update(Batch batch) {
    batch.execute('''
      create table teste(
        id Integer
      )
''');
  }
}
