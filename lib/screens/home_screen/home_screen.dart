import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/home_screen/provider/home_provider.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_selected_option.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/product_container.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/filter_bottom_sheet.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).init();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);

    // index 0 = "All", then API categories
    final categoryLabels = ['All', ...state.categories.map((c) => c.name)];

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref
              .read(homeProvider.notifier)
              .init(), // Calling init() will refresh both categories and products, or we can use refresh() for products only. I'll use init() since they asked to "reload products" but a full refresh might be nicer.
          child: CustomScrollView(
            slivers: [
              // ── Header card ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 16), vertical: AppSize.width(value: 18)),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: AppColors.instance.grayContainer, borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AppImage(
                                path: AppAssertsImagePath.instance.dalsanImage,
                                width: AppSize.width(value: 90),
                                height: AppSize.height(value: 40),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  AppRoutes.instance.pushNamed(AppRoutesKey.instance.settingsScreen);
                                },
                                child: AppImage(path: AppAssertsIconsPath.instance.drawer, width: 42, height: 42),
                              ),
                            ],
                          ),
                          Gap(height: 30),
                          TextField(
                            controller: _searchController,
                            onChanged: (value) => ref.read(homeProvider.notifier).search(value),
                            decoration: InputDecoration(
                              // hintText: "Search by Product Name",
                              hint: AppText(text: "Search by Product Name", isDynamic: true, color: AppColors.instance.gray50),
                              hintStyle: TextStyle(),
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: state.searchQuery.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        ref.read(homeProvider.notifier).search('');
                                      },
                                      child: const Icon(Icons.close),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => const FilterBottomSheet(),
                                        );
                                      },
                                      child: const Icon(Icons.filter_alt_outlined),
                                    ),
                              filled: true,
                              fillColor: AppColors.instance.dark2A,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Sticky category bar ───────────────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyCategoryDelegate(
                  child: Container(
                    color: AppColors.instance.white50,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: AppColors.instance.grayContainer, borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: SizedBox(
                          height: 42,
                          child: state.isCategoryLoading
                              ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categoryLabels.length,
                                  itemBuilder: (context, index) {
                                    return CustomSelectedOption(
                                      title: categoryLabels[index],
                                      isSelected: state.selectedCategoryIndex == index,
                                      onTap: () => ref.read(homeProvider.notifier).selectCategory(index),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Product grid ──────────────────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 16), vertical: AppSize.width(value: 18)),
                sliver: SliverToBoxAdapter(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: AppColors.instance.grayContainer, borderRadius: BorderRadius.circular(12)),
                    child: Padding(padding: const EdgeInsets.all(16), child: _buildGrid(state)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(HomeState state) {
    if (state.isProductLoading) {
      return const Center(
        child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()),
      );
    }

    if (state.products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: AppText(text: 'No products found', fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      itemCount: state.products.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final product = state.products[index];
        return GestureDetector(
          onTap: () {
            AppRoutes.instance.pushNamed(AppRoutesKey.instance.productDetails, extra: product.id);
          },
          child: ProductContainer(
            image: product.thumbnail,
            title: product.name,
            subtitle: product.category?.name ?? '',
            discountPrice: product.hasDiscount ? '\$${product.price.toStringAsFixed(0)}' : null,
            salePrice: '\$${product.salePrice.toStringAsFixed(0)}',
          ),
        );
      },
    );
  }
}

// ─── Sticky delegate ──────────────────────────────────────────────────────────

class _StickyCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyCategoryDelegate({required this.child});

  @override
  double get minExtent => 86.0;
  @override
  double get maxExtent => 86.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(_StickyCategoryDelegate old) => old.child != child;
}
