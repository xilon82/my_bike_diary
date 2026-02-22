import 'package:isar/isar.dart';
import 'bike.dart';

part 'component.g.dart';

@collection
class Component {
  Id id = Isar.autoIncrement;
  late String name;
  int? maintenanceIntervalDays; 
  DateTime lastMaintenanceDate = DateTime.now();
  
  final bike = IsarLink<Bike>();

  // Helper per sapere se è scaduta la manutenzione
  bool get isMaintenanceDue {
    if (maintenanceIntervalDays == null) return false;
    final dueDate = lastMaintenanceDate.add(Duration(days: maintenanceIntervalDays!));
    return DateTime.now().isAfter(dueDate);
  }
}