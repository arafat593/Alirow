import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/utils/languages/language_provider.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final languageMap = {"English": "en_US", "Somali": "so_SO"};

  String getLanguageName(String code) {
    return languageMap.entries
        .firstWhere(
          (element) => element.value == code,
          orElse: () => const MapEntry("English", "en_US"),
        )
        .key;
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(languageProvider);
    final selectedLanguage = getLanguageName(languageCode);

    return Scaffold(
      backgroundColor: Colors.white.withValues(alpha: 0.8),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 16),
                  vertical: AppSize.height(value: 22),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: AppSize.size.height * 0.86,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButtonWidget(
                            onTap: () {
                              AppRoutes.instance.go(
                                AppRoutesKey.instance.homeScreen,
                              );
                            },
                            icon: Icons.close,
                          ),
                          Gap(height: 20),

                          /// LANGUAGE ROW
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: "Language",
                                color: AppColors.instance.white50,
                                fontSize: AppSize.width(value: 16),
                                fontWeight: FontWeight.w600,
                                isDynamic: true,
                              ),

                              PopupMenuButton<String>(
                                initialValue: selectedLanguage,
                                color: Colors.black,
                                position: PopupMenuPosition.under,
                                onSelected: (String value) {
                                  final code = languageMap[value] ?? "en_US";

                                  ref
                                      .read(languageProvider.notifier)
                                      .setLanguage(code);
                                },
                                itemBuilder: (BuildContext context) =>
                                    languageMap.keys.map((lang) {
                                      return PopupMenuItem<String>(
                                        value: lang,
                                        child: AppText(
                                          text: lang,
                                          color: AppColors.instance.white50,
                                          fontSize: AppSize.width(value: 16),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }).toList(),

                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText(
                                      text: selectedLanguage,
                                      color: AppColors.instance.white50,
                                      fontSize: AppSize.width(value: 16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Divider(color: AppColors.instance.white50),

                          /// LINKS
                          _buildItem("Privacy & policy", () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.privacyPolicyScreen,
                            );
                          }),

                          Divider(color: AppColors.instance.white50),

                          _buildItem("Terms & conditions", () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.termsConditionScreen,
                            );
                          }),

                          Divider(color: AppColors.instance.white50),

                          _buildItem("About", () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.about,
                            );
                          }),

                          Divider(color: AppColors.instance.white50),

                          _buildItem("FAQ", () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.faq,
                            );
                          }),
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

  Widget _buildItem(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AppText(
        text: title,
        color: AppColors.instance.white50,
        fontSize: AppSize.width(value: 16),
        fontWeight: FontWeight.w600,
        isDynamic: true,
      ),
    );
  }
}
