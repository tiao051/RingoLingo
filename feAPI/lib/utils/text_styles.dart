import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';

class AppTextStyles {
  // Head 1 Bold
  static const TextStyle head1Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 31,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.black,
  );
  
  // Head 2 Bold
  static const TextStyle head2Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 25,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.black,
  );
  
  // Head 3
  static const TextStyle head3 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: AppColors.white,
  );
  
  // Head 3 Bold
  static const TextStyle head3Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.redNormal,
  );
  
  // Body
  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: AppColors.black,
  );
  
  // White variants
  static const TextStyle head2BoldWhite = TextStyle(
    fontFamily: 'Inter',
    fontSize: 25,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.white,
  );
  
  static const TextStyle head3Black = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: AppColors.black,
  );
  
  static const TextStyle head2BoldGreen = TextStyle(
    fontFamily: 'Inter',
    fontSize: 25,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.greenDark,
  );
  static const TextStyle bodyBold = TextStyle(
    fontFamily: 'YourFontFamily', // Replace with your font
    fontWeight: FontWeight.bold,
    fontSize: 16, // Example size, same as body but bold
    color: AppColors.black, // Example color
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'YourFontFamily', // Replace with your font
    fontWeight: FontWeight.w600, // Semi-bold is common for buttons
    fontSize: 16, // Example size
    color: AppColors.white, // Example color (assuming white text on colored buttons)
  );
}