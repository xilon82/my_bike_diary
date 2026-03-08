# 🚲 My Bike Diary

**My Bike Diary** è un'applicazione mobile sviluppata con **Flutter** e **Isar Database** per la gestione completa della manutenzione e dei setup delle proprie biciclette. Pensata per i ciclisti che vogliono tenere traccia di ogni componente, intervento tecnico e regolazione millimetrica.

---

## 🚀 Funzionalità Principali

* **Garage Virtuale:** Gestisci più biciclette contemporaneamente, con icone personalizzate per tipologia (**Gravel, MTB, Strada, Pieghevole**).
* **Gestione Componenti:** * Monitora l'usura di catena, copertoni e altri componenti.
    * Imposta intervalli di manutenzione personalizzati (in giorni).
    * Archivia i componenti smontati mantenendo lo storico della loro vita utile e la data di rimozione.
* **Registro Interventi:** Segna ogni riparazione o revisione fatta, con dettagli su luogo, costo e data.
* **Setup & Tuning:** * Salva le regolazioni precise (pressione sospensioni, altezza sella, sag).
    * Pianifica controlli periodici per assicurarti che la tua bici sia sempre performante.
* **Backup & Export:** Esporta l'intero database in formato JSON per conservare i tuoi dati o trasferirli su un altro dispositivo (funzione Import in arrivo).
* **UI Ottimizzata:** Interfaccia moderna in Material 3, con gestione della *Safe Area* specifica per dispositivi Android con tasti di navigazione.

---

## 🛠 Tech Stack

* **Framework:** [Flutter](https://flutter.dev/)
* **State Management:** [Riverpod](https://riverpod.dev/)
* **Database:** [Isar](https://isar.dev/) (NoSQL ultra-veloce per Flutter)
* **Localizzazione:** Formato data e valuta italiano (INTL).

---

## 📥 Installazione

1.  Assicurati di avere Flutter installato sul tuo sistema.
2.  Clona il repository:
    ```bash
    git clone [https://github.com/](https://github.com/)[IL-TUO-USERNAME]/my_bike_diary.git
    ```
3.  Installa le dipendenze:
    ```bash
    flutter pub get
    ```
4.  Genera i file necessari per Isar (necessario per i modelli):
    ```bash
    dart run build_runner build
    ```
5.  Avvia l'app sul tuo dispositivo:
    ```bash
    flutter run
    ```

---

## 📝 Note sullo Sviluppo
L'applicazione è stata ottimizzata per dispositivi Samsung (Serie A/S) garantendo che i menu a scomparsa (*Bottom Sheets*) non vengano coperti dalla barra di navigazione di sistema.

---

*Sviluppato con ❤️ da un ciclista per i ciclisti.*
