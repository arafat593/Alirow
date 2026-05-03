import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/screens/product_details/model/product_model.dart';
import 'package:flutter_riverpod_template/screens/product_details/repository/product_repository.dart';

// ─── Product Details State ───────────────────────────────────────────────────

class ProductDetailsState {
  final ProductModel? product;
  final bool isLoading;
  final String? error;

  const ProductDetailsState({this.product, this.isLoading = false, this.error});

  ProductDetailsState copyWith({
    ProductModel? product,
    bool? isLoading,
    String? error,
  }) {
    return ProductDetailsState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ─── Product Details Notifier ─────────────────────────────────────────────────

class ProductDetailsNotifier extends StateNotifier<ProductDetailsState> {
  ProductDetailsNotifier() : super(const ProductDetailsState());

  final _repo = ProductRepository.instance;

  Future<void> getProductById(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    final product = await _repo.getProductById(id);
    if (product != null) {
      state = state.copyWith(product: product, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false, error: 'Product not found');
    }
  }
}

final productDetailsProvider =
    StateNotifierProvider<ProductDetailsNotifier, ProductDetailsState>((ref) {
      return ProductDetailsNotifier();
    });

// ─── Product List State ───────────────────────────────────────────────────────

class ProductListState {
  final List<ProductModel> products;
  final bool isLoading;
  final String? error;
  final int page;
  final int total;

  const ProductListState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.page = 1,
    this.total = 0,
  });

  ProductListState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    String? error,
    int? page,
    int? total,
  }) {
    return ProductListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      page: page ?? this.page,
      total: total ?? this.total,
    );
  }
}

// ─── Product List Notifier ────────────────────────────────────────────────────

class ProductListNotifier extends StateNotifier<ProductListState> {
  ProductListNotifier() : super(const ProductListState());

  final _repo = ProductRepository.instance;

  Future<void> getProducts({
    bool refresh = false,
    String? categoryId,
    String? search,
  }) async {
    if (state.isLoading) return;

    final nextPage = refresh ? 1 : state.page;

    state = state.copyWith(
      isLoading: true,
      error: null,
      products: refresh ? [] : state.products,
      page: nextPage,
    );

    final newProducts = await _repo.getProducts(
      page: nextPage,
      categoryId: categoryId,
      search: search,
    );

    state = state.copyWith(
      products: refresh ? newProducts : [...state.products, ...newProducts],
      isLoading: false,
      page: nextPage + 1,
    );
  }
}

final productListProvider =
    StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
      return ProductListNotifier();
    });
