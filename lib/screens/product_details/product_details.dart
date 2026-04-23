import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/product_details/porvider/select_item.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetails extends ConsumerWidget {
  const ProductDetails({super.key});

  Future<void> openWhatsApp({required String message}) async {
    final url = Uri.parse(
      "https://wa.me/8801722877869?text=${Uri.encodeComponent(message)}",
    );

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Could not launch WhatsApp: \$e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectImage = ref.watch(selectItem);
    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => AppRoutes.instance.pop(),
                      child: AppImage(
                        path: AppAssertsIconsPath.instance.arrowBack,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    Gap(height: 20),
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
                                url:
                                    "https://images.pexels.com/photos/29345066/pexels-photo-29345066.jpeg?_gl=1*10oj6yy*_ga*MTUzMTc0Mzc0NC4xNzcyNzcyMjYy*_ga_8JE65Q40S6*czE3NzY3NTMzNDUkbzMkZzEkdDE3NzY3NTMzNTAkajU1JGwwJGgw",
                              ),
                            ),
                          ),
                        ),
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
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            child: AppImage(
                                              width: 40,
                                              url:
                                                  "https://images.pexels.com/photos/29345066/pexels-photo-29345066.jpeg?_gl=1*10oj6yy*_ga*MTUzMTc0Mzc0NC4xNzcyNzcyMjYy*_ga_8JE65Q40S6*czE3NzY3NTMzNDUkbzMkZzEkdDE3NzY3NTMzNTAkajU1JGwwJGgw",
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
                    AppText(
                      text: "Maroon Color Hoodie",
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    Gap(height: 10),
                    Row(
                      children: [
                        AppText(
                          text: "\$90",
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red,
                          fontSize: 18,
                        ),
                        Gap(width: 10),
                        AppText(
                          text: "\$80",
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Gap(height: 10),
                    AppText(
                      text: "Product Details",
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    Gap(height: 10),
                    AppText(
                      text:
                          "A premium selection of fresh Atlantic salmon, tuna, and yellowtail sashimi, paired with our signature dragon rolls and nigiri. Served with authentic pickled ginger, wasabi, and premium soy sauce. Perfect for sharing.",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    Gap(height: 10),
                    AppButton(
                      onTap: () async {
                        // Create a well-formatted message with product details
                        final String orderMessage = '''
Hello Admin, I would like to order this product:

*Product Details:*
🛍️ *Name:* Maroon Color Hoodie
💰 *Price:* \$80
📝 *Description:* A premium selection of fresh Atlantic salmon, tuna, and yellowtail sashimi, paired with our signature dragon rolls and nigiri...

🖼️ *Product Image:*
https://images.pexels.com/photos/29345066/pexels-photo-29345066.jpeg?_gl=1*10oj6yy*_ga*MTUzMTc0Mzc0NC4xNzcyNzcyMjYy*_ga_8JE65Q40S6*czE3NzY3NTMzNDUkbzMkZzEkdDE3NzY3NTMzNTAkajU1JGwwJGgw

Please let me know the next steps for payment and delivery!
''';

                        // Open WhatsApp directly
                        await openWhatsApp(message: orderMessage);
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
