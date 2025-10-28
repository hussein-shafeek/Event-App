import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/providers/setting_provider.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class MapEventItem extends StatelessWidget {
  final EventModel event;
  const MapEventItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final settingProvider = Provider.of<SettingProvider>(context);
    final lang = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsetsDirectional.symmetric(vertical: height * 0.02).copyWith(
        bottom: height * 0.05,
        start: width * 0.035,
        end: width * 0.04,
      ),
      padding: EdgeInsetsDirectional.symmetric(
        vertical: height * 0.02,
        horizontal: width * 0.02,
      ),
      height: height * 0.2,
      constraints: BoxConstraints(maxWidth: width * 0.83),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.4),
        border: Border.all(width: 2, color: AppColors.primary),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 10,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              settingProvider.isDark
                  ? 'assets/images/${event.category.imageName}D.png'
                  : 'assets/images/${event.category.imageName}.png',
              width: width * 0.375,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    Expanded(
                      child: Text(
                        event.address ?? lang.eventLocationNotAvailable,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
