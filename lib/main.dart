import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/models/user_model.dart';
import 'package:management/common/routes/routes.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/features/auth/controller/user_controller.dart';
import 'package:management/features/onboarding/pages/onboarding.dart';
import 'package:management/features/todo/pages/homepage.dart';
import 'package:management/features/todo/pages/view_notif.dart';
import 'package:management/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userProvider.notifier).refresh();
    List<UserModel> users = ref.watch(userProvider);

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
            home: users.isEmpty ? const OnBoarding() : const HomePage(),
            onGenerateRoute: Routes.onGenerateRoute,
          );
        });
      },
    );
  }
}
