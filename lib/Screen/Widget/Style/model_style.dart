import 'package:flutter/material.dart';

class ModelStyle {
  static const Color black = Color(0xFF000000);
  static const Color bgGreyDisabled = Color(0xFFE5E5E5);
  static Color navyBlue = const Color(0xFF0A0F36);
  static Color lightBlue = const Color.fromARGB(255, 137, 151, 255);
  static Color emerraldGreen = const Color(0xFF30AB30);
  static Color beer = const Color(0xFFFBB117);
  static Color tcDefault = const Color(0xFFE9E9E9);
  static Color tcFocused = const Color(0xFF252525);
  static Color tcDisabled = const Color(0xFF404040);
  static Color tcHover = const Color(0xFF252525);
  static Color bcDisable = const Color(0xFFE5E5E5);
  static Color bcHover = const Color(0xFFFFFFFF);
  static Color bgGreen = const Color(0xFF32BAA5);
  static Color fgYellow = const Color(0xFFF2C94C);
  static Color grey = const Color.fromARGB(255, 201, 204, 204);
  static Color transparent = Colors.transparent;

  static TextStyle get defaultLabelStyle {
    return const TextStyle(
      color: Color.fromARGB(255, 180, 184, 184),
      fontWeight: FontWeight.w400,
      fontSize: 14,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle get defaultTextStyle {
    return const TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 16,
      color: Colors.black,
    );
  }

  static InputBorder get defaultborderStyle {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(
        width: 2,
      ),
    );
  }

  static InputBorder get defaultFocusedBorderStyle {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 201, 204, 204),
        width: 2,
      ),
    );
  }

  static TextStyle get defaultAppBarTextStyle {
    return const TextStyle(
      fontWeight: FontWeight.w900,
      color: Colors.white,
      fontSize: 17,
    );
  }
}
