import 'package:flutter/material.dart';
import 'package:marlo_task/constants.dart';
import 'package:marlo_task/marlo_app.dart';
import 'package:marlo_task/providers/data_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DataManager dataManager = DataManager();
    return ChangeNotifierProvider(
        create: (context) => dataManager,
        builder: (context, child) {
          dataManager = Provider.of<DataManager>(context);
          debugPrint("--------------------rebuilding Marlo App-----------------------");
          return MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            darkTheme: darkTheme,
            themeMode: dataManager.themeMode,
            debugShowCheckedModeBanner: false,
            home: const MarloApp(),
          );
        });
  }
}
