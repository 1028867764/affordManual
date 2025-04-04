import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'main.dart';
import 'search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'data/industry_data.dart';

class IndustryProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const IndustryProductDetailScreen({super.key, required this.product});

  @override
  State<IndustryProductDetailScreen> createState() =>
      _IndustryProductDetailScreenState();
}

class _IndustryProductDetailScreenState
    extends State<IndustryProductDetailScreen> {
  bool _isLoading = true;
  String? _enlargedImageUrl;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  List<Map<String, dynamic>> _priceHistory = [];

  @override
  void initState() {
    super.initState();
    _loadPriceHistory();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  void _loadPriceHistory() {
    final mockData = [
      {"time": "2023-01-01", "price": "¥12.50", "detail": "点击查看详情"},
      {"time": "2023-02-15", "price": "¥13.20", "detail": "点击查看详情"},
    ];
    setState(() => _priceHistory = mockData);
  }

  void _enlargeImage(String imageUrl) {
    _scrollPosition = _scrollController.position.pixels;
    setState(() => _enlargedImageUrl = imageUrl);
  }

  void _closeEnlargedImage() {
    setState(() => _enlargedImageUrl = null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollPosition);
    });
  }

  Widget _buildPriceHistoryTable() {
    final latestData = _priceHistory.take(2).toList();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Center(
              child: Text(
                '工业品价格历史',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
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
                DataColumn(label: SizedBox.shrink()),
              ],
              rows:
                  latestData
                      .map(
                        (item) => DataRow(
                          cells: [
                            DataCell(Text(item['time'])),
                            DataCell(Text(item['price'])),
                            DataCell(
                              InkWell(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => IndustryPriceTag(
                                              time: item['time'],
                                              price: item['price'],
                                              productName:
                                                  widget.product['name'][0],
                                              productId:
                                                  widget
                                                      .product['id'], // 传递产品ID
                                            ),
                                        transitionsBuilder: (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;
                                          var tween = Tween(
                                            begin: begin,
                                            end: end,
                                          ).chain(CurveTween(curve: curve));
                                          var offsetAnimation = animation.drive(
                                            tween,
                                          );
                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    ),
                                child: const Text(
                                  '详情',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final markdownContent = """
# ${widget.product['name'][0]}

## 基本信息
- **产品ID**: ${widget.product['id']}
- **产品名称**: ${widget.product['name'].join(" / ")}

## 产品描述
&emsp;&emsp;这里是工业产品的详细描述。工业产品在现代社会中扮演着至关重要的角色，它们是制造业的基础，支撑着整个经济体系的运转。从原材料到成品，每一个环节都凝聚着人类的智慧和技术的进步。

&emsp;&emsp;工业产品的生产过程通常涉及复杂的工艺流程和严格的质量控制标准。这些产品广泛应用于建筑、交通、电子、化工等各个领域，为社会发展提供了坚实的物质基础。

## 产品图片
![工业产品图片](http://img.tukuppt.com/photo-small/19/94/23/706589110a5f2073682.jpg)

## 技术参数
&emsp;&emsp;以下是该工业产品的主要技术参数：
- 密度: 1.2 g/cm³
- 熔点: 180-200°C
- 抗拉强度: 50 MPa
- 耐腐蚀性: 优良
- 使用寿命: 10年以上

## 应用领域
&emsp;&emsp;该产品广泛应用于以下领域：
1. 建筑行业
2. 汽车制造
3. 电子电器
4. 包装材料
5. 医疗器械

## 产品图片
![工业应用](http://gd-hbimg.huaban.com/2288348e418d1372bab85e5266cae51b2d66503c6155b-KgiKde)
""";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name'][0]),
        leadingWidth: 100,
        leading: Row(
          children: [
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const SearchPage(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainHomePage()),
                  (route) => false,
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.home),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body:
          _enlargedImageUrl != null
              ? GestureDetector(
                onTap: _closeEnlargedImage,
                child: Container(
                  color: Colors.black.withOpacity(0.9),
                  child: Center(
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.network(_enlargedImageUrl!),
                    ),
                  ),
                ),
              )
              : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // 价格历史表格（无外边距）
                    Padding(
                      padding: EdgeInsets.zero,
                      child: _buildPriceHistoryTable(),
                    ),
                    Markdown(
                      data: markdownContent,
                      shrinkWrap: true,
                      selectable: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                      imageBuilder: (uri, title, alt) {
                        return GestureDetector(
                          onTap: () => _enlargeImage(uri.toString()),
                          child: CachedNetworkImage(
                            imageUrl: uri.toString(),
                            placeholder:
                                (context, url) => Container(
                                  color: Colors.grey[300],
                                  width: 100,
                                  height: 100,
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  width: 100,
                                  height: 100,
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}

class IndustryPriceTag extends StatefulWidget {
  final String time;
  final String price;
  final String productName;
  final String productId; // 新增 productId 参数

  const IndustryPriceTag({
    super.key,
    required this.time,
    required this.price,
    required this.productName,
    required this.productId, // 新增
  });

  @override
  State<IndustryPriceTag> createState() => _IndustryPriceTagState();
}

class _IndustryPriceTagState extends State<IndustryPriceTag> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 模拟数据加载延迟
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        leadingWidth: 100,
        leading: Row(
          children: [
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const SearchPage(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainHomePage()),
                  (route) => false,
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.home),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '产品ID: ${widget.productId}', // 新增显示产品ID
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '产品名称: ${widget.productName}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8), // 添加一些间距
                    Text(
                      '时间: ${widget.time}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '价格: ${widget.price}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class IndustryApp extends StatefulWidget {
  const IndustryApp({super.key});

  @override
  State<IndustryApp> createState() => _IndustryAppState();
}

class _IndustryAppState extends State<IndustryApp> {
  String? selectedCategory;
  bool _isLoadingProducts = false;
  final ScrollController _scrollController = ScrollController();
  int count = 0; // 新增计数器变量

  @override
  void initState() {
    super.initState();
    selectedCategory = factories.keys.first;
  }

  void _changeCategory(String category) {
    setState(() {
      selectedCategory = category;
      _isLoadingProducts = true;
      count++; // 每次点击左边菜单栏时增加计数器
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工业篇', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        centerTitle: true,
        leadingWidth: 100,
        leading: Row(
          children: [
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const SearchPage(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainHomePage()),
                  (route) => false,
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.home),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          // 左侧导航栏
          Container(
            width: 100,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: factories.keys.length,
              itemBuilder: (context, index) {
                final category = factories.keys.elementAt(index);
                return GestureDetector(
                  onTap: () => _changeCategory(category),
                  child: Container(
                    height: 40,
                    color:
                        selectedCategory == category
                            ? Colors.white
                            : Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            selectedCategory == category
                                ? Colors.blue
                                : Colors.black,
                        fontWeight:
                            selectedCategory == category
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
          // 右侧商品列表
          Expanded(
            child: Container(
              color: Colors.white,
              child:
                  _isLoadingProducts
                      ? const Center(child: CircularProgressIndicator())
                      : CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final item =
                                      factories[selectedCategory]![index];
                                  final itemName = item['name'][0];

                                  final categoryItemCount =
                                      factories[selectedCategory]!.length;

                                  // 计算颜色索引：(index + 当前分类商品总数 + 100) % 7
                                  final colorIndex =
                                      (index +
                                          categoryItemCount +
                                          100 +
                                          count) %
                                      _pastelColors.length;
                                  final containerColor =
                                      _pastelColors[colorIndex];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                              ) => IndustryProductDetailScreen(
                                                product: item,
                                              ),
                                          transitionsBuilder: (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.ease;
                                            var tween = Tween(
                                              begin: begin,
                                              end: end,
                                            ).chain(CurveTween(curve: curve));
                                            var offsetAnimation = animation
                                                .drive(tween);
                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: containerColor, // 应用计算出的颜色
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Stack(
                                          children: [
                                            Align(
                                              alignment:
                                                  Alignment.center, // 水平和垂直居中
                                              child: Text(
                                                itemName,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                      ),
                                    ),
                                  );
                                },
                                childCount: factories[selectedCategory]!.length,
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

const List<Color> _pastelColors = [
  Color(0xFFFFD1DC), // 淡粉红
  Color(0xFFFFB6C1), // 淡红
  Color(0xFFFFD3B6), // 淡橙
  Color(0xFFFFFFB6), // 淡黄
  Color(0xFFD1FFB6), // 淡绿
  Color(0xFFB6E6FF), // 淡蓝
  Color(0xFFD1B6FF), // 淡紫
];
