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
    final setupsAsync = ref.watch(bikeSetupsProvider(bike.id));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(bike.name),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.settings), text: "Componenti"),
              Tab(icon: Icon(Icons.history), text: "Interventi"),
              Tab(icon: Icon(Icons.tune), text: "Setup"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            componentsAsync.when(
              data: (list) => _buildComponentList(context, ref, list),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Errore: $e")),
            ),
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
            setupsAsync.when(
              data: (list) => _buildSetupList(context, ref, list),
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
                } else if (tabIndex == 1) {
                  _showServiceForm(context, ref);
                } else {
                  _showSetupForm(context, ref);
                }
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  // --- COMPONENTI ---
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
          ),
        ),
        // --- SOTTOTITOLO ARRICCHITO CON LE DATE ---
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${c.type ?? 'Componente'} • ${c.modelDetails ?? 'Nessun dettaglio'}",
            ),
            if (c.lastMaintenanceDate != null)
              Text(
                "Ultima man: ${DateFormat('dd/MM/yyyy').format(c.lastMaintenanceDate!)}",
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            if (!c.isMounted && c.unmountedDate != null)
              Text(
                "Smontato il: ${DateFormat('dd/MM/yyyy').format(c.unmountedDate!)}",
                style: const TextStyle(fontSize: 12, color: Colors.redAccent),
              ),
          ],
        ),
        trailing: const Icon(Icons.edit, size: 18),
        onTap: () => _showComponentForm(context, ref, c),
      ),
    );
  }

  // --- LISTA GENERICA INTERVENTI ---
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
            trailing: const Icon(Icons.edit, size: 18),
            onTap: () => onEdit(item),
          ),
        );
      },
    );
  }

  // --- LISTA SETUP ---
  // --- LISTA SETUP ---
  Widget _buildSetupList(
    BuildContext context,
    WidgetRef ref,
    List<BikeSetup> items,
  ) {
    if (items.isEmpty)
      return const Center(child: Text("Nessun setup definito"));
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final setup = items[index];
        return Dismissible(
          key: Key("setup_${setup.id}"),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) =>
              ref.read(isarServiceProvider).deleteBikeSetup(setup.id),
          child: ListTile(
            leading: Icon(
              setup.isCheckDue ? Icons.notification_important : Icons.tune,
              color: setup.isCheckDue ? Colors.orange : Colors.blueGrey,
            ),
            title: Text(
              setup.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            // --- SOTTOTITOLO AGGIORNATO CON DATA ULTIMO CONTROLLO ---
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${setup.category ?? 'Generale'} • Valore: ${setup.value ?? '-'}",
                ),
                if (setup.hasPeriodicCheck && setup.lastCheckDate != null)
                  Text(
                    "Ultimo controllo: ${DateFormat('dd/MM/yyyy').format(setup.lastCheckDate!)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: setup.isCheckDue ? Colors.orange : Colors.green,
                    ),
                  ),
              ],
            ),
            trailing: const Icon(Icons.edit, size: 18),
            onTap: () => _showSetupForm(context, ref, setup),
          ),
        );
      },
    );
  }

  // --- FORM COMPONENTI (CORRETTO) ---
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
    DateTime? lastMaintDate = existing?.lastMaintenanceDate;
    bool isMounted = existing?.isMounted ?? true;
    DateTime? unmountedDate = existing?.unmountedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    existing == null
                        ? "Nuovo Componente"
                        : "Modifica Componente",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

                  // --- SWITCH MONTAGGIO ---
                  SwitchListTile(
                    title: const Text("Componente montato"),
                    value: isMounted,
                    onChanged: (val) => setState(() {
                      isMounted = val;
                      unmountedDate = val
                          ? null
                          : (unmountedDate ?? DateTime.now());
                    }),
                  ),

                  // --- DATA INSTALLAZIONE ---
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Installazione: ${DateFormat('dd/MM/yyyy').format(installDate)}",
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

                  // --- DATA ULTIMA MANUTENZIONE ---
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      lastMaintDate == null
                          ? "Ultima manutenzione: Mai"
                          : "Ultima manutenzione: ${DateFormat('dd/MM/yyyy').format(lastMaintDate!)}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (lastMaintDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () =>
                                setState(() => lastMaintDate = null),
                          ),
                        const Icon(Icons.build),
                      ],
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: lastMaintDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null)
                        setState(() => lastMaintDate = picked);
                    },
                  ),

                  // --- DATA SMONTAGGIO (Visibile solo se smontato) ---
                  if (!isMounted)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        unmountedDate == null
                            ? "Data smontaggio: Sconosciuta"
                            : "Data smontaggio: ${DateFormat('dd/MM/yyyy').format(unmountedDate!)}",
                      ),
                      trailing: const Icon(Icons.event_busy),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: unmountedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null)
                          setState(() => unmountedDate = picked);
                      },
                    ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
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
                            lastMaintDate; // SALVA LA DATA DI MANUTENZIONE
                        c.isMounted = isMounted;
                        c.unmountedDate =
                            unmountedDate; // SALVA LA DATA DI SMONTAGGIO
                        c.bike.value = bike;
                        ref.read(isarServiceProvider).saveComponent(c);
                        Navigator.pop(context);
                      },
                      child: const Text("Salva"),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- FORM INTERVENTI (CORRETTO) ---
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    existing == null
                        ? "Nuovo Intervento"
                        : "Modifica Intervento",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: "Descrizione"),
                  ),
                  TextField(
                    controller: locController,
                    decoration: const InputDecoration(labelText: "Luogo"),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
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
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- FORM SETUP (CORRETTO) ---
  // --- FORM SETUP ---
  void _showSetupForm(
    BuildContext context,
    WidgetRef ref, [
    BikeSetup? existing,
  ]) {
    final titleController = TextEditingController(text: existing?.title);
    final valueController = TextEditingController(text: existing?.value);
    final categoryController = TextEditingController(text: existing?.category);
    final daysController = TextEditingController(
      text: existing?.checkIntervalDays?.toString(),
    );

    bool hasCheck = existing?.hasPeriodicCheck ?? false;
    DateTime? lastCheckDate = existing?.lastCheckDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    existing == null ? "Nuovo Parametro" : "Modifica Setup",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Titolo (es. Pressione Forcella)",
                    ),
                  ),
                  TextField(
                    controller: valueController,
                    decoration: const InputDecoration(
                      labelText: "Valore (es. 85 psi)",
                    ),
                  ),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      labelText: "Categoria (es. Sospensioni)",
                    ),
                  ),

                  // --- SWITCH CONTROLLO PERIODICO ---
                  SwitchListTile(
                    title: const Text("Controllo periodico"),
                    value: hasCheck,
                    onChanged: (val) => setState(() {
                      hasCheck = val;
                      if (val && lastCheckDate == null)
                        lastCheckDate = DateTime.now();
                    }),
                  ),

                  // --- OPZIONI VISIBILI SOLO SE IL CONTROLLO È ATTIVO ---
                  if (hasCheck) ...[
                    TextField(
                      controller: daysController,
                      decoration: const InputDecoration(
                        labelText: "Controlla ogni (giorni)",
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    // --- SELETTORE DATA ULTIMO CONTROLLO ---
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        lastCheckDate == null
                            ? "Ultimo controllo: Mai"
                            : "Ultimo controllo: ${DateFormat('dd/MM/yyyy').format(lastCheckDate!)}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (lastCheckDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () =>
                                  setState(() => lastCheckDate = null),
                            ),
                          const Icon(Icons.fact_check),
                        ],
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: lastCheckDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null)
                          setState(() => lastCheckDate = picked);
                      },
                    ),
                  ],

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isEmpty) return;
                        final s = existing ?? BikeSetup();
                        s.title = titleController.text;
                        s.value = valueController.text;
                        s.category = categoryController.text;
                        s.hasPeriodicCheck = hasCheck;
                        s.checkIntervalDays = int.tryParse(daysController.text);
                        s.lastCheckDate =
                            lastCheckDate; // <--- ORA VIENE SALVATO CORRETTAMENTE
                        s.bike.value = bike;
                        ref.read(isarServiceProvider).saveBikeSetup(s);
                        Navigator.pop(context);
                      },
                      child: const Text("Salva"),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
