import 'package:flutter/material.dart';

// 新增：价格文本组件
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

class PriceTagContent extends StatelessWidget {
  final List<Map<String, dynamic>> priceHistory;
  final Widget bottomGap;
  final String? productId;

  const PriceTagContent({
    super.key,
    required this.priceHistory,
    required this.bottomGap,
    required this.productId, //项目的id已从这里传入
  });
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

  // 工具函数：格式化时间
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
      itemCount: priceHistory.length,
      itemBuilder: (context, index) {
        final item = priceHistory[index];
        final dateTime = DateTime.tryParse(item['time'] ?? '');
        final locationDesc = _buildLocationDescription(item);
        // 获取 isSecondHand 的值，默认为 null
        bool? isSecondHand = item['isSecondHand'] as bool?;

        Widget? priceTypeText;
        if (isSecondHand == true) {
          priceTypeText = SizedBox(
            height: 40, // 设置固定高度
            width: 40, // 设置固定宽度（因为是圆形图片）
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), // 圆角
              ),
              child: Image.asset(
                'assets/images/second_hand.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        } else if (isSecondHand == false) {
          priceTypeText = SizedBox(
            height: 40, // 设置固定高度
            width: 40, // 设置固定宽度（因为是圆形图片）
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), // 圆角
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
            color: Colors.white, // 背景色
            borderRadius: BorderRadius.circular(8), // 圆角
            border: Border.all(color: Colors.grey), // 边框
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 整体靠左
            children: [
              // 第一层
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 左右分开
                children: [
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        //  中间的container内有Column（上下两个 Text）
                        Container(
                          padding: const EdgeInsets.all(8), // 内边距
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
                              bottomLeft: Radius.circular(10), // 左下圆角
                              bottomRight: Radius.circular(10), // 右下圆角
                            ),
                            boxShadow: [
                              // 添加阴影
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7), // 阴影颜色
                                offset: Offset(3, 0), // 向右偏移像素
                                blurRadius: 1, // 模糊半径
                                spreadRadius: 0, // 不扩展
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
                  // 根据 isSecondHand 的值显示不同的文本，如果 isSecondHand 不是 true 或 false，则不显示
                  if (priceTypeText != null) priceTypeText,
                ],
              ),

              SizedBox(height: 8), // 层间距
              // 第二层：左边一个 Text，右边一个 Text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 左右分开
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

              SizedBox(height: 8), // 层间距
              // 第三层：一个靠左的 Text
              SelectableText(
                item['comment'] ?? ' ', //comment为空值时候有一个'空格'
                style: TextStyle(fontSize: 14),
              ),
              if ((item['qqChannelLink'] as List<dynamic>? ?? []).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      '腾讯频道帖子:',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4), // 添加垂直间距
                    ...(item['qqChannelLink'] as List<dynamic>)
                        .map(
                          (link) => SelectableText(
                            '🗝️ ${link.toString()}', // 在这里添加🗝️emoji
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
        color: Colors.grey[100], // 设置背景色为浅灰色
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildDynamicList(),
            bottomGap,
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
      "time": "2023-01-01",
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
      "time": "2023-02-15",
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
      "time": "2023-03-30",
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
      "time": "2023-05-10",
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
