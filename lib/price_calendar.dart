import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceRecord {
  final double price;
  final String unit;
  final String note;
  final DateTime date;

  PriceRecord({
    required this.price,
    required this.unit,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'unit': unit,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory PriceRecord.fromMap(Map<String, dynamic> map) {
    return PriceRecord(
      price: map['price'] as double,
      unit: map['unit'] as String,
      note: map['note'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
}

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
  late DateTime _currentMonth;
  DateTime? _selectedDate;
  final Map<DateTime, PriceRecord> _records = {};

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now();
    // 加载测试数据
    _loadSampleData();
  }

  void _loadSampleData() {
    final now = DateTime.now();
    setState(() {
      _records[now] = PriceRecord(
        price: 12.5,
        unit: '斤',
        note: '超市购买',
        date: now,
      );
      _records[now.subtract(const Duration(days: 2))] = PriceRecord(
        price: 11.8,
        unit: '斤',
        note: '菜市场',
        date: now.subtract(const Duration(days: 2)),
      );
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _unitController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      final record = _records[date];
      _priceController.text = record?.price.toString() ?? '';
      _unitController.text = record?.unit ?? '';
      _noteController.text = record?.note ?? '';
    });
  }

  void _saveRecord() {
    if (_selectedDate == null) return;

    final price = double.tryParse(_priceController.text);
    if (price == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的价格')));
      return;
    }

    final unit = _unitController.text;
    if (unit.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入单位')));
      return;
    }

    setState(() {
      _records[_selectedDate!] = PriceRecord(
        price: price,
        unit: unit,
        note: _noteController.text,
        date: _selectedDate!,
      );
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('保存成功')));
  }

  Widget _buildCalendar() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday;

    final List<Widget> dayWidgets = [];

    // 添加星期标题
    dayWidgets.addAll(
      ['日', '一', '二', '三', '四', '五', '六'].map(
        (day) => Container(
          alignment: Alignment.center,
          child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );

    // 添加空白格子（上个月的日期）
    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    // 添加当月日期
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final hasRecord = _records.containsKey(date);
      final isSelected =
          _selectedDate != null &&
          _selectedDate!.year == date.year &&
          _selectedDate!.month == date.month &&
          _selectedDate!.day == date.day;

      dayWidgets.add(
        GestureDetector(
          onTap: () => _onDateSelected(date),
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Colors.blue.withOpacity(0.3)
                      : hasRecord
                      ? Colors.blue.withOpacity(0.1)
                      : null,
              borderRadius: BorderRadius.circular(4),
              border: isSelected ? Border.all(color: Colors.blue) : null,
            ),
            alignment: Alignment.center,
            child: Text('$day'),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      children: dayWidgets,
    );
  }

  Widget _buildRecordForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _selectedDate == null
                  ? '请选择日期'
                  : '记录日期: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: '价格',
                hintText: '输入价格',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _unitController,
              decoration: const InputDecoration(
                labelText: '单位',
                hintText: '输入单位（如：斤、kg等）',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: '备注',
                hintText: '输入备注信息',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _saveRecord, child: const Text('保存记录')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Center(
            child: Text(
              '记账日历',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          // 月份导航
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
              ),
              Text(
                DateFormat('yyyy年MM月').format(_currentMonth),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 日历
          _buildCalendar(),
          const SizedBox(height: 24),
          // 记录表单
          _buildRecordForm(),
          widget.bottomGap,
        ],
      ),
    );
  }
}
