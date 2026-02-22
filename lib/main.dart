import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/bike.dart';
import 'providers/bike_provider.dart';
import 'views/bike_details_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showBikeForm(BuildContext context, WidgetRef ref, [Bike? bike]) {
    final isEditing = bike != null;
    final nameController = TextEditingController(text: bike?.name);
    final brandController = TextEditingController(text: bike?.brand);
    String selectedType = bike?.type ?? 'Gravel';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isEditing ? "Modifica Bici" : "Nuova Bici", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nome")),
              TextField(controller: brandController, decoration: const InputDecoration(labelText: "Marca")),
              DropdownButton<String>(
                value: selectedType,
                isExpanded: true,
                items: ['Gravel', 'MTB', 'Strada', 'Pieghevole'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) => setModalState(() => selectedType = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final b = bike ?? Bike();
                    b.name = nameController.text;
                    b.brand = brandController.text;
                    b.type = selectedType;
                    ref.read(isarServiceProvider).saveBike(b);
                    Navigator.pop(context);
                  }
                },
                child: Text(isEditing ? "Aggiorna" : "Salva"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bikesAsync = ref.watch(bikesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Bike Diary")),
      body: bikesAsync.when(
        data: (bikes) => ListView.builder(
          itemCount: bikes.length,
          itemBuilder: (context, index) {
            final bike = bikes[index];
            return Dismissible(
              key: Key(bike.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(color: Colors.red, alignment: Alignment.centerRight, child: const Icon(Icons.delete, color: Colors.white)),
              onDismissed: (_) => ref.read(isarServiceProvider).deleteBike(bike.id),
              // All'interno del ListView.builder della HomeScreen
              child: ListTile(
                // 1. ICONA DINAMICA
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Icon(_getBikeIcon(bike.type), color: Colors.blue),
                ),
                title: Text(bike.name),
                subtitle: Text("${bike.brand} - ${bike.type}"),
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => BikeDetailsView(bike: bike))
                ),
                // 2. LOGICA DI MODIFICA (Long Press)
                onLongPress: () => _showBikeForm(context, ref, bike),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Errore: $e")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBikeForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }


IconData _getBikeIcon(String type) {
  switch (type) {
    case 'MTB':
      return Icons.terrain;
    case 'Strada':
      return Icons.speed;
    case 'Gravel':
      return Icons.explore;
    case 'Pieghevole':
      return Icons.moped; // o Icons.directions_bike
    default:
      return Icons.directions_bike;
  }
  }
}