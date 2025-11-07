
// ignore_for_file: file_names
import 'package:flutter/material.dart';

Widget indicator({required double value}){
  return  LinearProgressIndicator(
    value: value,
    color: const Color(0xFF8B0000),
    backgroundColor: const Color(0xff334155),
  );
}
