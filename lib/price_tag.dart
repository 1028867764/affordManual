import 'package:flutter/material.dart';

class PriceTagContent extends StatelessWidget {
  final List<Map<String, dynamic>> priceHistory;
  final Widget bottomGap;
  final String? productId;

  const PriceTagContent({
    super.key,
    required this.priceHistory,
    required this.bottomGap,
    required this.productId,
  });

  Widget _buildPriceHistoryTable(BuildContext context) {
    final latestData =
        (priceHistory.toList()..sort((a, b) => b['time'].compareTo(a['time'])))
            .take(2)
            .toList();

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Center(
              child: SelectableText(
                '历史价格',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowHeight: 30,
              headingRowHeight: 0,
              columnSpacing: 20,
              columns: const [
                DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox.shrink()),
              ],
              rows:
                  latestData.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(SelectableText(item['time'])),
                        DataCell(SelectableText(item['price'])),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Column(
        children: [
          Row(children: [Expanded(child: _buildPriceHistoryTable(context))]),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
                  child: Text(
                    '$productId${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              );
            },
          ),
          bottomGap,
        ],
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> quotedPrice() async {
  final mockData = [
    {"time": "2023-01-01", "price": "¥12.50", "detail": "点击查看详情"},
    {"time": "2023-02-15", "price": "¥13.20", "detail": "点击查看详情"},
    {"time": "2023-03-30", "price": "¥11.80", "detail": "点击查看详情"},
    {"time": "2023-05-10", "price": "¥14.00", "detail": "点击查看详情"},
  ];
  return mockData;
}
