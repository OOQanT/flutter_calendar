import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {

  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector( // 사용자 터치 반응
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode()); // 탭 아무곳이나
      },
      child: SafeArea(
        bottom: true,
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height/2 + bottomInset,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(
                      onStartSave: (String? val) {
                        startTime = int.parse(val!);
                      },
                      onEndSave: (String? val) {
                        endTime = int.parse(val!);
                      },
                    ),
                    SizedBox(height: 16.0,),
                    _Content(
                      onSaved: (String? val) {
                        content = val;
                      },
                    ),
                    SizedBox(height: 16.0,),
                    _ColorPicker(),
                    SizedBox(height: 8.0,),
                    _SaveButton(onPressed: onSavePressed,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed(){
    //폼키는 생성을 했는데
    // 폼 위젯과 결합을 안했을 때
    if(formKey.currentContext == null){
      return;
    }

    //validate : 폼안에 있는 모든 위젯의 validator 함수가 실행됨
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      print(formKey.currentState);
    }else{
      print('에러');
    }
  }
}


class _Time extends StatelessWidget {

  final FormFieldSetter<String> onStartSave;
  final FormFieldSetter<String> onEndSave;

  const _Time({
    required this.onStartSave,
    required this.onEndSave,
    Key? key
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: CustomTextField(label: '시작 시간', isTime: true,onSaved: onStartSave ,),),
        SizedBox(width: 16.0,),
        Expanded(child: CustomTextField(label: '마감 시간', isTime: true, onSaved: onEndSave,)),
      ],
    );
  }
}

class _Content extends StatelessWidget {

  final FormFieldSetter<String> onSaved;

  const _Content({
    required this.onSaved,
    Key? key
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomTextField(
          label: '내용', isTime: false, onSaved: onSaved,
        )
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap( // 아이템의 수가 많아 지면 자동으로 아래로 줄바꿈 해주는 위젯
      spacing: 8.0, //양옆 간격
      runSpacing: 8.0, // 위 아래 간격
      children: [
        renderColor(Colors.red),
        renderColor(Colors.orange),
        renderColor(Colors.yellow),
        renderColor(Colors.green),
        renderColor(Colors.blue),
        renderColor(Colors.indigo),
        renderColor(Colors.purple),
      ],
    );
  }

  Widget renderColor(Color color){
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 32.0,
      height: 32.0,
    );
  }

}

class _SaveButton extends StatelessWidget {

  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    Key? key
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: PRIMARY_COLOR,
              ),
              child: Text('저장',style: TextStyle(color: Colors.white),)
          ),
        ),
      ],
    );
  }
}





