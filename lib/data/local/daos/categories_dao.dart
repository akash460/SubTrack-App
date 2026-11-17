import 'package:drift/drift.dart';
import 'package:subtrack/data/local/app_database.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  /// Watches all categories ordered alphabetically by name.
  Stream<List<Category>> watchCategories() {
    return (select(categories)..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .watch();
  }

  /// Retrieves all categories ordered by name.
  Future<List<Category>> getAllCategories() {
    return (select(categories)..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  /// Fetches a category by its [id].
  Future<Category?> getById(String id) {
    return (select(categories)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserts a new category.
  Future<int> insert(Insertable<Category> category) {
    return into(categories).insert(category);
  }

  /// Updates an existing category.
  Future<bool> updateCategory(Insertable<Category> category) {
    return update(categories).replace(category);
  }

  /// Deletes a category by its [id].
  Future<int> deleteCategory(String id) {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }
}
