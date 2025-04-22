import 'package:flutter/material.dart';

// 排序类型枚举
enum SortType { newest, lowestPrice, highestPrice }

// 新增：排序选择器组件
class SortSelector extends StatefulWidget {
  final ValueChanged<SortType> onSortChanged;

  const SortSelector({super.key, required this.onSortChanged});

  @override
  State<SortSelector> createState() => _SortSelectorState();
}

class _SortSelectorState extends State<SortSelector> {
  SortType _currentSort = SortType.newest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: Text('排序规则', style: TextStyle(fontSize: 12)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.1),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // 设置边界线颜色为灰色
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IntrinsicWidth(
              // 关键点：让Container的宽度跟随内容
              child: Row(
                mainAxisSize: MainAxisSize.min, // 关键点：让Row不占用所有宽度
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildSortButton('最新', SortType.newest),
                  _buildSortButton('最低', SortType.lowestPrice),
                  _buildSortButton('最高', SortType.highestPrice),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String text, SortType sortType) {
    final isSelected = _currentSort == sortType;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSort = sortType;
        });
        widget.onSortChanged(sortType);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

// 价格文本组件
class PriceText extends StatelessWidget {
  final String price;
  final double bigSize;
  final double smallSize;
  final Color color;

  const PriceText({
    super.key,
    required this.price,
    required this.bigSize,
    required this.smallSize,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    final parts = price.split('.');
    final beforeDecimal = parts[0];
    final afterDecimal = parts.length > 1 ? '.${parts[1]}' : '';

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: beforeDecimal,
            style: TextStyle(
              fontSize: bigSize,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: afterDecimal,
            style: TextStyle(
              fontSize: smallSize,
              color: color,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class PriceTagContent extends StatefulWidget {
  final List<Map<String, dynamic>> priceHistory;
  final Widget bottomGap;
  final String? productId;

  const PriceTagContent({
    super.key,
    required this.priceHistory,
    required this.bottomGap,
    required this.productId,
  });

  @override
  State<PriceTagContent> createState() => _PriceTagContentState();
}

class _PriceTagContentState extends State<PriceTagContent> {
  late List<Map<String, dynamic>> _sortedPriceHistory;
  SortType _currentSort = SortType.newest;

  @override
  void initState() {
    super.initState();
    _sortedPriceHistory = _sortPriceHistory(widget.priceHistory, _currentSort);
  }

  @override
  void didUpdateWidget(PriceTagContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.priceHistory != widget.priceHistory) {
      _sortedPriceHistory = _sortPriceHistory(
        widget.priceHistory,
        _currentSort,
      );
    }
  }

  List<Map<String, dynamic>> _sortPriceHistory(
    List<Map<String, dynamic>> history,
    SortType sortType,
  ) {
    final List<Map<String, dynamic>> sortedList = List.from(history);

    sortedList.sort((a, b) {
      final aTime = DateTime.tryParse(a['time'] ?? '') ?? DateTime(0);
      final bTime = DateTime.tryParse(b['time'] ?? '') ?? DateTime(0);
      final aPrice = double.tryParse(a['price']?.toString() ?? '0') ?? 0;
      final bPrice = double.tryParse(b['price']?.toString() ?? '0') ?? 0;

      switch (sortType) {
        case SortType.newest:
          return bTime.compareTo(aTime); // 最新日期在前
        case SortType.lowestPrice:
          return aPrice.compareTo(bPrice); // 价格最低在前
        case SortType.highestPrice:
          return bPrice.compareTo(aPrice); // 价格最高在前
      }
    });

    return sortedList;
  }

  void _handleSortChanged(SortType sortType) {
    setState(() {
      _currentSort = sortType;
      _sortedPriceHistory = _sortPriceHistory(_sortedPriceHistory, sortType);
    });
  }

  String _buildLocationDescription(Map<String, dynamic> item) {
    final place = item['place'] as Map<String, dynamic>? ?? {};
    final country = place['country']?.toString();
    final province = place['province']?.toString();

    if (country != null &&
        country.isNotEmpty &&
        province != null &&
        province.isNotEmpty) {
      return '$country·$province';
    } else if (country != null && country.isNotEmpty) {
      return country;
    } else {
      return '';
    }
  }

  String formatDate(String? dateString) {
    final dateTime = DateTime.tryParse(dateString ?? '');
    if (dateTime != null) {
      return '${dateTime.year}年\n${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
    }
    return '未知时间';
  }

  Widget _buildDynamicList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sortedPriceHistory.length,
      itemBuilder: (context, index) {
        final item = _sortedPriceHistory[index];
        final dateTime = DateTime.tryParse(item['time'] ?? '');
        final locationDesc = _buildLocationDescription(item);
        bool? isSecondHand = item['isSecondHand'] as bool?;

        Widget? priceTypeText;
        if (isSecondHand == true) {
          priceTypeText = SizedBox(
            height: 40,
            width: 40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                'assets/images/second_hand.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        } else if (isSecondHand == false) {
          priceTypeText = SizedBox(
            height: 40,
            width: 40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                'assets/images/first_hand.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Row(
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
                              if (dateTime != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${dateTime.year}年',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  '未知时间',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  item['currency'] == 'rmb'
                                      ? '¥'
                                      : item['currency'] == 'dollar'
                                      ? '\$'
                                      : '未知币种',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                                PriceText(
                                  price: item['price'] ?? '未知价格',
                                  bigSize: 28,
                                  smallSize: 12,
                                ),
                                Text(
                                  '/',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  item['unit'] ?? '未知单位',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('🌏️', style: TextStyle(fontSize: 12)),
                                Text(
                                  (item['place']?['city']
                                              ?.toString()
                                              .isNotEmpty ??
                                          false)
                                      ? item['place']!['city'].toString()
                                      : '未知城市',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (priceTypeText != null) priceTypeText,
                ],
              ),

              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('🐧', style: TextStyle(fontSize: 12)),
                      Text(
                        (item['userId']?.toString().isNotEmpty ?? false)
                            ? item['userId'].toString()
                            : '未知用户',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  if (locationDesc.isNotEmpty)
                    Text(locationDesc, style: TextStyle(fontSize: 12)),
                ],
              ),

              SizedBox(height: 12),
              SelectableText(
                item['comment'] ?? ' ',
                style: TextStyle(fontSize: 14),
              ),
              if ((item['qqChannelLink'] as List<dynamic>? ?? []).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Text(
                      '腾讯频道帖子:',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    ...(item['qqChannelLink'] as List<dynamic>)
                        .map(
                          (link) => SelectableText(
                            '🗝️ ${link.toString()}',
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                        )
                        .toList(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        color: Colors.grey[100],
        child: Column(
          children: [
            const SizedBox(height: 10),
            SortSelector(onSortChanged: _handleSortChanged),
            _buildDynamicList(),
            widget.bottomGap,
          ],
        ),
      ),
    );
  }
}

// 模拟数据函数
Future<List<Map<String, dynamic>>> quotedPrice() async {
  final mockData = [
    {
      "userId": "qq111",
      "time": "2023-10-01",
      "price": "12.50",
      "currency": "dollar",
      "unit": "斤",
      "isSecondHand": false,
      "place": {"country": "中国", "province": "广东", "city": "深圳市福田区"},
      "comment": "本店隐藏款已上线！加班时靠它续命，朋友聚会靠它救场",
      "qqChannelLink": ["https1", "https2"],
      "douyinLink": ["https1", "https2"],
      "detail": "点击查看详情",
    },
    {
      "userId": "douyin222",
      "time": "2023-09-15",
      "price": "13.20",
      "currency": "rmb",
      "unit": "吨",
      "isSecondHand": true,
      "place": {"country": "美国", "province": "加州", "city": "洛杉矶"},
      "comment":
          "当我第一次用它打王者，队友问：你是蓝方还是红方？我说：我是电量方！⚡因为它掉电真的很快，但我又不得不下载五杀战绩海报发朋友圈✨。建议它的壁纸直接做成‘充电中’——这才是永恒的真谛🔋。",
      "qqChannelLink": ["https1", "https2"],
      "douyinLink": ["https1", "https2"],
      "detail": "点击查看详情",
    },
    {
      "userId": "douyin333",
      "time": "2023-08-30",
      "price": "11.80",
      "currency": "rmb",
      "unit": "斤",
      "isSecondHand": false,
      "place": {"country": "日本", "province": "", "city": "東京都千代田区"},
      "comment": "本想躺赢，结果躺进ICU——别问我怎么知道的（别点链接🤮）",
      "qqChannelLink": ["https1", "https2"],
      "douyinLink": ["https1", "https2"],
      "detail": "点击查看详情",
    },
    {
      "userId": "",
      "time": "2023-07-10",
      "price": "9.80",
      "currency": "rmb",
      "unit": "斤",
      "isSecondHand": true,
      "place": {"country": "英国", "province": "", "city": "伦敦"},
      "comment": "外酥里嫩？不，是外焦里硬💀",
      "qqChannelLink": [],
      "douyinLink": ["https1", "https2"],
      "detail": "点击查看详情",
    },
    {
      "userId": "wechat555",
      "time": "2023-06-05",
      "price": "15.25",
      "currency": "rmb",
      "unit": "斤",
      "isSecondHand": null,
      "place": {"country": "国家", "province": "省/州", "city": ""},
      "comment": "警告！去过这里的人，回来都偷偷存私房钱了",
      "qqChannelLink": ["https1", "https2"],
      "douyinLink": ["https1", "https2"],
      "detail": "点击查看详情",
    },
  ];

  return mockData;
}
