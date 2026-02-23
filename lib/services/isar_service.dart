import 'package:isar/isar.dart';
import '../models/bike.dart';
import '../models/component.dart';


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
}
