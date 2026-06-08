import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class CustomSelectedOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  const CustomSelectedOption({super.key, required this.title, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.instance.primary : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: isSelected ? AppColors.instance.primary : AppColors.instance.green20, width: 1.5),
            boxShadow: isSelected
                ? [BoxShadow(color: AppColors.instance.primary.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))]
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            child: Center(
              child: AppText(
                text: title,
                fontSize: AppSize.width(value: 15),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                isDynamic: true,
                color: isSelected ? Colors.white : AppColors.instance.textBlack500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
