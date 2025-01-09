import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ReadMoreText extends StatefulWidget {
  final String text;


  const ReadMoreText({
    super.key,
    required this.text,
  });

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  late int trimLength;
  bool isExpanded = false;

  @override
  void initState() {
    if(widget.text.length < 100) {
      trimLength = widget.text.length;
    } else {
      trimLength = 100;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = isExpanded ? widget.text : '${widget.text.substring(0, trimLength)}...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryColor,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? 'Read Less' : 'Read More',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
