import 'package:calendar_scheduler/component/schedule_cart.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/model/schedule_with_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../component/calendar.dart';
import '../component/schedule_bottom_sheet.dart';
import '../component/today_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
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
            TodayBanner(selectedDay: selectedDay),
            SizedBox(height: 8.0,),
            _ScheduleList(selectedDate: selectedDay,),
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
              return ScheduleBottomSheet(selectedDate: selectedDay,);
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

  final DateTime selectedDate;

  const _ScheduleList({
    required this.selectedDate,
    Key? key
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<List<ScheduleWithColor>>(
          stream: GetIt.I<LocalDatabase>().watchSchedulesWithColor(selectedDate),
          builder: (context, snapshot) {

            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }

            if(snapshot.hasData && snapshot.data!.isEmpty){
              return Center(
                child: Text('스케줄이 없습니다.'),
              );
            }

            return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index){
                  return SizedBox(height: 8.0,);
                },
                itemBuilder: (context,index){
                  final scheduleWithColor = snapshot.data![index];
                  return Dismissible(
                    key: ObjectKey(scheduleWithColor.schedule.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction){
                      GetIt.I<LocalDatabase>().removeSchedule(scheduleWithColor.schedule.id);
                    },
                    child: GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                            isScrollControlled: true, // 모달의 크기 제한을 없애줌
                            context: context,
                            builder: (_){
                              return ScheduleBottomSheet(selectedDate: selectedDate,scheduleId: scheduleWithColor.schedule.id,);
                            }
                        );
                      },
                      child: ScheduleCard(
                        startTime: scheduleWithColor.schedule.startTime,
                        endTime: scheduleWithColor.schedule.endTime,
                        content: scheduleWithColor.schedule.content,
                        color: Color(int.parse('FF${scheduleWithColor.categoryColor.hexCode}',radix: 16)),
                      ),
                    ),
                  );
                }
            );
          }
        ),
      ),
    );
  }
}

