import 'package:evently/core/models/category_model.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/setting_provider.dart';
import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/localization_helper.dart';
import 'package:evently/core/utils/tab_item.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeHeader extends StatefulWidget {
  HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    SettingProvider settingProvider = Provider.of<SettingProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    double height = MediaQuery.sizeOf(context).height;
    TextTheme text = Theme.of(context).textTheme;
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 16, bottom: 16),
        height: height * 0.21,
        decoration: BoxDecoration(
          color:
              settingProvider.isDark
                  ? AppColors.backgroundDark
                  : AppColors.primary,
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(24),
            bottomEnd: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appLocalizations.welcomeBack, style: text.titleSmall),
              Text(
                userProvider.currentUser?.name ?? appLocalizations.loading,
                style: text.headlineSmall,
              ),

              SizedBox(height: 16),

              DefaultTabController(
                length: CategoryModel.categories.length + 1,
                child: TabBar(
                  labelPadding: EdgeInsets.only(right: 10),
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,

                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  onTap: (index) {
                    if (currentIndex == index) return;
                    currentIndex = index;
                    CategoryModel? selectedCatogry =
                        currentIndex == 0
                            ? null
                            : CategoryModel.categories[currentIndex - 1];
                    eventsProvider.filterEvents(selectedCatogry);
                    setState(() {});
                  },

                  tabs: [
                    TabItem(
                      label: appLocalizations.all,
                      icon: Icons.all_inbox_outlined,
                      isSelected: currentIndex == 0,
                      selectedBackgroundColor:
                          settingProvider.isDark
                              ? AppColors.primary
                              : AppColors.white,
                      unSelectedForgroundColor: AppColors.white,
                      selectedForgroundColor:
                          settingProvider.isDark
                              ? AppColors.white
                              : AppColors.primary,
                    ),
                    ...CategoryModel.categories.map(
                      (category) => TabItem(
                        label: appLocalizations.translate(
                          category.translationKey,
                        ),
                        icon: category.icon,
                        isSelected:
                            currentIndex ==
                            CategoryModel.categories.indexOf(category) + 1,
                        selectedBackgroundColor: AppColors.white,
                        unSelectedForgroundColor: AppColors.white,
                        selectedForgroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                  //   TabItem(
                  //     label: 'All',
                  //     icon: Icons.abc_outlined,
                  //     isSelected: true,
                  //     selectedBackgroundColor: AppColors.white,
                  //     unSelectedForgroundColor: AppColors.white,
                  //     selectedForgroundColor: AppColors.primary,
                  //   ),
                  //   TabItem(
                  //     label: 'Sport',
                  //     icon: Icons.sports_baseball,
                  //     isSelected: false,
                  //     selectedBackgroundColor: AppColors.white,
                  //     unSelectedForgroundColor: AppColors.white,
                  //     selectedForgroundColor: AppColors.primary,
                  //   ),
                  //   TabItem(
                  //     label: 'Birthday',
                  //     icon: Icons.celebration,
                  //     isSelected: false,
                  //     selectedBackgroundColor: AppColors.white,
                  //     unSelectedForgroundColor: AppColors.white,
                  //     selectedForgroundColor: AppColors.primary,
                  //   ),
                  // ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
