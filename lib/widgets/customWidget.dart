import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colorConstants.dart';

class CustomSmallCard extends StatelessWidget {
  Size size;
  String name;
  Object unit;
  IconData icn;
  CustomSmallCard({
    super.key,
    required this.size,
    required this.name,
    required this.unit,
    required this.icn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(left: 12),
      width: size.width * 0.4,
      decoration: BoxDecoration(
        color: CARD_BACKGROUND_COLOR,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icn,
                color: SUBHEADING_COLOR,
              ),
              SizedBox(width: size.width * 0.01),
              Text(
                name.toUpperCase(),
                style: TextStyle(
                  color: SUBHEADING_COLOR,
                  fontSize: size.height * 0.018,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  letterSpacing: 2.5,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            '$unit',
            style: TextStyle(
              color: WHITE_COLOR,
              fontSize: size.height * 0.03,
              fontFamily: GoogleFonts.orbitron().fontFamily,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
