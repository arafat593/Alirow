import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/screens/home_screen/provider/home_provider.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late double _minPrice;
  late double _maxPrice;
  late String _sortBy;

  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    final homeState = ref.read(homeProvider);
    _minPrice = homeState.minPrice;
    _maxPrice = homeState.maxPrice;
    _sortBy = homeState.sortBy;

    _minPriceController = TextEditingController(
      text: _minPrice.round().toString(),
    );
    _maxPriceController = TextEditingController(
      text: _maxPrice.round().toString(),
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSize.width(value: 20),
        right: AppSize.width(value: 20),
        top: AppSize.height(value: 20),
        bottom:
            AppSize.height(value: 20) +
            MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.instance.white50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "Filter",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          const Gap(height: 24),

          // Price Range
          AppText(
            text: "Price Range",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 5000,
            divisions: 500,
            activeColor: AppColors.instance.primary,
            inactiveColor: AppColors.instance.gray50.withValues(alpha: 0.3),
            labels: RangeLabels(
              '\$${_minPrice.round()}',
              '\$${_maxPrice.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
                _minPriceController.text = _minPrice.round().toString();
                _maxPriceController.text = _maxPrice.round().toString();
              });
            },
          ),
          const Gap(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: AppColors.instance.black600,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    prefixStyle: TextStyle(color: AppColors.instance.black600),
                    prefixText: '\$ ',
                    labelText: 'Min Price',
                    labelStyle: TextStyle(color: AppColors.instance.black600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.instance.black600,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) {
                    final val = double.tryParse(value);
                    if (val != null && val >= 0 && val <= _maxPrice) {
                      setState(() {
                        _minPrice = val;
                      });
                    }
                  },
                ),
              ),
              const Gap(width: 16),
              Expanded(
                child: TextField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: AppColors.instance.black600, // তোমার পছন্দমতো color
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    prefixStyle: TextStyle(color: AppColors.instance.black600),
                    prefixText: '\$ ',
                    labelText: 'Max Price',
                    labelStyle: TextStyle(color: AppColors.instance.black600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.instance.black600,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) {
                    final val = double.tryParse(value);
                    if (val != null && val >= _minPrice && val <= 5000) {
                      setState(() {
                        _maxPrice = val;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const Gap(height: 24),

          // Sort By
          AppText(text: "Sort By", fontSize: 16, fontWeight: FontWeight.w600),
          const Gap(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                [
                  'Popular',
                  'Newest',
                  'Price: Low to High',
                  'Price: High to Low',
                ].map((sortOption) {
                  final isSelected = _sortBy == sortOption;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _sortBy = sortOption;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.instance.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.instance.primary
                              : AppColors.instance.gray50,
                        ),
                      ),
                      child: AppText(
                        text: sortOption,
                        color: isSelected
                            ? Colors.white
                            : AppColors.instance.dark500,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
          ),
          const Gap(height: 32),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: AppSize.height(value: 50),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.instance.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ref
                    .read(homeProvider.notifier)
                    .applyFilter(_minPrice, _maxPrice, _sortBy);
                Navigator.pop(context);
              },
              child: const AppText(
                text: "Apply Filter",
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
