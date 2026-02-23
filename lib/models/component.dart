import 'package:isar/isar.dart';
import 'bike.dart';

part 'component.g.dart';

@collection
class Component {
  Id id = Isar.autoIncrement;
  late String name;
  String? type;          // Es: Catena, Copertone, Pastiglie
  String? modelDetails;  // Es: Shimano HG-601
  
  int? maintenanceIntervalDays; 
  DateTime purchaseDate = DateTime.now(); 
  DateTime? lastMaintenanceDate;
  
  bool isMounted = true; 
  DateTime? unmountedDate;

  final bike = IsarLink<Bike>();

  @ignore
  bool get isMaintenanceDue {
    // Se non è montato o non c'è intervallo, niente avvisi
    if (!isMounted || maintenanceIntervalDays == null) return false;
    
    final baseDate = lastMaintenanceDate ?? purchaseDate;
    final nextMaintenance = baseDate.add(Duration(days: maintenanceIntervalDays!));
    
    return DateTime.now().isAfter(nextMaintenance);
  }
}