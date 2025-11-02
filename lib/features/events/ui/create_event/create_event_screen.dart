import 'package:evently/core/models/category_model.dart';
import 'package:evently/core/providers/location_provider.dart';
import 'package:evently/core/providers/setting_provider.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/core/utils/tab_item.dart';

import 'package:evently/features/events/logic/create_event_logic.dart';
import 'package:evently/features/events/logic/location_services.dart';
import 'package:evently/l10n/app_localizations.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:evently/core/utils/localization_helper.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  int currentIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  CategoryModel selectedCategory = CategoryModel.categories.first;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  DateFormat dateFormat = DateFormat('d/M/yyyy');
  LatLng? locationLatLng;
  String? address;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    double height = MediaQuery.sizeOf(context).height;
    TextTheme text = Theme.of(context).textTheme;
    SettingProvider settingProvider = Provider.of<SettingProvider>(context);
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    locationProvider.userLoccation ??
        locationProvider.getCurrentLocation(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.createEvent),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  settingProvider.isDark
                      ? 'assets/images/${selectedCategory.imageName}D.png'
                      : 'assets/images/${selectedCategory.imageName}.png',
                  height: height * 0.23,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            DefaultTabController(
              length: CategoryModel.categories.length,
              child: TabBar(
                onTap: (index) {
                  if (currentIndex == index) return;
                  currentIndex = index;
                  selectedCategory = CategoryModel.categories[currentIndex];
                  setState(() {});
                },
                isScrollable: true,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.only(left: 16),
                tabs:
                    CategoryModel.categories
                        .map(
                          (category) => TabItem(
                            label: appLocalizations.translate(
                              category.translationKey,
                            ),
                            icon: category.icon,
                            isSelected:
                                currentIndex ==
                                CategoryModel.categories.indexOf(category),
                            selectedBackgroundColor: AppColors.primary,
                            selectedForgroundColor:
                                settingProvider.isDark
                                    ? AppColors.black
                                    : AppColors.white,
                            unSelectedForgroundColor: AppColors.primary,
                          ),
                        )
                        .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appLocalizations.title, style: text.titleMedium),
                    const SizedBox(height: 8),
                    DefaultTextFormField(
                      hintText: appLocalizations.eventTitle,
                      prefixIconImageName: 'title',
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalizations.titleEmpty;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(appLocalizations.description, style: text.titleMedium),
                    const SizedBox(height: 8),
                    DefaultTextFormField(
                      hintText: appLocalizations.eventDescription,
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return appLocalizations.descriptionEmpty;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/date.svg',
                          colorFilter: ColorFilter.mode(
                            settingProvider.isDark
                                ? AppColors.white
                                : AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          appLocalizations.eventDate,
                          style: text.titleMedium,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                            );
                            if (date != null) {
                              selectedDate = date;
                              setState(() {});
                            }
                          },
                          child: Text(
                            selectedDate == null
                                ? appLocalizations.selectDate
                                : dateFormat.format(selectedDate!),
                            style: text.titleMedium!.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/time.svg',
                          colorFilter: ColorFilter.mode(
                            settingProvider.isDark
                                ? AppColors.white
                                : AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          appLocalizations.eventTime,
                          style: text.titleMedium,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              selectedTime = time;
                              setState(() {});
                            }
                          },
                          child: Text(
                            selectedTime == null
                                ? appLocalizations.selectTime
                                : selectedTime!.format(context),
                            style: text.titleMedium!.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(appLocalizations.location, style: text.titleMedium),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () async {
                        LatLng? locLatLng = await LocationServices.pickLocation(
                          context,
                        );
                        if (locLatLng != null) {
                          String locAddress =
                              await LocationServices.getLocationAddress(
                                context,
                                locLatLng,
                              );
                          setState(() {
                            locationLatLng = locLatLng;
                            address = locAddress;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.gps_fixed,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child:
                                address != null
                                    ? Text(
                                      address!,
                                      style: text.titleMedium!.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    )
                                    : Text(
                                      appLocalizations.chooseLocation,
                                      style: text.titleMedium!.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    DefaultElevatedButton(
                      label: appLocalizations.addEvent,
                      onPressed: () {
                        CreateEventLogic.createEvent(
                          context: context,
                          formKey: formkey,
                          selectedCategory: selectedCategory,
                          titleController: titleController,
                          descriptionController: descriptionController,
                          selectedDate: selectedDate,
                          selectedTime: selectedTime,
                          locationLatLng: locationLatLng,
                          address: address,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
