import 'dart:convert';
import '../domain/model/hangman_catalog.dart';
import '../domain/model/hangman_entry.dart';
import 'hangman_data.dart';

class AssetHangmanRepository {
  const AssetHangmanRepository();

  HangmanCatalog loadCatalog() {
    final decoded = jsonDecode(kHangmanJsonData);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('O JSON raiz deve ser um objeto.');
    }

    final rawEntries = decoded['entries'];
    if (rawEntries is! List) {
      throw Exception('O campo "entries" deve ser uma lista.');
    }

    final entries = <HangmanEntry>[];
    for (final rawEntry in rawEntries) {
      if (rawEntry is! Map<String, dynamic>) {
        throw Exception('Cada entrada deve ser um objeto.');
      }
      entries.add(HangmanEntry.fromJson(rawEntry));
    }

    if (entries.isEmpty) {
      throw Exception('O catálogo está vazio.');
    }

    return HangmanCatalog(List<HangmanEntry>.unmodifiable(entries));
  }
}
