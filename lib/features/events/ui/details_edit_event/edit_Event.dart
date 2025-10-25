import 'package:evently/core/models/category_model.dart';
import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/core/utils/localization_helper.dart';
import 'package:evently/core/utils/tab_item.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    // 1. ملء البيانات القديمة
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
        title: const Text('Edit Event'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary, // تم تعديل هذا السطر
          ),
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
                    Text("Title", style: text.titleMedium),
                    const SizedBox(height: 8),
                    DefaultTextFormField(
                      hintText: 'Event Title',
                      prefixIconImageName: 'title',
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Title can not be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text("Description", style: text.titleMedium),
                    const SizedBox(height: 8),
                    DefaultTextFormField(
                      hintText: 'Event Description',
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Description can not be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/date.svg'),
                        const SizedBox(width: 10),
                        Text('Event Date', style: text.titleMedium),
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
                        Text('Event Time', style: text.titleMedium),
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
                      'Location',
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
                                eventModel.address ?? '',
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
                      label: 'Update Event',
                      onPressed: updateEvent,
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

  void updateEvent() async {
    if (formkey.currentState!.validate()) {
      DateTime dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // ✅ حافظ على القيم القديمة لو المستخدم ما غيّرهاش
      EventModel updatedEvent = EventModel(
        userId: FirebaseAuth.instance.currentUser!.uid,
        id: widget.event.id,
        category: selectedCategory,
        title: titleController.text,
        description: descriptionController.text,
        dateTime: dateTime,
        lat: widget.event.lat, // ✅ أضف الإحداثيات القديمة
        long: widget.event.long, // ✅ أضف الإحداثيات القديمة
        address: widget.event.address, // ✅ أضف العنوان القديم
      );

      await FireBaseService.updateEvent(updatedEvent);

      if (mounted) {
        Navigator.of(context).pop(updatedEvent);
      }
    }
  }
}
