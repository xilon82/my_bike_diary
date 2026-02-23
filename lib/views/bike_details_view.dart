import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
            // TAB 1: COMPONENTI (Con gestione Archivio)
            componentsAsync.when(
              data: (list) => _buildComponentList(context, ref, list),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Errore: $e")),
            ),
            // TAB 2: INTERVENTI
            historyAsync.when(
              data: (list) => _buildList(
                items: list,
                onDelete: (id) =>
                    ref.read(isarServiceProvider).deleteServiceHistory(id),
                onEdit: (item) =>
                    _showServiceForm(context, ref, item as ServiceHistory),
                subtitleBuilder: (item) {
                  final s = item as ServiceHistory;
                  return "${s.location} • €${s.cost.toStringAsFixed(2)}\n${DateFormat('dd/MM/yyyy').format(s.date)}";
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Errore: $e")),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
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
          },
        ),
      ),
    );
  }

  // --- LOGICA COMPONENTI (ATTIVI + ARCHIVIO) ---
  Widget _buildComponentList(
    BuildContext context,
    WidgetRef ref,
    List<Component> items,
  ) {
    if (items.isEmpty) return const Center(child: Text("Nessun componente"));

    final active = items.where((c) => c.isMounted).toList();
    final archived = items.where((c) => !c.isMounted).toList();

    return ListView(
      children: [
        if (active.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "IN USO",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          ...active.map((c) => _componentTile(context, ref, c)),
        ],
        if (archived.isNotEmpty) ...[
          const Divider(),
          ExpansionTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: Text("Archivio smontati (${archived.length})"),
            children: archived
                .map((c) => _componentTile(context, ref, c))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _componentTile(BuildContext context, WidgetRef ref, Component c) {
    return Dismissible(
      key: Key("comp_${c.id}"),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => ref.read(isarServiceProvider).deleteComponent(c.id),
      child: ListTile(
        leading: Icon(
          c.isMounted
              ? (c.isMaintenanceDue ? Icons.warning_amber : Icons.check_circle)
              : Icons.pause_circle_outline,
          color: c.isMounted
              ? (c.isMaintenanceDue ? Colors.orange : Colors.green)
              : Colors.grey,
        ),
        title: Text(
          c.name,
          style: TextStyle(
            decoration: c.isMounted ? null : TextDecoration.lineThrough,
            fontWeight: c.isMounted ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          "${c.type ?? 'Componente'} • ${c.modelDetails ?? 'Nessun dettaglio'}",
        ),
        trailing: const Icon(Icons.edit, size: 18),
        onTap: () => _showComponentForm(context, ref, c),
      ),
    );
  }

  // --- LISTA GENERICA PER INTERVENTI ---
  Widget _buildList({
    required List<dynamic> items,
    required Function(int) onDelete,
    required Function(dynamic) onEdit,
    required String Function(dynamic) subtitleBuilder,
  }) {
    if (items.isEmpty) return const Center(child: Text("Nessun dato presente"));
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: Key("item_${item.id}"),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => onDelete(item.id),
          child: ListTile(
            title: Text((item as ServiceHistory).description),
            subtitle: Text(subtitleBuilder(item)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onEdit(item),
          ),
        );
      },
    );
  }

  // --- FORM COMPONENTI AGGIORNATO CON DATA ULTIMA MANUTENZIONE ---
  void _showComponentForm(
    BuildContext context,
    WidgetRef ref, [
    Component? existing,
  ]) {
    final nameController = TextEditingController(text: existing?.name);
    final typeController = TextEditingController(text: existing?.type);
    final detailsController = TextEditingController(
      text: existing?.modelDetails,
    );
    final daysController = TextEditingController(
      text: existing?.maintenanceIntervalDays?.toString(),
    );

    DateTime installDate = existing?.purchaseDate ?? bike.purchaseDate;
    // Recuperiamo la data ultima manutenzione se esiste
    DateTime? lastMaintDate = existing?.lastMaintenanceDate;
    bool isMounted = existing?.isMounted ?? true;
    DateTime? unmountedDate = existing?.unmountedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    existing == null
                        ? "Nuovo Componente"
                        : "Modifica Componente",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nome (es. Catena)",
                    ),
                  ),
                  TextField(
                    controller: typeController,
                    decoration: const InputDecoration(
                      labelText: "Tipo (es. Trasmissione)",
                    ),
                  ),
                  TextField(
                    controller: detailsController,
                    decoration: const InputDecoration(
                      labelText: "Modello/Dettagli",
                    ),
                  ),
                  TextField(
                    controller: daysController,
                    decoration: const InputDecoration(
                      labelText: "Manutenzione ogni (giorni)",
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SwitchListTile(
                    title: const Text("Componente montato"),
                    value: isMounted,
                    onChanged: (val) {
                      setState(() {
                        isMounted = val;
                        if (!val)
                          unmountedDate = DateTime.now();
                        else
                          unmountedDate = null;
                      });
                    },
                  ),

                  // SELETTORE DATA INSTALLAZIONE
                  ListTile(
                    title: Text(
                      "Data installazione: ${DateFormat('dd/MM/yyyy').format(installDate)}",
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: installDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => installDate = picked);
                    },
                  ),

                  // SELETTORE DATA ULTIMA MANUTENZIONE (Aggiunto qui)
                  ListTile(
                    title: Text(
                      "Ultima manutenzione: ${lastMaintDate == null ? 'Coincide con installazione' : DateFormat('dd/MM/yyyy').format(lastMaintDate!)}",
                    ),
                    subtitle: const Text(
                      "Seleziona se diversa dalla data installazione",
                    ),
                    trailing: const Icon(Icons.build_circle_outlined),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: lastMaintDate ?? installDate,
                        firstDate:
                            DateTime(2000), // Non può essere prima dell'installazione
                        lastDate: DateTime.now(),
                      );
                      if (picked != null)
                        setState(() => lastMaintDate = picked);
                    },
                  ),

                  if (!isMounted)
                    ListTile(
                      title: Text(
                        "Data smontaggio: ${unmountedDate != null ? DateFormat('dd/MM/yyyy').format(unmountedDate!) : '-'}",
                      ),
                      textColor: Colors.red,
                      trailing: const Icon(Icons.event_busy, color: Colors.red),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: unmountedDate ?? DateTime.now(),
                          firstDate: installDate,
                          lastDate: DateTime.now(),
                        );
                        if (picked != null)
                          setState(() => unmountedDate = picked);
                      },
                    ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final c = existing ?? Component();
                      c.name = nameController.text;
                      c.type = typeController.text;
                      c.modelDetails = detailsController.text;
                      c.maintenanceIntervalDays = int.tryParse(
                        daysController.text,
                      );
                      c.purchaseDate = installDate;
                      c.lastMaintenanceDate =
                          lastMaintDate; // Salviamo il valore manuale
                      c.isMounted = isMounted;
                      c.unmountedDate = unmountedDate;
                      c.bike.value = bike;
                      ref.read(isarServiceProvider).saveComponent(c);
                      Navigator.pop(context);
                    },
                    child: const Text("Salva"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- FORM INTERVENTI ---
  void _showServiceForm(
    BuildContext context,
    WidgetRef ref, [
    ServiceHistory? existing,
  ]) {
    final descController = TextEditingController(text: existing?.description);
    final locController = TextEditingController(text: existing?.location);
    final costController = TextEditingController(
      text: existing?.cost.toString(),
    );
    DateTime selectedDate = existing?.date ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
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
                  existing == null ? "Nuovo Intervento" : "Modifica Intervento",
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Cosa è stato fatto?",
                  ),
                ),
                TextField(
                  controller: locController,
                  decoration: const InputDecoration(
                    labelText: "Dove? (es. Officina)",
                  ),
                ),
                TextField(
                  controller: costController,
                  decoration: const InputDecoration(labelText: "Costo (€)"),
                  keyboardType: TextInputType.number,
                ),
                ListTile(
                  title: Text(
                    "Data: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
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
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
