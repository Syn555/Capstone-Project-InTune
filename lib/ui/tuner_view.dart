import 'package:flutter/material.dart';

class TunerView extends StatefulWidget{
  const TunerView({Key? key, required this.frequency}) : super(key: key);
  final double frequency;

  @override
  State<TunerView> createState() => _TunerView();
}
class _TunerView extends State<TunerView>{
  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: 300,
      height: 150,
      child: CustomPaint(
        painter: TunerPainter(frequency: widget.frequency),
      ),
    );
  }
}
class TunerPainter extends CustomPainter {
  TunerPainter({required this.frequency});
  double frequency;

  @override
  void paint(Canvas canvas, Size size) {
    //Too Low Segment
    final tooLow = Paint()
      ..color = Colors.red[300]!
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;
    const x1 = Offset(45, 75);
    const y1 = Offset(155, 35);
    final tooLowRect = Rect.fromPoints(x1, y1);
    canvas.drawRect(tooLowRect, tooLow);

    //Too High Segment
    final tooHigh = Paint()
      ..color = Colors.red[300]!
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;
    const x2 = Offset(165, 75);
    const y2 = Offset(275, 35);
    final tooHighRect = Rect.fromPoints(x2, y2);
    canvas.drawRect(tooHighRect, tooHigh);

    //Tuned Segment
    final tuned = Paint()
      ..color = Colors.green[400]!
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;
    const x3 = Offset(155, 75);
    const y3 = Offset(165, 35);
    final tunedRect = Rect.fromPoints(x3, y3);
    canvas.drawRect(tunedRect, tuned);

    //Tuning Line
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    var width = 160 + (-frequency * 5);
    canvas.drawLine(
      Offset(width, 75),
      Offset(width, 35),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}