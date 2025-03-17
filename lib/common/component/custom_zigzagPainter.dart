

import 'package:flutter/cupertino.dart';

class ZigzagPainter extends CustomPainter {
  final Color color;

  ZigzagPainter({
    super.repaint,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// PAINT 객체는 그리기 스타일과 색상을 정의
    /// PATH 객체는 선을 정의할 수 있는 경로를 생성. moveTo와 lineTo의 메서드를 사용해 경로 그리기 가능
    Paint paint = Paint()..color = color;
    Path path = Path();

    /// 지그재그 효과 상단에 추가
    const zigzagCount = 15; // 지그재그 갯수
    final zigzagWidth = size.width / zigzagCount;

    for (int i = 0; i < zigzagCount; i++) {
      final x = i * zigzagWidth; // 지그재그의 x 좌표
      final y = (i % 2 == 0)
          ? 5  // 지그재그 높이
          : 0; // 지그재그의 y 좌표. i가 짝수이면 10, 홀수일 때는 0 으로 설정하여 위아래로 오르내리는 그림
      path.lineTo(x, y.toDouble()); // lineTo를 이용하여 각각의 꼭짓점을 선으로 연결하여 경로를 만들어줌
    }

    /// 지그재그 경로를 완료한 후 직사각형의 나머지 부분을 lineTo와 close 메서드를 사용해 이어줌
    path.lineTo(size.width, 0); // 우측 상단 모서리로 이동
    path.lineTo(size.width, size.height); // 우측 하단 모서리로 이동
    path.lineTo(0, size.height); // 좌측 하단 모서리로 이동
    path.close(); // 경로를 닫아 사각형 형태 완성

    /// 위에서 정의한 path의 경로에 따라 paint를 사용해 캔버스에 그림을 그림.
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
