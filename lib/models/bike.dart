import 'package:isar/isar.dart';
import 'component.dart';

part 'bike.g.dart';

@collection
class Bike {
  Id id = Isar.autoIncrement;
  late String name;
  String? brand;
  String type = 'Gravel'; 
  double totalKm = 0.0;
  DateTime purchaseDate = DateTime.now();

  @Backlink(to: 'bike')
  final components = IsarLinks<Component>();
}