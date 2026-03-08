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

  // --- FORM INSERIMENTO/MODIFICA BICI ---
  void _showBikeForm(BuildContext context, WidgetRef ref, [Bike? existing]) {
    final nameController = TextEditingController(text: existing?.name);
    final brandController = TextEditingController(text: existing?.brand);

    DateTime selectedDate = existing?.purchaseDate ?? DateTime.now();
    String selectedType = existing?.type ?? 'Gravel';

    final List<String> bikeTypes = ['Gravel', 'MTB', 'Strada', 'Pieghevole'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Colore di sfondo per uniformità
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(
              context,
            ).viewInsets.bottom, // Gestisce la tastiera
            left: 20,
            right: 20,
            top: 20,
          ),
          // --- SOLUZIONE: SafeArea avvolge il contenuto ---
          child: SafeArea(
            child: SingleChildScrollView(
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
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Nome"),
                  ),
                  TextField(
                    controller: brandController,
                    decoration: const InputDecoration(labelText: "Marca"),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: "Tipo di Bici",
                    ),
                    items: bikeTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Icon(
                              _getBikeIcon(type),
                              size: 20,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 10),
                            Text(type),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedType = value);
                      }
                    },
                  ),
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
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        final bike = existing ?? Bike();
                        bike.name = nameController.text;
                        bike.brand = brandController.text;
                        bike.type = selectedType;
                        bike.purchaseDate = selectedDate;

                        ref.read(isarServiceProvider).saveBike(bike);
                        Navigator.pop(context);
                      },
                      child: const Text("Salva"),
                    ),
                  ),
                  // Spazio extra finale per sicurezza sopra i tasti Android
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bikesAsync = ref.watch(bikesProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/logo.png', height: 50, fit: BoxFit.contain),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          // MANTENIAMO SOLO IL TASTO ESPORTA
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "Esporta Backup",
            color: Colors.blue,
            onPressed: () async {
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Generazione backup in corso..."),
                  ),
                );
                await ref.read(isarServiceProvider).exportFullBackup();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Errore durante l'export: $e")),
                );
              }
            },
          ),
        ],
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
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) =>
                  ref.read(isarServiceProvider).deleteBike(bike.id),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Icon(_getBikeIcon(bike.type), color: Colors.blue),
                ),
                title: Text(bike.name),
                subtitle: Text(
                  "${bike.brand ?? 'Senza marca'} • ${bike.type}\nEtà: ${bike.age}",
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BikeDetailsView(bike: bike),
                  ),
                ),
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

  // LOGICA ICONE RIPRISTINATA
  static IconData _getBikeIcon(String type) {
    switch (type) {
      case 'MTB':
        return Icons.terrain;
      case 'Strada':
        return Icons.speed;
      case 'Gravel':
        return Icons.explore;
      case 'Pieghevole':
        return Icons.moped;
      default:
        return Icons.directions_bike;
    }
  }
}
