import 'package:evently/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EventItem extends StatelessWidget {
  const EventItem({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    TextTheme text = Theme.of(context).textTheme;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/birthday.png',
            height: height * 0.23,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),

          child: Column(
            children: [
              Text(
                '21',
                style: text.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Nov',
                style: text.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          width: width - 32,
          bottom: 8,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'This is a Birthday Party',
                    style: text.titleSmall!.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
