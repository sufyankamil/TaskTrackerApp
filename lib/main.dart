import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/features/todo/pages/homepage.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final defaultLightTheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.deepPurple,
    brightness: Brightness.light,
  );

  static final defaultDarkTheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.deepPurple,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 825),
      minTextAdapt: true,
      builder: (context, child) {
        return DynamicColorBuilder(builder: (lightColor, darkColor) {
          return MaterialApp(
            title: 'To Do',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: AppConst.kBkDark,
              colorScheme: lightColor ?? defaultLightTheme,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColor ?? defaultDarkTheme,
              scaffoldBackgroundColor: AppConst.kBkDark,
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        });
      },
    );
  }
}
