import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StudentMyEduCard extends StatelessWidget {
  const StudentMyEduCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      // 개인 요약 정보
      child: IntrinsicHeight(
        // 자식의 최대 높이로 위젯 설정
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CONST_SIZE_20, vertical: CONST_SIZE_16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Row(
                // 상단 메뉴
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '...',
                    style: TextStyle(
                      color: CONST_COLOR_WHITE,
                      fontSize: CONST_TEXT_20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Row(
                // 카드 타이틀
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MY EDU',
                    style: TextStyle(
                      fontSize: CONST_TEXT_20,
                      fontWeight: FontWeight.bold,
                      color: CONST_COLOR_WHITE,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: CONST_SIZE_20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardSubTitle('남 은 과 제'),
                  Expanded(child: renderLinearPercentIndicator(0.8)),
                  _renderBarContent(context, '1/4'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardSubTitle('학 습 진 행'),
                  Expanded(child: renderLinearPercentIndicator(0.8)),
                  _renderBarContent(context, '${0.8 * 100}%'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardSubTitle('과 제 진 행'),
                  Expanded(
                    child: renderLinearPercentIndicator(0.9),
                  ),
                  _renderBarContent(context,'${0.8 * 100}%'),
                ],
              ),
              const SizedBox(height: CONST_SIZE_16),
            ],
          ),
        ),
      ),
    );
  }

  Container _cardSubTitle(title) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.3,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: CONST_SIZE_16,
          fontWeight: FontWeight.bold,
          color: CONST_COLOR_WHITE,
        ),
      ),
    );
  }

  LinearPercentIndicator renderLinearPercentIndicator(double percent) {
    return LinearPercentIndicator(
      animation: true,
      percent: percent,
      // center: Text(
      //   '${percent * 100}%',
      // ),
      progressColor: Colors.white,
    );
  }

  Container _renderBarContent(BuildContext context,content, ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      child: Text(
        content,
        style: const TextStyle(
          fontSize: CONST_TEXT_14,
          color: CONST_COLOR_WHITE,
        ),
      ),
    );
  }
}
