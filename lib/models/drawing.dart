import 'dart:ui';

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}

class DrawingLine {
  List<Offset> offsets;
  Paint paint;

  DrawingLine(this.offsets, this.paint);

  Map<String, dynamic> toJson() {
    return {
      'offsets': offsets.map((offset) => {'dx': offset.dx, 'dy': offset.dy}).toList(),
      'paint': {
        'color': paint.color.value,
        'strokeWidth': paint.strokeWidth,
        'strokeCap': paint.strokeCap.toString(),
        'style': paint.style.toString(),
      },
    };
  }

  // Add a fromJson factory constructor for deserialization
  factory DrawingLine.fromJson(Map<String, dynamic> json) {
    return DrawingLine(
      (json['offsets'] as List).map((offset) => Offset(offset['dx'], offset['dy'])).toList(),
      Paint()
        ..color = Color(json['paint']['color'])
        ..strokeWidth = json['paint']['strokeWidth']
        ..strokeCap = _parseStrokeCap(json['paint']['strokeCap'])
        ..style = _parsePaintingStyle(json['paint']['style']),
    );
  }

  static StrokeCap _parseStrokeCap(String value) {
    switch (value) {
      case 'StrokeCap.round':
        return StrokeCap.round;
      case 'StrokeCap.square':
        return StrokeCap.square;
      default:
        return StrokeCap.butt;
    }
  }

  static PaintingStyle _parsePaintingStyle(String value) {
    return value == 'PaintingStyle.fill' ? PaintingStyle.fill : PaintingStyle.stroke;
  }
}
