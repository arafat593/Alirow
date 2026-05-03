import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/screens/home_screen/repository/category_repository.dart';
import 'package:flutter_riverpod_template/screens/product_details/model/product_model.dart';
import 'package:flutter_riverpod_template/screens/product_details/repository/product_repository.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class HomeState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final bool isCategoryLoading;
  final bool isProductLoading;
  final String? selectedCategoryId; // null = "All"
  final int selectedCategoryIndex; // 0 = "All"
  final String searchQuery;
  final String? error;

  const HomeState({
    this.categories = const [],
    this.products = const [],
    this.isCategoryLoading = false,
    this.isProductLoading = false,
    this.selectedCategoryId,
    this.selectedCategoryIndex = 0,
    this.searchQuery = '',
    this.error,
  });

  HomeState copyWith({
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    bool? isCategoryLoading,
    bool? isProductLoading,
    String? selectedCategoryId,
    bool clearCategoryId = false,
    int? selectedCategoryIndex,
    String? searchQuery,
    String? error,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      isCategoryLoading: isCategoryLoading ?? this.isCategoryLoading,
      isProductLoading: isProductLoading ?? this.isProductLoading,
      selectedCategoryId: clearCategoryId
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  final _categoryRepo = CategoryRepository.instance;
  final _productRepo = ProductRepository.instance;

  /// Call once on init — loads categories then products
  Future<void> init() async {
    await _loadCategories();
    await _loadProducts();
  }

  Future<void> _loadCategories() async {
    state = state.copyWith(isCategoryLoading: true, error: null);
    final cats = await _categoryRepo.getCategories();
    state = state.copyWith(categories: cats, isCategoryLoading: false);
  }

  Future<void> _loadProducts() async {
    state = state.copyWith(isProductLoading: true, error: null);
    final products = await _productRepo.getProducts(
      categoryId: state.selectedCategoryId,
      search: state.searchQuery.isEmpty ? null : state.searchQuery,
    );
    state = state.copyWith(products: products, isProductLoading: false);
  }

  /// index 0 = "All", index 1..n = categories[index-1]
  Future<void> selectCategory(int index) async {
    if (index == 0) {
      state = state.copyWith(selectedCategoryIndex: 0, clearCategoryId: true);
    } else {
      final cat = state.categories[index - 1];
      state = state.copyWith(
        selectedCategoryIndex: index,
        selectedCategoryId: cat.id,
      );
    }
    await _loadProducts();
  }

  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query);
    await _loadProducts();
  }

  Future<void> refresh() async {
    await _loadProducts();
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
