import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final ScrollController homeScrollController;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    required this.homeScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GNav(
            color: Colors.grey[700],
            activeColor: Colors.grey[500],
            iconSize: 30,
            gap: 10,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 1),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutExpo,
            onTabChange: (index) {
              if (index == 0 && selectedIndex == 0) {
                homeScrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
              onTabChange(index);
            },
            selectedIndex: selectedIndex,
            tabs: [
              GButton(icon: Icons.home, text: tr("nav_bar.home"),textStyle: AppTextStyles.body,),
              GButton(icon: Icons.account_circle, text: tr("nav_bar.profile"), textStyle: AppTextStyles.body,),
            ],
          ),
        ),
      ),
    );
  }
}
