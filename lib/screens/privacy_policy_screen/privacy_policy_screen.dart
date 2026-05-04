import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_html_text.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/screens/privacy_policy_screen/provider/privacy_policy_provider.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyPolicyAsyncValue = ref.watch(privacyPolicyProvider);

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
                      text: "Privacy & Policy",
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 22,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.instance.grayContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: privacyPolicyAsyncValue.when(
                        data: (data) => AppHtmlWidget(
                          html: data,
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.instance.dark500,
                          ),
                        ),

                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, stack) => Center(
                          child: Text('Error loading Privacy Policy: $error'),
                        ),
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
