import 'package:evently/core/models/category_model.dart';
import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/core/utils/localization_helper.dart';
import 'package:evently/core/utils/tab_item.dart';
import 'package:evently/features/events/logic/edit_event_logic.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class EditEventScreen extends StatefulWidget {
  final EventModel event;
  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late int currentIndex;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  late CategoryModel selectedCategory;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  DateFormat dateFormat = DateFormat('d/M/yyyy');

  @override
  void initState() {
    super.initState();
    currentIndex = CategoryModel.categories.indexOf(widget.event.category);
    selectedCategory = widget.event.category;
    selectedDate = widget.event.dateTime;
    selectedTime = TimeOfDay.fromDateTime(widget.event.dateTime);
    titleController = TextEditingController(text: widget.event.title);
    descriptionController = TextEditingController(
      text: widget.event.description,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    double height = MediaQuery.sizeOf(context).height;
    TextTheme text = Theme.of(context).textTheme;
    var eventModel = ModalRoute.of(context)!.settings.arguments as EventModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.editEvent),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/${selectedCategory.imageName}.png',
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
                            selectedForgroundColor: AppColors.white,
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
                        SvgPicture.asset('assets/icons/date.svg'),
                        const SizedBox(width: 10),
                        Text(
                          appLocalizations.eventDateLabel,
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
                              initialDate: selectedDate,
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                            );
                            if (date != null) {
                              selectedDate = date;
                              setState(() {});
                            }
                          },
                          child: Text(
                            dateFormat.format(selectedDate),
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
                        SvgPicture.asset('assets/icons/time.svg'),
                        const SizedBox(width: 10),
                        Text(
                          appLocalizations.eventTimeLabel,
                          style: text.titleMedium,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (time != null) {
                              selectedTime = time;
                              setState(() {});
                            }
                          },
                          child: Text(
                            selectedTime.format(context),
                            style: text.titleMedium!.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      appLocalizations.locationLabel,
                      style: text.titleMedium!.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/location.svg'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                eventModel.address ??
                                    appLocalizations.eventLocationNotAvailable,
                                style: text.titleMedium!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DefaultElevatedButton(
                      label: appLocalizations.updateEvent,
                      onPressed: () {
                        EditEventLogic.updateEvent(
                          context: context,
                          formKey: formkey,
                          oldEvent: widget.event,
                          selectedDate: selectedDate,
                          selectedTime: selectedTime,
                          title: titleController.text,
                          description: descriptionController.text,
                          category: selectedCategory,
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
