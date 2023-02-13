import 'package:cpscom/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/routing/routing_config.dart';

class CpscomApp extends StatelessWidget {
  const CpscomApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return const MaterialApp(
          title: 'CPSCOM',
          debugShowCheckedModeBanner: false,
          initialRoute: initialScreen,
          onGenerateRoute: generateRoutes,
          routes: <String, Widget Function(BuildContext)>{
            // ContactDetailsScreen.routeName: (BuildContext context) =>
            //     ContactDetailsScreen(),
          },
        );
        //);
      },
    );
  }
}
