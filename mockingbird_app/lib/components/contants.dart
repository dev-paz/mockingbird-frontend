import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2)
    ),
    hintText: "Email",
    fillColor: Colors.white,
    filled: true,
  );