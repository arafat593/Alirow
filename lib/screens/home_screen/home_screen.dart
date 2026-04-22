import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/home_screen/provider/select_item_provider.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_selected_option.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/product_container.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      "For you",
      "Cloths & shows",
      "Electronics",
      "Groceries",
      "Beauty",
      "Home & Garden",
    ];
    final select = ref.watch(selectItemProvider);
    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 16),
                  vertical: AppSize.width(value: 18),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.instance.grayContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                              Spacer(),
                              GestureDetector(
                                onTap: (){
                                  AppRoutes.instance.pushNamed(AppRoutesKey.instance.settingsScreen);
                                },
                                child: AppImage(
                                  path: AppAssertsIconsPath.instance.drawer,
                                  width: 42,
                                  height: 42,
                                ),
                              ),
                            ],
                          ),
                          Gap(height: 30),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Search by Product Name",
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: Icon(Icons.drag_handle_sharp),
                              filled: true,
                              fillColor: AppColors.instance.dark2A,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyCategoryDelegate(
                child: Container(
                  color: AppColors.instance.white50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.instance.grayContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: SizedBox(
                        height: 42,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return CustomSelectedOption(
                              title: categories[index],
                              onTap: () {
                                ref
                                    .read(selectItemProvider.notifier)
                                    .changeItem(index);
                              },
                              isSelected: select == index,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 16),
                vertical: AppSize.width(value: 18),
              ),
              sliver: SliverToBoxAdapter(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.instance.grayContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      itemCount: 10, // Increased for better scroll demonstration
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            AppRoutes.instance.pushNamed(AppRoutesKey.instance.productDetails);
                          },
                          child: ProductContainer(
                            image: "https://images.pexels.com/photos/29345066/pexels-photo-29345066.jpeg?_gl=1*10oj6yy*_ga*MTUzMTc0Mzc0NC4xNzcyNzcyMjYy*_ga_8JE65Q40S6*czE3NzY3NTMzNDUkbzMkZzEkdDE3NzY3NTMzNTAkajU1JGwwJGgw",
                            title: "Maroon Color How",subtitle: "Maroon Color How",discountPrice: "\$70",salePrice: "\$70",),
                        );
                      },
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _StickyCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyCategoryDelegate({required this.child});

  @override
  double get minExtent => 86.0; // Height of the sticky category bar
  @override
  double get maxExtent => 86.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyCategoryDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}