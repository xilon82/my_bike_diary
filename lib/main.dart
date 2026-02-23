import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/bike.dart';
import 'providers/bike_provider.dart';
import 'views/bike_details_view.dart';
import 'package:intl/intl.dart';

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

  void _showBikeForm(BuildContext context, WidgetRef ref, [Bike? existing]) {
    final nameController = TextEditingController(text: existing?.name);
    final brandController = TextEditingController(text: existing?.brand);
    // Inizializziamo la data con quella esistente o con oggi
    DateTime selectedDate = existing?.purchaseDate ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        // Fondamentale per aggiornare la data nel modal
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                existing == null ? "Nuova Bici" : "Modifica Bici",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(labelText: "Marca"),
              ),

              // --- SELETTORE DATA ---
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Data acquisto: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(
                      () => selectedDate = picked,
                    ); // Aggiorna la UI del modal
                  }
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final bike = existing ?? Bike();
                  bike.name = nameController.text;
                  bike.brand = brandController.text;
                  bike.purchaseDate = selectedDate; // Salviamo la data scelta

                  ref.read(isarServiceProvider).saveBike(bike);
                  Navigator.pop(context);
                },
                child: const Text("Salva"),
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
      //appBar: AppBar(title: const Text("My Bike Diary")),
      appBar: AppBar(
        // centerTitle centra il contenuto della proprietà 'title' sia su Android che su iOS/Linux
        centerTitle: true,
        title: Image.asset(
          'assets/logo.png',
          height:
              50, // Ho aumentato un po' l'altezza visto che ora è l'unico protagonista
          fit: BoxFit.contain,
        ),
        elevation: 0, // Opzionale: toglie l'ombra per un look più flat
        backgroundColor: Colors
            .white, // Opzionale: se vuoi che il logo si fonda con lo sfondo
      ),

      body: bikesAsync.when(
        data: (bikes) => ListView.builder(
          itemCount: bikes.length,
          itemBuilder: (context, index) {
            final bike = bikes[index];
            return Dismissible(
              key: Key(bike.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) =>
                  ref.read(isarServiceProvider).deleteBike(bike.id),
              // All'interno del ListView.builder della HomeScreen
              child: ListTile(
                // 1. ICONA DINAMICA
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Icon(_getBikeIcon(bike.type), color: Colors.blue),
                ),
                title: Text(bike.name),
                subtitle: Text(
                  "${bike.brand} • ${bike.type}\nEtà: ${bike.age}",
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BikeDetailsView(bike: bike),
                  ),
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
