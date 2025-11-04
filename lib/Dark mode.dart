// ignore_for_file: file_names, use_full_hex_values_for_flutter_colors
import 'package:flutter/material.dart';



class ColorNotifire with ChangeNotifier {


  get textColorGrey => isDark ? const Color(0xFFFFD54F) : const Color(0xff64748B);
  get imageColor => isDark ? Colors.white : const Color(0xFFD32F2F);
  get buttonBorder => isDark ? Colors.white : const Color(0xffEBEBEB);
  get textColor_1 => isDark ? const Color(0xFFFFE082) : const Color(0xFFD32F2F);
  get dotColor => isDark ? const Color(0xFF3A1515) : const Color(0xffEDF5FF);
  get tabColor => isDark ? const Color(0xFF2A1212) : Colors.grey.shade100;
  get tabTextColor => isDark ? Colors.white : Colors.white;
  get iconColor => isDark ? const Color(0xFFFFE082) : const Color(0xffCBD5E1);
  get floatingAction => isDark ? const Color(0xFFD32F2F) : const Color(0xFFD32F2F);
  get bottomNavigationColor => isDark ? const Color(0xFF2A1212) : Colors.white;
  get messageBackColor => isDark ? const Color(0xFF2A1212) : const Color(0xffF8F8F8);
  get messageTextColor => isDark ? Colors.white : const Color(0xff0F172A);
  get tabBorder => isDark ? const Color(0xFF4A1F1F) : const Color(0xffF1F5F9);
  get bottomSheetColor => isDark ? const Color(0xFF2A1212) : Colors.white;
  get mentorDetailTextColor => isDark ? const Color(0xFFFFECB3) : const Color(0xff64748B);
  get paymentCardColor => isDark ? const Color(0xFF2A1212) : Colors.transparent;
  get dividedColor => isDark ? const Color(0xFF4A1F1F) : const Color(0xffE2E8F0);
  get containerDividedColor => isDark ? const Color(0xFF2A1212) : const Color(0xffF1F5F9);







  get outlinedButtonColor=> isDark ? const Color(0xFFD32F2F) : const Color(0xFFD32F2F);
  get background => isDark ? const Color(0xFF1A0B0B) : Colors.white;
  get onboardBackgroundColor => isDark ? const Color(0xFF2A1212) : const Color(0xffF8F9FD);
  get textColor => isDark ? Colors.white : const Color(0xff0F172A);
  get getContainerBorder => isDark ? const Color(0xFF4A1F1F) : const Color(0xffE2E8F0);
  get checkBox => isDark ? const Color(0xFFFFC107) : const Color(0xFFD32F2F);
  get radioButton => isDark ? const Color(0xFFFFC107) : const Color(0xFFD32F2F);
  get textField => isDark ? const Color(0xFF2E1212) : const Color(0xffF8F9FD);
  get textField1 => isDark ? const Color(0xFFD32F2F) : Colors.blue;
  get textFieldHintText => isDark ? const Color(0xFFFFCC80) : const Color(0xff94A3B8);
  get passwordIcon => isDark ? const Color(0xFFFFCC80) : const Color(0xff94A3B8);
  get tabBar1 => isDark ? const Color(0xFF2A1212) : const Color(0xFFFFEBEE);
  get tabBar3 => isDark ? const Color(0xFFD32F2F) : const Color(0xFFD32F2F);
  get tabBar4=> isDark ? const Color(0xFF1A0B0B) : const Color(0xffFFFFFF);
  get tabBar2 => isDark ? const Color(0xFF2A1212) : const Color(0xffF8F9FD);
  get tabBarText1 => isDark ? const Color(0xFFFFC107) : const Color(0xFFD32F2F);
  get tabBarText2 => isDark? Colors.grey: Colors.grey;
  get bottom => isDark?const Color(0xffFFFFFF) : const Color(0xff0F172A);
  get earn => isDark?Colors.transparent:const Color(0xffFFFFFF);
  get container => isDark ? const Color(0xFF2A1212) : const Color(0xffFFFFFF);
  get divider => isDark ? const Color(0xFF4A1F1F) : const Color(0xffE2E8F0);
  get linerIndicator => isDark ? const Color(0xFF3D1A1A) : const Color(0xffF1F5F9);
  get sort => isDark ? const Color(0xFF2A1212) : const Color(0xffE2E8F0);
  get iconButton => isDark ? const Color(0xFF4A1F1F) : const Color(0xffFFFFFF);





  bool _isDark = false;
  bool get isDark => _isDark;

  void isavalable(bool value) {
    _isDark = value;
    notifyListeners();
  }
}
