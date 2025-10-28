import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final text = Theme.of(context).textTheme;
    final userProvider = Provider.of<UserProvider>(context);
    final t = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    final String userName =
        userProvider.currentUser?.name?.isNotEmpty == true
            ? userProvider.currentUser!.name
            : t.name; // 🔹 لو مفيش اسم يظهر النص المترجم "الاسم"

    final String userEmail =
        userProvider.currentUser?.email?.isNotEmpty == true
            ? userProvider.currentUser!.email
            : t.email; // 🔹 لو مفيش إيميل يظهر النص المترجم "البريد الإلكتروني"

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: isRTL ? Radius.zero : const Radius.circular(64),
          bottomRight: isRTL ? const Radius.circular(64) : Radius.zero,
        ),
      ),
      child: SafeArea(
        child: Row(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Transform(
              alignment: Alignment.center,
              transform:
                  isRTL ? Matrix4.rotationY(math.pi) : Matrix4.identity(),
              child: Image.asset(
                'assets/images/route_profile.png',
                height: height * 0.13,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(userName, style: text.headlineSmall),
                  const SizedBox(height: 10),
                  Text(
                    userEmail,
                    style: text.titleMedium!.copyWith(color: AppColors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
