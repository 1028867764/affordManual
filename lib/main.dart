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
import 'data/industry_data.dart';
import 'favorite_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_detail_screen.dart';

const Color kBilibiliPink = Color(0xFFFB7299);

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black), // 添加黑色边框
              ),
              child: const TextField(
                style: TextStyle(fontSize: 15),
                enabled: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: -3,
                  ),
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
            _buildImageButton(
              context,
              'assets/images/favorite_bg.jpg',
              '收藏夹',
              () {
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
              },
            ),
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
  final bool isPinkTheme; // 新增参数

  const CategoryMenu({
    super.key,
    required this.categories,
    required this.currentIndex,
    required this.onCategorySelected,
    required this.isPinkTheme, // 接收主题状态
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
                          ? (isPinkTheme
                              ? kBilibiliPink
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
  final bool isPinkTheme; // 新增参数

  const ProductGrid({
    super.key,
    required this.category,
    required this.onProductSelected,
    required this.isPinkTheme, // 接收主题状态
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
              color: isPinkTheme ? Colors.pink[50] : Colors.blue[50], // 切换背景色
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
                                  isPinkTheme
                                      ? kBilibiliPink
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
                                          isPinkTheme
                                              ? kBilibiliPink
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

class BiologyApp extends StatefulWidget {
  const BiologyApp({super.key});

  @override
  State<BiologyApp> createState() => _BiologyAppState();
}

class _BiologyAppState extends State<BiologyApp> {
  int currentCategoryIndex = 0;
  bool _isLoading = false;
  bool _isPinkTheme = false; // 新增状态变量，控制是否使用橙色主题

  void selectCategory(int index) {
    setState(() {
      _isLoading = true;
      currentCategoryIndex = index;
      _isPinkTheme = !_isPinkTheme; // 切换主题颜色
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
            isPinkTheme: _isPinkTheme, // 传递主题状态
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
                        isPinkTheme: _isPinkTheme, // 传递主题状态
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
