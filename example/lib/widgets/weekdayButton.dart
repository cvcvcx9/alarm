import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeekdayButtons extends StatelessWidget {
  final List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final List<int> weekdayValues = [ 1, 2, 3, 4, 5, 6,7];
  final List<int> selectedValues;
  final Function(int) toggleDay;
  WeekdayButtons({required this.selectedValues, required this.toggleDay});



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(weekdays.length, (index) {
        bool isSelected = selectedValues.contains(weekdayValues[index]);
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: SizedBox(
            width: 40, // 버튼의 가로 크기를 100으로 설정
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.blue : Colors.grey, // 선택된 상태에 따른 색상 변경
              ),
              onPressed: () {
                toggleDay(weekdayValues[index]);
                print('Selected values: $selectedValues');
              },
              child: Text('${weekdays[index]}'),
            ),
          ),
        );
      }),
    );
  }
}