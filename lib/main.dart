import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'industry_app.dart';
import 'luxury_app.dart';
import 'search_page.dart';
import 'data/organisms_data.dart';
import 'price_tag.dart';
import 'favorite_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 16, // 全局设置标题字号
            color: Colors.black, // 全局设置标题字体颜色
          ),
        ),
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ), // 设置默认字体
      home: const MainHomePage(),
    );
  }
}

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: GestureDetector(
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
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                style: TextStyle(fontSize: 14),
                enabled: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: '搜索...',
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2, // 两列
          mainAxisSpacing: 20, // 垂直间距
          crossAxisSpacing: 20, // 水平间距
          padding: const EdgeInsets.all(20), // 整体边距
          children: [
            _buildImageButton(
              context,
              'assets/images/biology_bg.webp',
              '生物篇',
              () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const BiologyApp(),
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
            ),
            _buildImageButton(
              context,
              'assets/images/industry_bg.jpg',
              '工业篇',
              () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const IndustryApp(),
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
            ),
            _buildImageButton(
              context,
              'assets/images/luxury_bg.webp',
              '土豪篇',
              () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const LuxuryApp(),
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
            ),
            _buildImageButton(context, 'assets/images/unknown_bg.jpg', '', () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const FavoriteApp(),
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
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton(
    BuildContext context,
    String imagePath,
    String text,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 100,
      height: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const CircleBorder(),
        ),
        child: ClipOval(
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: 600,
                height: 600,
                fit: BoxFit.cover,
              ),
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 6,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryMenu extends StatelessWidget {
  final List<Category> categories;
  final int currentIndex;
  final Function(int) onCategorySelected;
  final bool isOrangeTheme; // 新增参数

  const CategoryMenu({
    super.key,
    required this.categories,
    required this.currentIndex,
    required this.onCategorySelected,
    required this.isOrangeTheme, // 接收主题状态
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: Colors.grey[200],
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              color: index == currentIndex ? Colors.white : Colors.grey[200],
              margin: const EdgeInsets.only(bottom: 2),
              alignment: Alignment.center,
              child: Text(
                categories[index].id,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      index == currentIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                  color:
                      index == currentIndex
                          ? (isOrangeTheme
                              ? Colors.orange
                              : Colors.blue) // 根据主题切换颜色
                          : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final Category category;
  final Function(Product) onProductSelected;
  final bool isOrangeTheme; // 新增参数

  const ProductGrid({
    super.key,
    required this.category,
    required this.onProductSelected,
    required this.isOrangeTheme, // 接收主题状态
  });

  @override
  Widget build(BuildContext context) {
    bool isSingleGroup = category.parentProductGroups.length == 1;
    int groupCount = category.parentProductGroups.length;

    return ListView.builder(
      itemCount: groupCount * 2 - 1,
      itemBuilder: (context, index) {
        if (index.isOdd) {
          return const SizedBox(height: 0);
        }

        final groupIndex = index ~/ 2;
        final group = category.parentProductGroups[groupIndex];
        final isFirstGroup = groupIndex == 0;
        final isLastGroup = groupIndex == groupCount - 1;

        // 当有多个组时，包装整个组
        if (!isSingleGroup) {
          return _buildGroupContent(
            group,
            isSingleGroup,
            groupIndex,
            isLastGroup,
          );
        } else {
          // 单个组时直接返回内容
          return _buildGroupContent(
            group,
            isSingleGroup,
            groupIndex,
            isLastGroup,
          );
        }
      },
    );
  }

  Widget _buildGroupContent(
    ParentProductGroup group,
    bool isSingleGroup,
    int groupIndex,
    bool isLastGroup,
  ) {
    int parentProductCount = group.parentProducts.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 当有多个组时，在第一个组上方添加 SizedBox
        if (!isSingleGroup && groupIndex == 0) SizedBox(height: 10),
        if (!isSingleGroup && group.id.isNotEmpty) Container(),
        ...group.parentProducts.map((parentProduct) {
          final isLastParentProduct =
              group.parentProducts.indexOf(parentProduct) ==
              parentProductCount - 1;

          return Container(
            margin: EdgeInsets.only(
              top: isSingleGroup ? (groupIndex == 0 ? 10 : 0) : 0,
              left: isSingleGroup ? 10 : 10,
              right: isSingleGroup ? 10 : 10,
              bottom: isSingleGroup ? (isLastParentProduct ? 10 : 0) : 10,
            ),
            decoration: BoxDecoration(
              color:
                  isOrangeTheme ? Colors.orange[50] : Colors.blue[50], // 切换背景色
              borderRadius:
                  isSingleGroup
                      ? BorderRadius.circular(12)
                      : BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 添加标签显示 ParentProductGroup 名称
                      if (!isSingleGroup)
                        Align(
                          alignment: Alignment.topLeft, // 强制左对齐父容器
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isOrangeTheme
                                      ? Colors.orange[300]
                                      : Colors.blue[300], // 切换标签背景色
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              group.id, // 显示 ParentProductGroup 名称
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (isSingleGroup)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: IntrinsicWidth(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isOrangeTheme
                                              ? Colors.orange[300]
                                              : Colors.blue[300], // 切换标签背景色
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      parentProduct.id,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      if (isSingleGroup)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            parentProduct.name[0],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!isSingleGroup)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            parentProduct.id,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      if (!isSingleGroup)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            parentProduct.name[0],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 10,
                  ),
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 10,
                    left: 10,
                    right: 10,
                  ),
                  itemCount: parentProduct.childProducts.length,
                  itemBuilder: (context, index) {
                    final product = parentProduct.childProducts[index];
                    return GestureDetector(
                      onTap: () => onProductSelected(product),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name[0],
                                style: const TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final dynamic product; // 改为 dynamic 或定义联合类型

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = true;
  String? _enlargedImageUrl;
  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  List<Map<String, dynamic>> _priceHistory = []; // 存储历史价格数据

  void _enlargeImage(String imageUrl) {
    _scrollPosition = _scrollController.position.pixels;
    setState(() {
      _enlargedImageUrl = imageUrl;
    });
  }

  void _closeEnlargedImage() {
    setState(() {
      _enlargedImageUrl = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollPosition);
    });
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已复制到剪贴板: $text')));
  }

  @override
  void initState() {
    super.initState();
    _loadPriceHistory(); // 加载历史价格数据
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  // 模拟从JSON文件加载历史价格数据
  Future<void> _loadPriceHistory() async {
    // 这里应该是从JSON文件加载数据，这里用模拟数据代替
    final mockData = [
      {"time": "2023-01-01", "price": "¥12.50", "detail": "点击查看详情"},
      {"time": "2023-02-15", "price": "¥13.20", "detail": "点击查看详情"},
      {"time": "2023-03-30", "price": "¥11.80", "detail": "点击查看详情"},
      {"time": "2023-05-10", "price": "¥14.00", "detail": "点击查看详情"},
    ];

    setState(() {
      _priceHistory = mockData;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 构建历史价格表格
  Widget _buildPriceHistoryTable() {
    // 获取最新的两条数据
    final latestData =
        (_priceHistory.toList()..sort((a, b) => b['time'].compareTo(a['time'])))
            .take(2)
            .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                '历史价格',
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
              dataRowHeight: 30, // 设置数据行高度
              headingRowHeight: 0, // 设置标题行高度
              columnSpacing: 20,
              columns: const [
                DataColumn(label: SizedBox.shrink()), // 使用空组件替代 Text('')
                DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox.shrink()),
              ],
              rows:
                  latestData.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item['time'])),
                        DataCell(Text(item['price'])),
                        DataCell(
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => PriceTag(
                                        time: item['time'],
                                        price: item['price'],
                                        productName: widget.product.name[0],
                                        id: widget.product.id, // Add this line
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
                            child: const Text(
                              '详情',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
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
    // 获取从第三个元素开始的所有名称，如果不足3个则返回空字符串
    final otherNames =
        widget.product.name.length > 2
            ? '- ​**其它名称**: ${widget.product.name.sublist(2).join(', ')}\n'
            : '';

    final markdownContent = """
# 产品详情

## 基本信息
- ​**产品ID**: ${widget.product.id}
- ​**产品名称**: ${widget.product.name[0]}
- ​**英文名称**: ${widget.product.name.length > 1 ? widget.product.name[1] : '暂无'}
$otherNames

## &emsp;产品描述
&emsp;&emsp;这是一段示例描述。《零的焦点》则以一对夫妻的生活为切入点，展现了一幅日本战后社会的众生相。女主人公绫子看似拥有幸福美满的家庭，然而，丈夫的神秘失踪打破了这份平静。随着调查的深入，一系列惊人的真相逐渐浮出水面。原来，丈夫的过去涉及到一些不为人知的秘密，而这些秘密与当时日本社会的种种问题紧密相连。在这个过程中，作者揭示了战争给人们带来的创伤以及战后社会的混乱与迷茫。人们在追求物质生活的同时，往往忽略了内心的真实需求，导致道德观念的扭曲和人际关系的冷漠。通过对这起案件的描写，读者不仅能够感受到推理小说的紧张刺激，还能对社会现实进行深刻的反思。  
## 产品图片
![示例图片](http://img.tukuppt.com/photo-small/19/94/23/706589110a5f2073682.jpg)
## &emsp;产品描述
&emsp;&emsp;《夜蝉》的故事发生在一个宁静而又略显封闭的小镇。小镇的生活节奏缓慢，人们过着平淡而又规律的日子，仿佛时间在这里停滞了一般。然而，一起突如其来的谋杀案打破了这份宁静，如同平静的湖面投入了一颗巨石。  
&emsp;&emsp;案件发生在一个看似普通的夜晚，一位与小镇生活息息相关的人物被发现离奇死亡。随着调查的展开，各种线索逐渐浮出水面，但这些线索却如同夜空中的繁星，看似繁多却又各自独立，让人难以捉摸其中的关联。北村薰以其独特的叙事手法，将读者带入了一个充满悬念和神秘色彩的世界，让人们对这起案件充满了好奇和探索的欲望。
## &emsp;产品描述
&emsp;&emsp;这是一段示例描述。《零的焦点》则以一对夫妻的生活为切入点，展现了一幅日本战后社会的众生相。女主人公绫子看似拥有幸福美满的家庭，然而，丈夫的神秘失踪打破了这份平静。随着调查的深入，一系列惊人的真相逐渐浮出水面。原来，丈夫的过去涉及到一些不为人知的秘密，而这些秘密与当时日本社会的种种问题紧密相连。在这个过程中，作者揭示了战争给人们带来的创伤以及战后社会的混乱与迷茫。人们在追求物质生活的同时，往往忽略了内心的真实需求，导致道德观念的扭曲和人际关系的冷漠。通过对这起案件的描写，读者不仅能够感受到推理小说的紧张刺激，还能对社会现实进行深刻的反思。  
## 产品图片
![示例图片](http://gd-hbimg.huaban.com/2288348e418d1372bab85e5266cae51b2d66503c6155b-KgiKde)
## &emsp;产品描述
&emsp;&emsp;《夜蝉》的故事发生在一个宁静而又略显封闭的小镇。小镇的生活节奏缓慢，人们过着平淡而又规律的日子，仿佛时间在这里停滞了一般。然而，一起突如其来的谋杀案打破了这份宁静，如同平静的湖面投入了一颗巨石。  
&emsp;&emsp;案件发生在一个看似普通的夜晚，一位与小镇生活息息相关的人物被发现离奇死亡。随着调查的展开，各种线索逐渐浮出水面，但这些线索却如同夜空中的繁星，看似繁多却又各自独立，让人难以捉摸其中的关联。北村薰以其独特的叙事手法，将读者带入了一个充满悬念和神秘色彩的世界，让人们对这起案件充满了好奇和探索的欲望。 
    """;

    return Scaffold(
      appBar: AppBar(
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
        title: Text(widget.product.name[0]),
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

class BiologyApp extends StatefulWidget {
  const BiologyApp({super.key});

  @override
  State<BiologyApp> createState() => _BiologyAppState();
}

class _BiologyAppState extends State<BiologyApp> {
  int currentCategoryIndex = 0;
  bool _isLoading = false;
  bool _isOrangeTheme = false; // 新增状态变量，控制是否使用橙色主题

  void selectCategory(int index) {
    setState(() {
      _isLoading = true;
      currentCategoryIndex = index;
      _isOrangeTheme = !_isOrangeTheme; // 切换主题颜色
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '生物篇',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
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
          CategoryMenu(
            categories: organisms,
            currentIndex: currentCategoryIndex,
            onCategorySelected: selectCategory,
            isOrangeTheme: _isOrangeTheme, // 传递主题状态
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ProductGrid(
                        category: organisms[currentCategoryIndex],
                        onProductSelected: (product) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ProductDetailScreen(product: product),
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
                        isOrangeTheme: _isOrangeTheme, // 传递主题状态
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
