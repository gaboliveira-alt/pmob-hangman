import '../domain/model/answer_category.dart';
import '../domain/model/difficulty.dart';
import '../domain/model/hangman_catalog.dart';
import 'asset_hangman_repository.dart';

enum CatalogStatus { loading, ready, error }

class CatalogManager {
  final AssetHangmanRepository _repository;

  CatalogStatus _status = CatalogStatus.loading;
  String? _errorMessage;
  HangmanCatalog? _catalog;

  CatalogManager([AssetHangmanRepository? repository])
    : _repository = repository ?? const AssetHangmanRepository() {
    load();
  }

  CatalogStatus get status => _status;
  String? get errorMessage => _errorMessage;
  HangmanCatalog? get catalog => _catalog;

  List<AnswerCategory> get categories => _catalog?.categories ?? const [];

  List<Difficulty> difficultiesFor(AnswerCategory category) =>
      _catalog?.difficultiesFor(category) ?? const [];

  void load() {
    try {
      _catalog = _repository.loadCatalog();
      _status = CatalogStatus.ready;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
      _status = CatalogStatus.error;
    }
  }
}
