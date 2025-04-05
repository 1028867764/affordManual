import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/organisms_data.dart';
import 'main.dart';
import 'data/industry_data.dart';
import 'search_page.dart';

class FavoriteApp extends StatefulWidget {
  const FavoriteApp({super.key});

  @override
  State<FavoriteApp> createState() => _FavoriteAppState();
}

class _FavoriteAppState extends State<FavoriteApp> {
  List<Product> _favoriteProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    // Find all favorite keys and get their products
    final favoriteKeys = allKeys.where(
      (key) => key.startsWith('favorite_') && prefs.getBool(key) == true,
    );

    // Convert keys to product IDs by removing 'favorite_' prefix
    final productIds =
        favoriteKeys.map((key) => key.replaceFirst('favorite_', '')).toList();

    // Find all products in organisms data that match these IDs
    final allProducts = <Product>[];
    // 1. 添加生物篇数据
    allProducts.addAll(
      organisms.expand(
        (category) => category.parentProductGroups.expand(
          (group) =>
              group.parentProducts.expand((parent) => parent.childProducts),
        ),
      ),
    );

    // 2. 添加工业篇数据
    factories.forEach((categoryName, products) {
      allProducts.addAll(
        products.map(
          (map) => Product(
            id: map['id'] as String,
            name: List<String>.from(map['name'] as List),
          ),
        ),
      );
    });

    setState(() {
      _favoriteProducts =
          allProducts
              .where((product) => productIds.contains(product.id))
              .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 每次页面构建时都检查是否需要刷新
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
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
        title: const Text('我的收藏'),
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
              ? const Center(child: CircularProgressIndicator())
              : _favoriteProducts.isEmpty
              ? const Center(
                child: Text(
                  '暂无收藏内容',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: _favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = _favoriteProducts[index];
                  // 获取从第3位开始的所有名称（如果存在）
                  final otherNames =
                      product.name.length > 2
                          ? product.name.sublist(2).join(', ')
                          : '暂无其它名称';
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(product.name[0]),
                      subtitle: Text(otherNames), // 显示其它名称
                      trailing: IconButton(
                        icon: const Icon(Icons.star, color: Colors.orange),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('favorite_${product.id}', false);
                          _loadFavorites(); // Refresh the list
                        },
                      ),
                      onTap: () {
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
                    ),
                  );
                },
              ),
    );
  }
}
