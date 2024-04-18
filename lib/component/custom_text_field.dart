import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {

  final String label;
  final bool isTime; // true-시간 false-내용
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    Key? key,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w600
            ),
        ),
        if(isTime)renderTextField(),
        if(!isTime)Expanded(child: renderTextField()),
      ],
    );
  }

  Widget renderTextField(){
    return TextFormField(

      onSaved: onSaved,

      //에러가 있으면 String으로 반환해준다.
      validator: (String? val){ // null이 return 되면 에러가 없다
        if(val == null || val.isEmpty){
          return '값을 입력해주세요';
        }

        if(isTime){
          int time = int.parse(val);

          if(time < 0){
            return '0이상의 숫자를 입력해주세요.';
          }
          if(time > 24){
            return '24이하의 숫자를 입력해주세요.';
          }
        }else{
            if(val.length > 500){
              return '500자 이하의 글자를 입력해주세요.';
            }
        }

        return null;
      },
      cursorColor: Colors.grey,
      maxLines: isTime ? 1 : null, // 택스트 필드 줄바꿈 라인 개수 지정
      expands: !isTime,
      //maxLength: 500,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime ? [
        FilteringTextInputFormatter.digitsOnly, // 숫자 입력만 받게 해줌
      ] : [],
      decoration: InputDecoration(
        border: InputBorder.none,  //텍스트 필트 밑줄 제거
        filled: true,       // 이 속성을 true로 해줘야 텍스트 필드에 색을 넣을 수 있음
        fillColor: Colors.grey[300],

      ),
    );
  }
}
