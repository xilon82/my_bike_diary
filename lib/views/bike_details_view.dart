import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Aggiungi intl nel pubspec.yaml per formattare le date
import '../models/bike.dart';
import '../models/component.dart';
import '../providers/bike_provider.dart';

class BikeDetailsView extends ConsumerWidget {
  final Bike bike;
  const BikeDetailsView({super.key, required this.bike});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final componentsAsync = ref.watch(componentsProvider(bike.id));
    final historyAsync = ref.watch(serviceHistoryProvider(bike.id));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(bike.name),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.settings), text: "Componenti"),
              Tab(icon: Icon(Icons.history), text: "Interventi"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: COMPONENTI
            componentsAsync.when(
              data: (list) => _buildList(
                items: list,
                onDelete: (id) => ref.read(isarServiceProvider).deleteComponent(id),
                onEdit: (item) => _showComponentForm(context, ref, item as Component),
                subtitleBuilder: (item) => "Acquisto: ${DateFormat('dd/MM/yy').format((item as Component).purchaseDate)}",
                trailingBuilder: (item) => (item as Component).isMaintenanceDue 
                  ? const Icon(Icons.warning, color: Colors.orange) 
                  : const Icon(Icons.check_circle, color: Colors.green),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Errore: $e"),
            ),
            // TAB 2: INTERVENTI
            historyAsync.when(
              data: (list) => _buildList(
                items: list,
                onDelete: (id) => ref.read(isarServiceProvider).deleteServiceHistory(id),
                onEdit: (item) => _showServiceForm(context, ref, item as ServiceHistory),
                subtitleBuilder: (item) {
                  final s = item as ServiceHistory;
                  return "${s.location} • €${s.cost.toStringAsFixed(2)}\n${DateFormat('dd/MM/yyyy').format(s.date)}";
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Errore: $e"),
            ),
          ],
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              final tabIndex = DefaultTabController.of(context).index;
              if (tabIndex == 0) {
                _showComponentForm(context, ref);
              } else {
                _showServiceForm(context, ref);
              }
            },
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }

  // Widget generico per le liste (DRY - Don't Repeat Yourself)
  Widget _buildList({
    required List<dynamic> items,
    required Function(int) onDelete,
    required Function(dynamic) onEdit,
    required String Function(dynamic) subtitleBuilder,
    Widget? Function(dynamic)? trailingBuilder,
  }) {
    if (items.isEmpty) return const Center(child: Text("Nessun dato presente"));
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: Key("item_${item.id}"),
          direction: DismissDirection.endToStart,
          background: Container(color: Colors.red, alignment: Alignment.centerRight, child: const Icon(Icons.delete, color: Colors.white)),
          onDismissed: (_) => onDelete(item.id),
          child: ListTile(
            title: Text(item is Component ? item.name : (item as ServiceHistory).description),
            subtitle: Text(subtitleBuilder(item)),
            trailing: trailingBuilder != null ? trailingBuilder(item) : const Icon(Icons.chevron_right),
            onTap: () => onEdit(item),
          ),
        );
      },
    );
  }

  // --- FORM COMPONENTI ---
  void _showComponentForm(BuildContext context, WidgetRef ref, [Component? existing]) {
    final nameController = TextEditingController(text: existing?.name);
    final daysController = TextEditingController(text: existing?.maintenanceIntervalDays?.toString());
    DateTime selectedDate = existing?.purchaseDate ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(existing == null ? "Nuovo Componente" : "Modifica Componente"),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nome")),
              TextField(controller: daysController, decoration: const InputDecoration(labelText: "Intervallo Manutenzione (giorni)"), keyboardType: TextInputType.number),
              ListTile(
                title: Text("Data acquisto: ${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2000), lastDate: DateTime.now());
                  if (picked != null) setState(() => selectedDate = picked);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  final c = existing ?? Component();
                  c.name = nameController.text;
                  c.maintenanceIntervalDays = int.tryParse(daysController.text);
                  c.purchaseDate = selectedDate;
                  c.bike.value = bike;
                  ref.read(isarServiceProvider).saveComponent(c);
                  Navigator.pop(context);
                },
                child: const Text("Salva"),
              ),
            ],
          ),
        );
      }),
    );
  }

  // --- FORM INTERVENTI ---
  void _showServiceForm(BuildContext context, WidgetRef ref, [ServiceHistory? existing]) {
    final descController = TextEditingController(text: existing?.description);
    final locController = TextEditingController(text: existing?.location);
    final costController = TextEditingController(text: existing?.cost.toString());
    DateTime selectedDate = existing?.date ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(existing == null ? "Nuovo Intervento" : "Modifica Intervento"),
              TextField(controller: descController, decoration: const InputDecoration(labelText: "Cosa è stato fatto?")),
              TextField(controller: locController, decoration: const InputDecoration(labelText: "Dove? (es. Officina)")),
              TextField(controller: costController, decoration: const InputDecoration(labelText: "Costo (€)"), keyboardType: TextInputType.number),
              ListTile(
                title: Text("Data: ${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2000), lastDate: DateTime.now());
                  if (picked != null) setState(() => selectedDate = picked);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  final s = existing ?? ServiceHistory();
                  s.description = descController.text;
                  s.location = locController.text;
                  s.cost = double.tryParse(costController.text) ?? 0.0;
                  s.date = selectedDate;
                  s.bike.value = bike;
                  ref.read(isarServiceProvider).saveServiceHistory(s);
                  Navigator.pop(context);
                },
                child: const Text("Salva"),
              ),
            ],
          ),
        );
      }),
    );
  }
}