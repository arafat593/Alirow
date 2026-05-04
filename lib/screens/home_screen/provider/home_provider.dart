import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/screens/home_screen/repository/category_repository.dart';
import 'package:flutter_riverpod_template/screens/product_details/model/product_model.dart';
import 'package:flutter_riverpod_template/screens/product_details/repository/product_repository.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class HomeState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final List<ProductModel> allProducts;
  final bool isCategoryLoading;
  final bool isProductLoading;
  final String? selectedCategoryId; // null = "All"
  final int selectedCategoryIndex; // 0 = "All"
  final String searchQuery;
  final double minPrice;
  final double maxPrice;
  final String sortBy;
  final String? error;

  const HomeState({
    this.categories = const [],
    this.products = const [],
    this.allProducts = const [],
    this.isCategoryLoading = false,
    this.isProductLoading = false,
    this.selectedCategoryId,
    this.selectedCategoryIndex = 0,
    this.searchQuery = '',
    this.minPrice = 0,
    this.maxPrice = 5000,
    this.sortBy = 'Popular',
    this.error,
  });

  HomeState copyWith({
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    List<ProductModel>? allProducts,
    bool? isCategoryLoading,
    bool? isProductLoading,
    String? selectedCategoryId,
    bool clearCategoryId = false,
    int? selectedCategoryIndex,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? error,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      isCategoryLoading: isCategoryLoading ?? this.isCategoryLoading,
      isProductLoading: isProductLoading ?? this.isProductLoading,
      selectedCategoryId: clearCategoryId
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
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
    state = state.copyWith(allProducts: products);
    _applyLocalFilter();
  }

  void _applyLocalFilter() {
    List<ProductModel> filtered = List.from(state.allProducts);
    
    // Filter by price
    filtered = filtered.where((p) {
      return p.salePrice >= state.minPrice && p.salePrice <= state.maxPrice;
    }).toList();
    
    // Sort
    if (state.sortBy == 'Price: Low to High') {
      filtered.sort((a, b) => a.salePrice.compareTo(b.salePrice));
    } else if (state.sortBy == 'Price: High to Low') {
      filtered.sort((a, b) => b.salePrice.compareTo(a.salePrice));
    } else if (state.sortBy == 'Newest') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    state = state.copyWith(products: filtered, isProductLoading: false);
  }

  void applyFilter(double minPrice, double maxPrice, String sortBy) {
    state = state.copyWith(minPrice: minPrice, maxPrice: maxPrice, sortBy: sortBy);
    _applyLocalFilter();
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
