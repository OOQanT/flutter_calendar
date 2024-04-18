import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_scheduler/database/drift_database.dart';

const DEFAULT_COLORS = [ // 무지개색
  'FF33336',
  'FF9800',
  'FFEB3B',
  'FFCAF50',
  '2196F3',
  '3F51B5',
  '9C27B0'
];

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //await initializeDateFormatting(); // 언어팩 초기화

  final database = LocalDatabase();

  final colors = await database.getCategoryColors();
  if(colors.isEmpty){
    for(String hexCode in DEFAULT_COLORS){
      await database.createCategoryColor(
        CategoryColorsCompanion(
          hexCode: Value(hexCode) , 
        )
      );
    }
  }

  print(await database.getCategoryColors());

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: HomeScreen(),
    )
  );
}

