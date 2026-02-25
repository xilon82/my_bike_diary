import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bike.dart';
import '../models/component.dart';

import '../services/isar_service.dart';

/* 
Questo file, bike_provider.dart, funge da ponte tra il tuo database (Isar), la logica di gestione (Service) e l'interfaccia utente (UI).

Ecco la logica che collega i vari pezzi:


1. Il Collegamento alle Collection (isarProvider)
Questo è il punto di partenza. Il provider isarProvider ha il compito di aprire il database.

La Logica: Quando chiami Isar.open, devi passargli gli "schemi" delle tue tabelle.
Il Codice: [BikeSchema, ComponentSchema, ServiceHistorySchema].
La Connessione: Questi Schema vengono generati automaticamente (nei file .g.dart) partendo proprio dalle classi annotate con @collection che hai definito in bike.dart. È qui che dici al database: "Preparati a gestire oggetti di tipo Bike e ServiceHistory".
 */
final isarProvider = Provider<Future<Isar>>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [BikeSchema, ComponentSchema, ServiceHistorySchema],
    directory: dir.path,
  );

  // Inseriscilo QUI, prima del return
  //await isar.writeTxn(() => isar.clear()); 
  //print("DATABASE RESETTATO CON SUCCESSO");

  return isar;

});

/* 2. Il Collegamento al Service (isarServiceProvider)
Questo provider serve per l'Iniezione delle Dipendenze.

La Logica: La classe IsarService (che contiene i metodi veri e propri come saveBike, deleteBike) ha bisogno del database aperto per funzionare.
Il Codice: Provider((ref) => IsarService(ref.watch(isarProvider))).
La Connessione: Riverpod legge il database dal primo provider (isarProvider) e lo "inietta" dentro il costruttore del tuo IsarService. Così il service è pronto all'uso.
 */
final isarServiceProvider = Provider((ref) => IsarService(ref.watch(isarProvider)));


/* 3. I Flussi di Dati (bikesProvider, serviceHistoryProvider)
Questi sono i provider che la tua UI ascolta direttamente (usando ref.watch).

La Logica: Sono definiti come StreamProvider. Questo significa che non restituiscono un dato fisso, ma un flusso continuo di dati.
La Connessione:
Chiamano metodi come listenToBikes() o listenToServiceHistory(bikeId) esposti dal Service.
Grazie alla natura reattiva di Isar, quando aggiungi una manutenzione nel DB, Isar avvisa il Service, che avvisa questo Provider, che a sua volta fa ridisegnare la schermata Flutter automaticamente.
Riassunto del flusso
bike.dart definisce come sono fatti i dati.
isarProvider usa quelle definizioni per creare il file del DB fisico.
isarServiceProvider prende il DB e ci costruisce sopra le funzioni utili (salva, leggi, cancella).
bikesProvider apre un canale in diretta (Stream) per mostrare i dati a video */
final bikesProvider = StreamProvider<List<Bike>>((ref) {
  return ref.watch(isarServiceProvider).listenToBikes();
});

final componentsProvider = StreamProvider.family<List<Component>, int>((ref, bikeId) {
  return ref.watch(isarServiceProvider).listenToComponents(bikeId);
});

// E aggiungi il provider per la lista interventi
final serviceHistoryProvider = StreamProvider.family<List<ServiceHistory>, int>((ref, bikeId) {
  return ref.watch(isarServiceProvider).listenToServiceHistory(bikeId);
});

