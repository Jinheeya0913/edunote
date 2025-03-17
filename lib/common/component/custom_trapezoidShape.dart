
import 'package:flutter/material.dart';

class TrapezoidInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TrapezoidClipper(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        color: Colors.grey.shade300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InfoIconWithText(icon: Icons.person, label: '10'), // 예시 인원수
            InfoIconWithText(icon: Icons.star, label: '4.5'), // 예시 평점
            InfoIconWithText(icon: Icons.favorite, label: '25'), // 예시 좋아요 수
          ],
        ),
      ),
    );
  }
}

// 사다리꼴 모양 커스텀 클리퍼
class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.25, 0) // 왼쪽 위로 기울어지게
      ..lineTo(size.width * 0.75, 0) // 오른쪽 위로 기울어지게
      ..lineTo(size.width, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// 아이콘과 텍스트를 함께 배치하는 위젯
class InfoIconWithText extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoIconWithText({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}