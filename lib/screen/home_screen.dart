import 'package:calendar_scheduler/component/schedule_cart.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../component/calendar.dart';
import '../component/schedule_bottom_sheet.dart';
import '../component/today_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime? focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: renderFloatingActionButton(),
        body: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay!,
              onDaySelected: onDaySelected,
            ),
            TodayBanner(selectedDay: selectedDay, scheduleCount: 3,),
            SizedBox(height: 8.0,),
            _ScheduleList(),
          ],
        )
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton(){
    return FloatingActionButton(
      onPressed: (){
        showModalBottomSheet(
            isScrollControlled: true, // 모달의 크기 제한을 없애줌
            context: context,
            builder: (_){
              return ScheduleBottomSheet();
            }
        );
      },
      child: Icon(Icons.add,color: Colors.white,),
      backgroundColor: PRIMARY_COLOR,
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay){ // 날짜를 클릭했을 때 그 날짜를 변수에 담는 로직
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }

}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
            separatorBuilder: (context, index){
              return SizedBox(height: 8.0,);
            },
            itemCount: 3,
            itemBuilder: (context,index){
              return ScheduleCard(startTime: 8,endTime: 9,content: "프로그래밍 공부하기",color: Colors.red,);
            }
        ),
      ),
    );
  }
}

