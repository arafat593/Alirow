import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Gap(height: 60,),),
          SliverToBoxAdapter(child: AppImage(path:AppAssertsImagePath.instance.onBoardingIcon),),
          SliverToBoxAdapter(child: Gap(height: 30,),),
          SliverToBoxAdapter(child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: AppSize.width(value: 16)),
            child: AppText(text: "Bridging China to Somalia",fontWeight:FontWeight.w500, fontSize:AppSize.width(value: 30),textAlign: TextAlign.center,),
          ),),
          SliverToBoxAdapter(child: Gap(height: 15,),),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Get the best products from ',
                  style: TextStyle(color: Colors.black,fontSize: AppSize.width(value: 16)),
                  children: const <TextSpan>[
                    TextSpan(text: 'China delivered to Somalia.', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' Browse easily and order instantly via'),
                    TextSpan(text: ' WhatsApp.', style: TextStyle(fontWeight: FontWeight.bold,)),
                  ],
                ),
              ),
            ),
          )),
          SliverToBoxAdapter(child: Gap(height: 40,),),
          SliverToBoxAdapter(child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16),
            child: AppButton(
              title: "Start Shopping",
              onTap: () => AppRoutes.instance.pushNamed(AppRoutesKey.instance.homeScreen),
              backgroundColor: AppColors.instance.primary,height: AppSize.height(value: 49),),
          ),)

        ],
      ),
    );
  }
}
