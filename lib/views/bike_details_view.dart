import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bike.dart';
import '../models/component.dart';
import '../providers/bike_provider.dart';

class BikeDetailsView extends ConsumerWidget {
  final Bike bike;
  const BikeDetailsView({super.key, required this.bike});

  void _showComponentForm(
    BuildContext context,
    WidgetRef ref, [
    Component? existingComp,
  ]) {
    final isEditing = existingComp != null;
    final nameController = TextEditingController(text: existingComp?.name);
    final intervalController = TextEditingController(
      text: existingComp?.maintenanceIntervalDays?.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
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
              isEditing ? "Modifica Componente" : "Nuovo Componente",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: intervalController,
              decoration: const InputDecoration(
                labelText: "Giorni tra manutenzioni",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  // Se stiamo modificando, usiamo l'oggetto esistente, altrimenti ne creiamo uno nuovo
                  final comp = existingComp ?? Component();
                  comp.name = nameController.text;
                  comp.maintenanceIntervalDays = int.tryParse(
                    intervalController.text,
                  );
                  comp.bike.value = bike; // Ri-associamo sempre la bici

                  ref.read(isarServiceProvider).saveComponent(comp);
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? "Aggiorna" : "Salva"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final componentsAsync = ref.watch(componentsProvider(bike.id));

    return Scaffold(
      appBar: AppBar(title: Text(bike.name)),
      body: componentsAsync.when(
        data: (components) => Column(
          children: [
            // Info Bici
            ListTile(
              tileColor: Colors.blue.withOpacity(0.1),
              title: Text("${bike.brand} - ${bike.type}"),
              subtitle: const Text(
                "Scorri a sinistra per eliminare un componente",
              ),
            ),
            // Lista Componenti
            Expanded(
              child: ListView.builder(
                itemCount: components.length,
                itemBuilder: (context, index) {
                  final comp = components[index];
                  return Dismissible(
                    key: Key(comp.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) =>
                        ref.read(isarServiceProvider).deleteComponent(comp.id),
                    child: ListTile(
                      onTap: () => _showComponentForm(context, ref, comp), // Tap per modificare
                      title: Text(comp.name),
                      subtitle: Text(
                        "Manutenzione ogni: ${comp.maintenanceIntervalDays ?? '--'} gg",
                      ),
                      trailing: comp.isMaintenanceDue
                          ? const Icon(Icons.warning, color: Colors.orange)
                          : const Icon(Icons.check_circle, color: Colors.green),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Errore: $e")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showComponentForm(context, ref),
        tooltip: "Aggiungi componente",
        child: const Icon(Icons.settings_outlined),
      ),
    );
  }
}
