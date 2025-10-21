import 'package:flutter/material.dart';

BottomNavigationBarItem buildBottomNavItem(
    String path, bool isDarkMode, Size size,String label) {
  return BottomNavigationBarItem(
    icon: SizedBox(
      height: size.width * 0.1,
      width: size.width * 0.1,
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
        child: Image.asset(
          path,
        ),
      ),
    ),
    label: label,
  );
}
