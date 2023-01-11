import 'migrations/migration.dart';
import 'migrations/migration_v1.dart';
import 'migrations/migration_v2.dart';
import 'migrations/migration_v3.dart';

class SqliteMigrationsFactory {
  List<Migration> getCreateMigrations() =>
      [MigrationV1(), MigrationV2(), MigrationV3()];
  List<Migration> getUpgradeMigrations(int version) {
    var migrations = <Migration>[];

    //Atual Version is 3
    //User version is 1, so to upgrade to 3 he needs to install version 2 e 3
    //User version is 2, to upgrade to 3 it needs to only install version 3, because it already have version 1 and 2
    //I know it because when it was on version 2 the if (version == 1{migrations.add(MigrationV2());}
    //if version is 1, then it must have all others updgrades avaliables because
    //yser doesnt have anything besides the first one database.
    if (version == 1) {
      migrations.add(MigrationV2());
      migrations.add(MigrationV3());
    }

    if (version == 2) {
      migrations.add(MigrationV3());
    }

    return migrations;
  }
}
