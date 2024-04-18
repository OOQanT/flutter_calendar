import 'package:drift/drift.dart';

//테이블과 매핑되는 클래스
class Schedules extends Table{
  //PK
  IntColumn get id => integer().autoIncrement()(); // 값 자동 증가

  // 내용
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작 시간
  IntColumn get startTime => integer()();

  // 끝 시간
  IntColumn get endTime => integer()();

  // Category Color Table ID
  IntColumn get colorId => integer()();

  //생성 날짜
  DateTimeColumn get createAt => dateTime().clientDefault( // 시간 자동 생성
          () => DateTime.now(),
  )();
}