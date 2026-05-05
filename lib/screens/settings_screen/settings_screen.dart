import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: "Language",
                                color: AppColors.instance.white50,
                                fontSize: AppSize.width(value: 16),
                                fontWeight: FontWeight.w600,
                              ),
                              PopupMenuButton<String>(
                                initialValue: _selectedLanguage,
                                color: Colors.black,
                                position: PopupMenuPosition.under,
                                onSelected: (String value) {
                                  setState(() {
                                    _selectedLanguage = value;
                                  });
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'English',
                                    child: AppText(
                                      text: "English",
                                      color: AppColors.instance.white50,
                                      fontSize: AppSize.width(value: 16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Somali',
                                    child: AppText(
                                      text: "Somali",
                                      color: AppColors.instance.white50,
                                      fontSize: AppSize.width(value: 16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText(
                                      text: _selectedLanguage,
                                      color: AppColors.instance.white50,
                                      fontSize: AppSize.width(value: 16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(Icons.keyboard_arrow_down, color: AppColors.instance.white50),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: AppColors.instance.white50,
                            thickness: 1.2,
                          ),
                          GestureDetector(
                            onTap: (){
                              AppRoutes.instance.pushNamed(AppRoutesKey.instance.privacyPolicyScreen);
                            },
                            child: AppText(
                              text: "Privacy & policy",
                              color: AppColors.instance.white50,
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Divider(
                            color: AppColors.instance.white50,
                            thickness: 1.2,
                          ),
                          GestureDetector(
                            onTap: (){
                              AppRoutes.instance.pushNamed(AppRoutesKey.instance.termsConditionScreen);
                            },
                            child: AppText(
                              text: "Terms & conditions",
                              color: AppColors.instance.white50,
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Divider(
                            color: AppColors.instance.white50,
                            thickness: 1.2,
                          ),
                          GestureDetector(
                            onTap: (){
                              AppRoutes.instance.pushNamed(AppRoutesKey.instance.about);
                            },
                            child: AppText(
                              text: "About",
                              color: AppColors.instance.white50,
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Divider(
                            color: AppColors.instance.white50,
                            thickness: 1.2,
                          ),
                          GestureDetector(
                            onTap: (){
                              AppRoutes.instance.pushNamed(AppRoutesKey.instance.faq);
                            },
                            child: AppText(
                              text: "FAQ",
                              color: AppColors.instance.white50,
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
