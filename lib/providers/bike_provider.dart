import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bike.dart';
import '../models/component.dart';
import '../services/isar_service.dart';

final isarProvider = Provider<Future<Isar>>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [BikeSchema, ComponentSchema],
    directory: dir.path,
  );

  // Inseriscilo QUI, prima del return
  //await isar.writeTxn(() => isar.clear()); 
  //print("DATABASE RESETTATO CON SUCCESSO");

  return isar;

});

final isarServiceProvider = Provider((ref) => IsarService(ref.watch(isarProvider)));

final bikesProvider = StreamProvider<List<Bike>>((ref) {
  return ref.watch(isarServiceProvider).listenToBikes();
});

final componentsProvider = StreamProvider.family<List<Component>, int>((ref, bikeId) {
  return ref.watch(isarServiceProvider).listenToComponents(bikeId);
});