import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // 1. تعريف متغير الحدث هنا وليس في دالة build
  late EventModel event;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 2. استلام البيانات في didChangeDependencies
    // هذا يسمح لك بالوصول إلى الـ arguments
    event = ModalRoute.of(context)!.settings.arguments as EventModel;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    TextTheme text = Theme.of(context).textTheme;
    final DateFormat formatter = DateFormat('dd MMMM yyyy, hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                AppRoutes.editEvent,
                arguments: event,
              );

              if (mounted && result is EventModel) {
                // 3. تحديث المتغير باستخدام setState
                setState(() {
                  event = result;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.red),
            onPressed: () async {
              await FireBaseService.deleteEvent(event.id);
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/${event.category.imageName}.png',
                  height: height * 0.23,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    event.title,
                    style: text.headlineSmall!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/calinder.svg'),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatter.format(event.dateTime),
                                style: text.titleMedium!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                          Text(
                            'Cairo, Egypt',
                            style: text.titleMedium!.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Image.asset('assets/images/map.png'),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: text.titleMedium!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: text.titleMedium!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
