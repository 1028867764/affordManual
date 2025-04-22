import 'package:flutter/material.dart';

class PriceCalendar extends StatefulWidget {
  final Widget bottomGap;
  final String? productId;

  const PriceCalendar({
    super.key,
    required this.bottomGap,
    required this.productId,
  });

  @override
  State<PriceCalendar> createState() => _PriceCalendarState();
}

class _PriceCalendarState extends State<PriceCalendar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Center(child: Text('记账日历')),
          widget.bottomGap, // 使用传入的底部间距组件
        ],
      ),
    );
  }
}
