import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'product_detail_screen.dart';

class PriceRecord {
  final double price;
  final String unit;
  final String note;
  final DateTime date;
  final String currency;
  final String customizedName;
  final String country; // New field
  final String province; // New field
  final String city; // New field
  final String outLink; // New field

  PriceRecord({
    required this.price,
    required this.unit,
    required this.note,
    required this.date,
    this.currency = 'rmb',
    this.customizedName = '',
    this.country = '', // Default empty string
    this.province = '', // Default empty string
    this.city = '', // Default empty string
    this.outLink = '', // Default empty string
  });

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'unit': unit,
      'note': note,
      'date': date.toIso8601String(),
      'currency': currency,
      'customizedName': customizedName,
      'country': country, // Add to map
      'province': province, // Add to map
      'city': city, // Add to map
      'outLink': outLink, // Add to map
    };
  }

  factory PriceRecord.fromMap(Map<String, dynamic> map) {
    return PriceRecord(
      price: map['price'] as double,
      unit: map['unit'] as String,
      note: map['note'] as String,
      date: DateTime.parse(map['date'] as String),
      currency: map['currency'] as String? ?? 'rmb',
      customizedName: map['customizedName'] as String? ?? '',
      country: map['country'] as String? ?? '', // Load from map
      province: map['province'] as String? ?? '', // Load from map
      city: map['city'] as String? ?? '', // Load from map
      outLink: map['outLink'] as String? ?? '', // Load from map
    );
  }
}

class PriceCalendar extends StatefulWidget {
  final Widget bottomGap;
  final String? productId;
  final String? productName;

  const PriceCalendar({
    super.key,
    required this.bottomGap,
    required this.productId,
    required this.productName,
  });

  @override
  State<PriceCalendar> createState() => _PriceCalendarState();
}

class _PriceCalendarState extends State<PriceCalendar> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;
  final Map<DateTime, PriceRecord> _records = {};
  SharedPreferences? _prefs;
  //这个修改将确保每个产品都有自己独立的最后选择日期存储键
  String get _lastSelectedDateKey => 'last_selected_date_${widget.productId}';

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _customizedNameController =
      TextEditingController();
  String _currency = 'rmb';
  String? _defaultCustomName;
  String get displayName => _defaultCustomName ?? widget.productName ?? '';
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _outLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCalendar();
  }

  Future<void> _initializeCalendar() async {
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _selectedDate = now;

    // 初始化 SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    // 加载记录
    await _loadRecords();

    // 加载默认自定义名称
    await _loadDefaultCustomName();

    // 从 SharedPreferences 读取上次选择的日期
    final lastSelectedDateStr = _prefs?.getString(_lastSelectedDateKey);
    DateTime? lastSelectedDate;

    if (lastSelectedDateStr != null) {
      try {
        lastSelectedDate = DateFormat('yyyy-MM-dd').parse(lastSelectedDateStr);
      } catch (e) {
        // 如果解析失败，忽略
        print('Failed to parse last selected date: $e');
      }
    }

    // 判断是否需要点击今天的日期或上次的日期
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (lastSelectedDate == null) {
        // 如果没有保存的日期，默认点击今天
        _onDateSelected(now);
      } else if (lastSelectedDate.year != now.year ||
          lastSelectedDate.month != now.month ||
          lastSelectedDate.day != now.day) {
        // 如果上次选择的日期不是今天，点击上次的日期
        _onDateSelected(lastSelectedDate);
      } else {
        // 如果上次选择的日期是今天，点击今天的日期（实际上已经选中）
        _onDateSelected(now);
      }
    });
  }

  Future<void> _loadDefaultCustomName() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'default_custom_name_${widget.productId}';
    setState(() {
      _defaultCustomName = prefs.getString(key);
      if (_defaultCustomName != null && _defaultCustomName!.isNotEmpty) {
        _customizedNameController.text = _defaultCustomName!;
      }
    });
  }

  Future<void> _saveDefaultCustomName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'default_custom_name_${widget.productId}';
    await prefs.setString(key, name);
    setState(() {
      _defaultCustomName = name;
    });

    // 更新所有记录的 customizedName
    _records.forEach((date, record) {
      if (record.customizedName != name) {
        _records[date] = PriceRecord(
          price: record.price,
          unit: record.unit,
          note: record.note,
          date: record.date,
          currency: record.currency,
          customizedName: name, // 更新 customizedName
        );
      }
    });

    // 保存更新后的记录
    await _saveRecords();
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'price_records_${widget.productId}';
    final jsonString = prefs.getString(key);

    if (jsonString != null) {
      final decoded = json.decode(jsonString) as Map<String, dynamic>;
      setState(() {
        _records.clear();
        decoded.forEach((dateStr, recordMap) {
          final date = DateTime.parse(dateStr);
          _records[date] = PriceRecord.fromMap(recordMap);
        });
      });
    }
  }

  Future<void> _saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'price_records_${widget.productId}';

    final serializableMap = <String, dynamic>{};
    _records.forEach((date, record) {
      serializableMap[date.toIso8601String()] = record.toMap();
    });

    await prefs.setString(key, json.encode(serializableMap));
  }

  Future<void> _backupRecords() async {
    // Placeholder for backup functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('备份功能将在后续版本中添加')));
  }

  @override
  void dispose() {
    _priceController.dispose();
    _unitController.dispose();
    _noteController.dispose();
    _customizedNameController.dispose();
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

  void _goToToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // 直接调用 _onDateSelected 来模拟点击今天的日期
    _onDateSelected(today);

    setState(() {
      _currentMonth = DateTime(now.year, now.month); // 确保切换到当前月份

      // 更新表单数据
      final record = _records[today];
      _priceController.text = record?.price.toString() ?? '';
      _unitController.text = record?.unit ?? '';
      _noteController.text = record?.note ?? '';
      _customizedNameController.text =
          record?.customizedName ?? _defaultCustomName ?? '';
      _currency = record?.currency ?? 'rmb';
    });
  }

  void _onDateSelected(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    setState(() {
      _selectedDate = dateKey;
      final record = _records[dateKey];
      _priceController.text = record?.price.toString() ?? '';
      _unitController.text = record?.unit ?? '';
      _noteController.text = record?.note ?? '';
      _customizedNameController.text =
          record?.customizedName ?? _defaultCustomName ?? '';
      _currency = record?.currency ?? 'rmb';
    });
    // 保存选择的日期到 SharedPreferences
    _prefs?.setString(
      _lastSelectedDateKey,
      DateFormat('yyyy-MM-dd').format(dateKey),
    );
  }

  Future<void> _saveRecord() async {
    if (_selectedDate == null) return;

    final price = double.tryParse(_priceController.text);
    if (price == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的价格')));
      return;
    }

    final unit = _unitController.text;

    String customName = _customizedNameController.text;

    if (customName.isEmpty) {
      customName = widget.productName ?? '';
    }

    try {
      setState(() {
        final dateKey = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
        );

        if (customName.isNotEmpty && customName != _defaultCustomName) {
          _saveDefaultCustomName(customName);
        }

        _records[dateKey] = PriceRecord(
          price: price,
          unit: unit,
          note: _noteController.text,
          date: dateKey,
          currency: _currency,
          customizedName: customName,
          country: _countryController.text, // New field
          province: _provinceController.text, // New field
          city: _cityController.text, // New field
          outLink: _outLinkController.text, // New field
        );
      });

      await _saveRecords();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('保存成功')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
    }
  }

  Future<void> _clearRecord() async {
    if (_selectedDate == null) return;

    try {
      setState(() {
        _records.remove(_selectedDate);
        _priceController.clear();
        _unitController.clear();
        _noteController.clear();
        _currency = 'rmb';
      });

      await _saveRecords();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('记录已清除')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('清除失败: $e')));
    }
  }

  Widget _buildCalendar() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday;

    final List<Widget> dayWidgets = [];

    // Weekdays header
    dayWidgets.addAll(
      ['日', '一', '二', '三', '四', '五', '六'].map(
        (day) => Container(
          alignment: Alignment.center,
          child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );

    // Empty spaces before the first day of the month
    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Adding day tiles for the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final hasRecord = _records.containsKey(date);
      final isSelected =
          _selectedDate != null &&
          _selectedDate!.year == date.year &&
          _selectedDate!.month == date.month &&
          _selectedDate!.day == date.day;
      final isToday =
          date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;

      final record = _records[date];
      final price = record?.price ?? 0;
      final unit = record?.unit ?? '';
      final currencySymbol =
          record?.currency == 'rmb'
              ? '¥'
              : (record?.currency == 'dollar' ? '\$' : '');

      dayWidgets.add(
        GestureDetector(
          onTap: () => _onDateSelected(date),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? isToday
                          ? Colors.yellow.withOpacity(0.4)
                          : Colors.blue.withOpacity(0.3)
                      : isToday
                      ? Colors.yellow.withOpacity(0.2)
                      : null,
              borderRadius: BorderRadius.circular(1),
              border:
                  hasRecord
                      ? Border.all(color: Colors.grey.withOpacity(0.1))
                      : null,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isToday ? '今' : '$day',
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (hasRecord)
                  Column(
                    children: [
                      Text(
                        '$currencySymbol${price.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7, // Number of columns (7 days in a week)
      crossAxisSpacing: 0, // 设置水平间距为0
      mainAxisSpacing: 0, // 设置垂直间距为0
      children: dayWidgets,
    );
  }

  Future<void> _showEditDialog() async {
    // 确保在构建对话框之前，控制器已经设置了已有值
    if (_selectedDate != null) {
      final record = _records[_selectedDate];
      _countryController.text = record?.country ?? '';
      _provinceController.text = record?.province ?? '';
      _cityController.text = record?.city ?? '';
      _outLinkController.text = record?.outLink ?? '';
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // 使用 StatefulBuilder 包裹对话框内容
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Theme(
              data: ThemeData(
                dialogTheme: DialogThemeData(
                  backgroundColor: Colors.white, // 设置对话框背景色
                ),
              ),
              child: AlertDialog(
                title: Center(
                  child: Text(
                    _selectedDate == null
                        ? '添加记录'
                        : '${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      TextField(
                        controller: _customizedNameController,
                        decoration: InputDecoration(
                          labelText: '自定义名称',
                          hintText: '输入自定义名称（可选）',
                          border: const OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 12),
                        ),
                        style: TextStyle(fontSize: 12),
                        maxLines: null, // 不限制最大行数
                        keyboardType: TextInputType.multiline, // 支持多行文本输入
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          '价格',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: '价格',
                                hintText: '输入价格',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _unitController,
                              decoration: const InputDecoration(
                                labelText: '单位',
                                hintText: '输入单位（如：斤、kg等）',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: 'rmb',
                                groupValue: _currency,
                                onChanged: (String? value) {
                                  setState(() {
                                    _currency = value!;
                                  });
                                },
                              ),
                              const Text('人民币'),
                            ],
                          ),
                          const SizedBox(width: 16), // 添加间距
                          Row(
                            children: [
                              Radio<String>(
                                value: 'dollar',
                                groupValue: _currency,
                                onChanged: (String? value) {
                                  setState(() {
                                    _currency = value!;
                                  });
                                },
                              ),
                              const Text('美元'),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          '地址',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _countryController,
                              decoration: const InputDecoration(
                                labelText: '国家',
                                hintText: '输入国家',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _provinceController,
                              decoration: const InputDecoration(
                                labelText: '省份/州',
                                hintText: '输入省份或州',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: '城市',
                          hintText: '输入城市',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 12),
                        ),
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          '补充说明',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          labelText: '备注',
                          hintText: '输入备注信息',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 12),
                        ),
                        style: TextStyle(fontSize: 12),
                        maxLines: null, // 不限制最大行数
                        keyboardType: TextInputType.multiline, // 支持多行文本输入
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _outLinkController,
                        decoration: const InputDecoration(
                          labelText: '外部链接',
                          hintText: '输入外部链接',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 12),
                        ),
                        style: TextStyle(fontSize: 12),
                        maxLines: null, // 不限制最大行数
                        keyboardType: TextInputType.multiline, // 支持多行文本输入
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        color: Colors.black, // 设置文本颜色为蓝色
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _saveRecord();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      '保存',
                      style: TextStyle(
                        color: Colors.black, // 设置文本颜色为蓝色
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecordSummary() {
    final record = _selectedDate != null ? _records[_selectedDate] : null;
    final displayName = _defaultCustomName ?? widget.productName ?? '';
    final currencySymbol = _currency == 'rmb' ? '¥' : '\$';
    // 格式化日期为年份和月/日
    String? formattedDate;
    if (_selectedDate != null) {
      final year = _selectedDate!.year.toString();
      final monthDay = DateFormat('M/d').format(_selectedDate!);
      formattedDate = '$year\n$monthDay'; // 使用换行符分隔
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow.shade50,
            Colors.yellow.shade50,
            Colors.yellow.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 控制外层容器之间的间距
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 控制内部 Row 的排列方式
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.withOpacity(0.5),
                            Colors.amber.withOpacity(0.4),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            offset: Offset(3, 0),
                            blurRadius: 1,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 年份部分
                          Text(
                            _selectedDate == null
                                ? ''
                                : '${_selectedDate!.year}年',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          // 月/日部分
                          Text(
                            _selectedDate == null
                                ? ''
                                : DateFormat('M/d').format(_selectedDate!),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SelectableText(
                              '${record?.price != null ? currencySymbol : ''} ',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                            SelectableText(
                              record?.price != null ? '${record!.price}' : '',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                            SelectableText(
                              record?.unit?.isNotEmpty ?? false
                                  ? '/ ${record!.unit}'
                                  : '',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SelectableText(
                          record?.price != null
                              ? record?.city.isEmpty ?? false
                                  ? '未知城市'
                                  : record!.city
                              : '',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _selectedDate == null ? null : _showEditDialog,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey, // 文字颜色
                    backgroundColor: Colors.grey.shade100, // 背景色
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // 控制容器之间的间距
                    children: const [
                      Icon(Icons.create), // 使用笔形图标
                      SizedBox(width: 0), // 图标和文字之间的间距
                      Text('修改', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 控制容器之间的间距
              children: [
                Row(
                  children: [
                    Text('🛒', style: TextStyle(fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.all(1),
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                      ).copyWith(left: 0, right: 0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            cyberpunkGreen.withOpacity(0.2),
                            xianyuBlue.withOpacity(0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(
                          color: Colors.blue, // 设置边框颜色为蓝色
                          width: 1.0, // 设置边框宽度
                        ),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 180),
                        child: SelectableText(
                          displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (record == null) Text(''),
                if (record != null)
                  SelectableText(
                    (record.country.isNotEmpty && record.province.isNotEmpty)
                        ? '${record.country}·${record.province}'
                        : (record.country.isNotEmpty && record.province.isEmpty)
                        ? record.country
                        : (record.country.isEmpty && record.province.isNotEmpty)
                        ? record.province
                        : '',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            SelectableText(
              record == null || (record.note?.isEmpty ?? true)
                  ? '暂无备注'
                  : record.note,
              style: const TextStyle(fontSize: 12),
            ),
            if (record?.price != null &&
                record!.outLink.isNotEmpty) // 检查 outLink 是否非空
              SizedBox(height: 10),
            if (record?.price != null &&
                record!.outLink.isNotEmpty) // 检查 outLink 是否非空
              Text('外部链接：', style: const TextStyle(fontSize: 12)),
            if (record?.price != null &&
                record!.outLink.isNotEmpty) // 检查 outLink 是否非空
              SelectableText(
                '🗝️${record.outLink}',
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
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
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // 控制水平对齐方式，将组件放到最右边
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('🛒', style: TextStyle(fontSize: 14)),
                  Container(
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                    ).copyWith(left: 0, right: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cyberpunkGreen.withOpacity(0.2),
                          xianyuBlue.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue, // 设置边框颜色为蓝色
                        width: 1.0, // 设置边框宽度
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: SelectableText(
                        displayName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                //  mainAxisAlignment: MainAxisAlignment.start, // 控制竖直方向的对齐方式
                mainAxisSize: MainAxisSize.min, // 确保Column的高度仅为子组件的高度
                children: [
                  InkWell(
                    onTap: () {
                      _backupRecords();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      child: Column(
                        children: [
                          Center(child: Icon(Icons.backup, color: Colors.blue)),
                          Center(
                            child: Text(
                              '备份',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),
          // 月份导航
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
              ),
              Row(
                children: [
                  Text(
                    DateFormat('yyyy年MM月').format(_currentMonth),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.today, color: Colors.blue),
                    onPressed: _goToToday,
                    tooltip: '回到今天',
                  ),
                ],
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
          // 记录摘要
          _buildRecordSummary(),
          widget.bottomGap,
        ],
      ),
    );
  }
}
