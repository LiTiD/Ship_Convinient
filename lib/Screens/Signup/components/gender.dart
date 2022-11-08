import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "Male", child: Text("Nam")),
    const DropdownMenuItem(value: "Female", child: Text("Nữ")),
    const DropdownMenuItem(value: "Other", child: Text("Khác")),
  ];
  return menuItems;
}
