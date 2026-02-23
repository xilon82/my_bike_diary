import 'package:isar/isar.dart';
import 'component.dart';

part 'bike.g.dart';

@collection
class Bike {
  Id id = Isar.autoIncrement;
  late String name;
  String? brand;
  String type = 'Gravel'; 
  DateTime purchaseDate = DateTime.now();

  @Backlink(to: 'bike')
  final components = IsarLinks<Component>();

  @Backlink(to: 'bike') // Deve puntare esattamente al nome del campo sotto
  final serviceHistory = IsarLinks<ServiceHistory>();

  String get age {
    final duration = DateTime.now().difference(purchaseDate);
    final years = (duration.inDays / 365).floor();
    final months = ((duration.inDays % 365) / 30).floor();
    
    if (years > 0) {
      return "$years ann${years == 1 ? 'o' : 'i'} e $months mes${months == 1 ? 'e' : 'i'}";
    } else {
      return "$months mes${months == 1 ? 'e' : 'i'}";
    }
  }
}

@collection
class ServiceHistory {
  Id id = Isar.autoIncrement;
  late String description;
  late String location;
  double cost = 0.0;
  DateTime date = DateTime.now();

  // Aggiungiamo l'annotazione esplicita per forzare il generatore
  @ignore 
  int? get tempId => id; // Inutile, serve solo a "muovere" il file

  final bike = IsarLink<Bike>(); // <--- IL GENERATORE CERCA QUESTO
}