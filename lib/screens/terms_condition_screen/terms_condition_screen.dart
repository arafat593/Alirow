import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppRoutes.instance.pop();
                      },
                      child: AppImage(
                        path: AppAssertsIconsPath.instance.arrowBack,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    Gap(width: 20),
                    AppText(
                      text: "T&C",
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 22),
                child: SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.instance.grayContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(text: "Terms & conditions",fontSize: 24,fontWeight: FontWeight.w600,),
                          Gap(height: 20),
                          AppText(text: "Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.Under the Specified Commercial Transactions Act (特定商取引法), OmniMarket provides complete transparency regarding product availability, pricing, and refund policies. Our team works closely with Japanese regulators to ensure all transactions are secure and compliant.",fontWeight: FontWeight.w400,fontSize: 16,),
                        ],
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
