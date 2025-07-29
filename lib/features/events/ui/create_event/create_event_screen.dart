import 'package:evently/core/models/category_model.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/core/utils/tab_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  int currentIndex = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/sport.png',
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
                setState(() {});
              },
              isScrollable: true,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.only(right: 10),
              padding: EdgeInsets.only(left: 16),
              tabs:
                  CategoryModel.categories
                      .map(
                        (category) => TabItem(
                          label: category.name,
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
                  SizedBox(height: 8),
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
                  SizedBox(height: 16),
                  Text("Description", style: text.titleMedium),
                  SizedBox(height: 8),
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
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/date.svg'),
                      SizedBox(width: 10),
                      Text('Event Date', style: text.titleMedium),
                      Spacer(),
                      InkWell(
                        onTap: () async {
                          DateTime? data = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          );
                          print(data);
                        },
                        child: Text(
                          'Select Date',
                          style: text.titleMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/time.svg'),
                      SizedBox(width: 10),
                      Text('Event Time', style: text.titleMedium),
                      Spacer(),
                      InkWell(
                        onTap: () async {
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          print(time);
                        },
                        child: Text(
                          'Select Time',
                          style: text.titleMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  DefaultElevatedButton(
                    label: 'Add Event',
                    onPressed: createEvent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void createEvent() {
    if (formkey.currentState!.validate()) {}
  }
}
