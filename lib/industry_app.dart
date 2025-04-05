import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'main.dart';
import 'search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'data/industry_data.dart';
import 'data/organisms_data.dart';

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
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final item =
                                    factories[selectedCategory]![index];
                                final itemName = item['name'][0];

                                final categoryItemCount =
                                    factories[selectedCategory]!.length;

                                // 计算颜色索引：(index + 当前分类商品总数 + 100) % 7
                                final colorIndex =
                                    (index + categoryItemCount + 100 + count) %
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
                                            ) => ProductDetailScreen(
                                              product: Product(
                                                id: item['id'], // 将 Map 数据转为 Product 对象
                                                name: item['name'],

                                                // 其他必要字段...
                                              ),
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
                              }, childCount: factories[selectedCategory]!.length),
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
