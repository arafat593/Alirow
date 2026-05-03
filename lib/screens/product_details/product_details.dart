import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/product_details/model/product_model.dart';
import 'package:flutter_riverpod_template/screens/product_details/porvider/product_details_provider.dart';
import 'package:flutter_riverpod_template/screens/product_details/porvider/select_item.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetails extends ConsumerStatefulWidget {
  /// Pass the product id when navigating:
  ///   AppRoutes.instance.pushNamed(AppRoutesKey.instance.productDetails, extra: product.id);
  final String? productId;

  const ProductDetails({super.key, this.productId});

  @override
  ConsumerState<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends ConsumerState<ProductDetails> {
  @override
  void initState() {
    super.initState();
    if (widget.productId != null && widget.productId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(productDetailsProvider.notifier)
            .getProductById(widget.productId!);
      });
    }
  }

  Future<void> _openWhatsApp({required String message}) async {
    final url = Uri.parse(
      "https://wa.me/8801722877869?text=${Uri.encodeComponent(message)}",
    );
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Could not launch WhatsApp: $e");
    }
  }

  String _buildOrderMessage(ProductModel product) {
    final allImages = product.allImages;
    final imageUrl = allImages.isNotEmpty ? allImages.first : '';
    final priceDisplay = product.hasDiscount
        ? '\$${product.salePrice.toStringAsFixed(0)}'
        : '\$${product.price.toStringAsFixed(0)}';

    return '''Hello Admin, I would like to order this product:

*Product Details:*
🛍️ *Name:* ${product.name}
💰 *Price:* $priceDisplay
📝 *Description:* ${product.description ?? 'N/A'}

🖼️ *Product Image:*
$imageUrl

Please let me know the next steps for payment and delivery!
''';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailsProvider);
    final selectImage = ref.watch(selectItem);

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
            ? _buildError(state.error!)
            : state.product != null
            ? _buildContent(state.product!, selectImage)
            : _buildEmpty(),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(error, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (widget.productId != null) {
                ref
                    .read(productDetailsProvider.notifier)
                    .getProductById(widget.productId!);
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(child: Text('No product found'));
  }

  Widget _buildContent(ProductModel product, int selectImage) {
    final allImages = product.allImages;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back button ───────────────────────────────────────────
                GestureDetector(
                  onTap: () => AppRoutes.instance.pop(),
                  child: AppImage(
                    path: AppAssertsIconsPath.instance.arrowBack,
                    height: 40,
                    width: 40,
                  ),
                ),
                Gap(height: 20),

                // ── Image stack ───────────────────────────────────────────
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: AppSize.height(value: 220),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.instance.grayContainer,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AppImage(
                            isZomBle: true,
                            url: allImages.isNotEmpty
                                ? allImages[selectImage.clamp(
                                    0,
                                    allImages.length - 1,
                                  )]
                                : '',
                          ),
                        ),
                      ),
                    ),

                    // Thumbnail strip
                    if (allImages.isNotEmpty)
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 15,
                        child: SizedBox(
                          height: 50,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: allImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 5,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(selectItem.notifier)
                                          .getItem(index);
                                    },
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: selectImage == index
                                              ? AppColors.instance.primary
                                              : Colors.transparent,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: AppImage(
                                            width: 40,
                                            url: allImages[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                Gap(height: 20),

                // ── Product name ──────────────────────────────────────────
                AppText(
                  text: product.name,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),

                Gap(height: 10),

                // ── Price ─────────────────────────────────────────────────
                Row(
                  children: [
                    if (product.hasDiscount) ...[
                      AppText(
                        text: "\$${product.price.toStringAsFixed(0)}",
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red,
                        fontSize: 18,
                      ),
                      Gap(width: 10),
                    ],
                    AppText(
                      text: "\$${product.salePrice.toStringAsFixed(0)}",
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),

                Gap(height: 10),

                // ── Description ───────────────────────────────────────────
                AppText(
                  text: "Product Details",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                Gap(height: 10),
                AppText(
                  text: product.description?.isNotEmpty == true
                      ? product.description!
                      : 'No description available.',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),

                Gap(height: 10),

                // ── Chat to Order button ──────────────────────────────────
                AppButton(
                  onTap: () async {
                    await _openWhatsApp(message: _buildOrderMessage(product));
                  },
                  height: 43,
                  borderRadius: BorderRadius.circular(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppImage(
                        path: AppAssertsIconsPath.instance.callIcon,
                        height: 30,
                      ),
                      Gap(width: 10),
                      AppText(
                        text: "Chat to Order",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                Gap(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
