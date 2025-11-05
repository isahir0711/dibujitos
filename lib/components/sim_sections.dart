import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dibujitos/models/drawing.dart';
import 'package:dibujitos/services/sim_painter.dart';
import 'package:flutter/material.dart';

class SimSection extends StatefulWidget {
  const SimSection({super.key});

  @override
  State<SimSection> createState() => _SimSectionState();
}

class _SimSectionState extends State<SimSection> {
  List<DrawingLine> lines = [];

  //TODO: SHOW DRAWING SIM, THIS WORKS FOR A IN-APP GALLERY WHERE YOU CAN WATCH THE DRAWINGS WITHOUTH HAVING TO STORE THE IMAGE ON THE DEVICE
  void foo() {
    String base64Lines =
        "H4sIAAAAAAAAA72WTW4UQQyF79Lr6Ml2+a9mywWQWLBALBBJICLKREmQQBF3R81Md1dVMyzZZcZfXC77+dV8eJ2Ot7fPNy/P0+HD63T9YzpwBCoTm4tdTdc/pwMXhaoVFvt1tUAGFqZaYoUI7qd/WymvsKypGyUKKtZTVkHnMBdksTnrFlU4mXquOahClZXaHKXCKJKXmmugaHh3jgici2xQGrqjqCKpzTK3QuzPFxtEyEprc6KghnQHVe8J2ROE9OD1SkGorn/6tCDBsNKfM/TNT9WfwwY7NWkNSxuOXZiacNIYLmUZ+TKZRG0BEbSdYtW1uZtIUNsUphB16lpeRq0FI6iTmsDag5JBp8ZcJAzE1f6VpCrGYkfCd4RDq2xDE0pIlHZoojhf8IxwQKp0jSuO0s5exFDPiRdGGZ0ORRKDggRmac1R6rA6KJ4YzfKJVogNvXMHd+slHijDDqZhDQfBRzeo3IhJguHRb40Qo7MLCfkLJGBtC74AtXHq1XIp/PFqevx09/AyHV6nz8f749N0UInkSpR0NT2/PB2/3by/u375OrcN61dvPj1Oh+nd8jeejt8frqc5+vP+ZjpMb+ekdw9f3s2fcXt3fz/9mmvZuWoWULMLswpGfxoRO2/YRUAxuOAASGAw5FRsljKb8bAm6dCzV22OvOhjG3egNfX0wRqIFq86AwXKMTCBaBcuBFz764j4avQnyAzsQ6LikLZiDWSRXhTOKOxNIlVIDLvrti7QZWi2p06j6mvqDSr93XTeqJp9otqZo8nOKCS9X4fZskekdk8NM6Gd9z4eGG80IlIx3icTbR2sBsrOIebrRPdecSQG3UgoqH3IM9FbrHgdnujZqcfXU8xgzK2HUsCHVMaN1IVlWCbRWH+JLIyBBgcVZbTliDBqb35SpD2orEa3yXj+rbTGc9c7rjBuxSCqiOxfe5l/Gm2EMVyys3Jhwmm2C2OIQv0IyFGiM2IvGERFumN8x8iOqTuGRyZkx9CO2dezZwQmvYz/Cf1X9//4G+U3Kn5VCwAA";
    Uint8List decodedBytes = base64.decode(base64Lines);
    List<int> decompressJson = gzip.decode(decodedBytes);
    String jsonString = utf8.decode(decompressJson);
    final List<dynamic> decodedJson = jsonDecode(jsonString);
    // final List<DrawingLine> lines2 = decodedJson.map((line) => DrawingLine.fromJson(line as Map<String, dynamic>)).toList();
    final List<DrawingLine> lines2 = List<DrawingLine>.from(decodedJson.map((line) => DrawingLine.fromJson(line)));
    lines = lines2;

    // for (var i = 0; i < lines2.length; i++) {
    //   //Change the current paintOptions to match the current line

    //   // //Draw the offset for each line, with a delay so we can mimic the drawing effect
    //   // for (var offset in lines2[i].offsets) {
    //   //   await Future.delayed(Duration(milliseconds: 20));
    //   //   tempPoints.add(offset);
    //   //   // notifyListeners();
    //   // }

    //   //We add the temporary drawed line into the lines arr, so we can undo or save them later
    //   // final tempPaint = Paint()
    //   //   ..color = lines2[i].paint.color
    //   //   ..isAntiAlias = true
    //   //   ..strokeWidth = lines2[i].paint.strokeWidth
    //   //   ..strokeCap = StrokeCap.round;
    //   lines.add(lines2[i]);
    //   // tempPoints.clear();
    //   // notifyListeners();
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    foo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      width: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.08), blurRadius: 12, spreadRadius: 0, offset: Offset(0, 4)),
        ],
      ),
      child: CustomPaint(painter: SimPainter(lines)),
    );
  }
}
