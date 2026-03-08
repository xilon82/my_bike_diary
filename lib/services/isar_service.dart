import 'package:isar/isar.dart';
import '../models/bike.dart';
import '../models/component.dart';
// Nuovi import per l'export
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class IsarService {
  final Future<Isar> db;

  IsarService(this.db);

  // --- BICI ---
  Stream<List<Bike>> listenToBikes() async* {
    final isar = await db;
    yield* isar.bikes.where().watch(fireImmediately: true);
  }

  Future<void> saveBike(Bike bike) async {
    final isar = await db;
    await isar.writeTxn(() => isar.bikes.put(bike));
  }

  Future<void> deleteBike(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      // Cancella anche i componenti figli
      await isar.components.filter().bike((q) => q.idEqualTo(id)).deleteAll();
      await isar.bikes.delete(id);
    });
  }

  // --- COMPONENTI ---
  Stream<List<Component>> listenToComponents(int bikeId) async* {
    final isar = await db;
    yield* isar.components
        .filter()
        .bike((q) => q.idEqualTo(bikeId))
        .watch(fireImmediately: true);
  }

  Future<void> saveComponent(Component component) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.components.put(component);
      await component.bike.save();
    });
  }

  Future<void> deleteComponent(int id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.components.delete(id));
  }

  // Ascolta gli interventi di una specifica bici
  Stream<List<ServiceHistory>> listenToServiceHistory(int bikeId) async* {
    final isar = await db;
    yield* isar.serviceHistorys
        .filter()
        .bike((q) => q.idEqualTo(bikeId))
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  // Salva o aggiorna
  Future<void> saveServiceHistory(ServiceHistory history) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.serviceHistorys.put(history);
      await history.bike.save();
    });
  }

  // Cancella
  Future<void> deleteServiceHistory(int id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.serviceHistorys.delete(id));
  }

  // Salva o aggiorna un setup
  Future<void> saveBikeSetup(BikeSetup setup) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.bikeSetups.put(setup);
      await setup.bike.save();
    });
  }

  // Recupera i setup di una specifica bici
  Stream<List<BikeSetup>> getBikeSetups(int bikeId) async* {
    final isar = await db;
    yield* isar.bikeSetups
        .filter()
        .bike((q) => q.idEqualTo(bikeId))
        .watch(fireImmediately: true);
  }

  // Elimina un setup
  Future<void> deleteBikeSetup(int id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.bikeSetups.delete(id));
  }

  // --- EXPORT DATI ---
  Future<void> exportFullBackup() async {
    final isar = await db;
    final allBikes = await isar.bikes.where().findAll();

    List<Map<String, dynamic>> exportData = [];

    for (var bike in allBikes) {
      await bike.components.load();
      await bike.serviceHistory.load();

      final setups = await isar.bikeSetups
          .filter()
          .bike((q) => q.idEqualTo(bike.id))
          .findAll();

      exportData.add({
        ...bike.toJson(),
        'components': bike.components.map((c) => c.toJson()).toList(),
        'serviceHistory': bike.serviceHistory.map((s) => s.toJson()).toList(),
        'setups': setups.map((st) => st.toJson()).toList(),
      });
    }

    final Map<String, dynamic> fullBackup = {
      'metadata': {
        'exportDate': DateTime.now().toIso8601String(),
        'schemaVersion': 1,
        'appName': 'My Bike Diary',
      },
      'bikes': exportData,
    };

    final String jsonString = jsonEncode(fullBackup);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/bike_diary_backup.json');
    await file.writeAsString(jsonString);

    await Share.shareXFiles([XFile(file.path)], text: 'Backup My Bike Diary');
  }
}
