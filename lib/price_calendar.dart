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
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _selectedDate = now;

    _priceController.text = '';
    _unitController.text = '';
    _noteController.text = '';
    _customizedNameController.text = '';
    _currency = 'rmb';

    _loadRecords().then((_) {
      if (_selectedDate != null && _records.containsKey(_selectedDate)) {
        final record = _records[_selectedDate];
        setState(() {
          _priceController.text = record?.price.toString() ?? '';
          _unitController.text = record?.unit ?? '';
          _noteController.text = record?.note ?? '';
          _customizedNameController.text =
              record?.customizedName ?? _defaultCustomName ?? '';
          _currency = record?.currency ?? 'rmb';
        });
      }
    });
    _loadDefaultCustomName();
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

    setState(() {
      _currentMonth = DateTime(now.year, now.month); // 确保切换到当前月份
      _selectedDate = today; // 选中今天的日期

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

  Widget _buildCurrencySwitch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _currency = 'rmb';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _currency == 'rmb' ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '人民币',
                style: TextStyle(
                  color: _currency == 'rmb' ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _currency = 'dollar';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _currency == 'dollar' ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '美元',
                style: TextStyle(
                  color: _currency == 'dollar' ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _selectedDate == null
                ? '添加记录'
                : '编辑 ${DateFormat('yyyy-MM-dd').format(_selectedDate!)} 记录',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCurrencySwitch(),
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
                  controller: _customizedNameController,
                  decoration: InputDecoration(
                    labelText: '自定义名称',
                    hintText:
                        displayName.isNotEmpty ? displayName : '输入自定义名称（可选）',
                    border: const OutlineInputBorder(),
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
                const SizedBox(height: 12),
                TextField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: '国家',
                    hintText: '输入国家',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _provinceController,
                  decoration: const InputDecoration(
                    labelText: '省份/州',
                    hintText: '输入省份或州',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: '城市',
                    hintText: '输入城市',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _outLinkController,
                  decoration: const InputDecoration(
                    labelText: '外部链接',
                    hintText: '输入外部链接',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                _saveRecord();
                Navigator.of(context).pop();
              },
              child: const Text('保存'),
            ),
          ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 控制容器之间的间距
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
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
                  ),
                  child: SelectableText(
                    displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
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
            SelectableText(
              record?.note ?? '暂无备注',
              style: const TextStyle(fontSize: 12),
            ),
            if (record?.price != null &&
                record!.outLink.isNotEmpty) // 检查 outLink 是否非空
              SelectableText('外部链接：', style: const TextStyle(fontSize: 12)),
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
              Container(
                padding: const EdgeInsets.all(10),
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SelectableText(
                      displayName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                //  mainAxisAlignment: MainAxisAlignment.start, // 控制竖直方向的对齐方式
                mainAxisSize: MainAxisSize.min, // 确保Column的高度仅为子组件的高度
                children: [
                  Container(
                    margin: EdgeInsets.zero, // 设置为0，表示没有外边距
                    child: IconButton(
                      icon: const Icon(Icons.backup, color: Colors.blue),
                      onPressed: _backupRecords,
                      tooltip: '备份数据',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.zero, // 设置为0，表示没有外边距
                    child: Text(
                      '备份',
                      style: TextStyle(fontSize: 10, color: Colors.blue),
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
