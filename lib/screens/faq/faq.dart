import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/custom_expansion_tile/custom_expansion_tile.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class Faq extends StatelessWidget {
  const Faq({super.key});

  @override
  Widget build(BuildContext context) {
    final faqData = [
      {
        'question': 'Do I need an account to place an...',
        'answer': 'You can browse as a guest, but you need to create an account to place an order so we can track your delivery and save your preferences.',
      },
      {
        'question': 'How do I change my delivery loc...',
        'answer': 'You can change your delivery location in the app settings or at checkout.',
      },
      {
        'question': 'Can I order from multiple shops...',
        'answer': 'Yes, you can order from multiple shops, but each shop might have its own delivery fee.',
      },
      {
        'question': 'How do I find products from my...',
        'answer': 'You can use the search bar or browse by categories to find products.',
      },
      {
        'question': 'Are the food items fresh?',
        'answer': 'Yes, we ensure all food items are fresh and handled with care.',
      },
      {
        'question': 'Do you sell Halal products?',
        'answer': 'Yes, we have a variety of Halal products available.',
      },
      {
        'question': 'What are your delivery hours?',
        'answer': 'Our delivery services are available from 8:00 AM to 10:00 PM daily.',
      },
      {
        'question': 'How can I track my order?',
        'answer': 'You can track your order in real-time through the "My Orders" section in the app.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 20),
                  vertical: AppSize.height(value: 20),
                ),
                child: Row(
                  children: [
                    IconButtonWidget(
                      icon: Icons.keyboard_double_arrow_left,
                      onTap: () => Navigator.pop(context),
                    ),
                    const Gap(width: 15),
                    AppText(
                      text: "FAQ",
                      fontSize: AppSize.width(value: 32),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),

            // Main FAQ Container
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(AppSize.width(value: 16)),
                  decoration: BoxDecoration(
                    color: AppColors.instance.grayContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Frequently Asked\nQuestions",
                        fontSize: AppSize.width(value: 24),
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      const Gap(height: 20),
                      ...faqData.map((item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppSize.height(value: 12)),
                          child: CustomExpansionTile(
                            tapHeaderToExpand: false,
                            padding: EdgeInsets.all(AppSize.width(value: 16)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            title: AppText(
                              text: item['question']!,
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: AppSize.height(value: 8),
                                  left: AppSize.width(value: 2),
                                ),
                                child: AppText(
                                  text: item['answer']!,
                                  fontSize: AppSize.width(value: 14),
                                  color: AppColors.instance.gray50,
                                  maxLines: 10,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Gap(height: 30)),
          ],
        ),
      ),
    );
  }
}
