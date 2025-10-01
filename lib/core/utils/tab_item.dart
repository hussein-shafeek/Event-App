import 'package:evently/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TabItem extends StatelessWidget {
  String label;
  IconData icon;
  bool isSelected;
  Color selectedForgroundColor;
  Color unSelectedForgroundColor;
  Color selectedBackgroundColor;

  TabItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedBackgroundColor,
    required this.unSelectedForgroundColor,
    required this.selectedForgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double width = MediaQuery.sizeOf(context).width;
    TextTheme text = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: isSelected ? null : Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(46),
        color: isSelected ? selectedBackgroundColor : Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color:
                isSelected ? selectedForgroundColor : unSelectedForgroundColor,
          ),
          SizedBox(width: 24),
          Text(
            label,
            style: text.titleMedium!.copyWith(
              color:
                  isSelected
                      ? selectedForgroundColor
                      : unSelectedForgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
