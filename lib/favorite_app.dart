import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/organisms_data.dart';
import 'main.dart';
import 'data/industry_data.dart';
import 'search_page.dart';
import 'dart:math';

class FavoriteApp extends StatefulWidget {
  const FavoriteApp({super.key});

  @override
  State<FavoriteApp> createState() => _FavoriteAppState();
}

class _FavoriteAppState extends State<FavoriteApp> {
  List<Product> _favoriteProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  bool _isSearchLocked = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    if (_isSearchLocked) return;
    final searchText = _searchController.text.toLowerCase();
    if (_isLoading || _favoriteProducts.isEmpty) return;

    setState(() {
      if (searchText.isEmpty) {
        _filteredProducts = List.from(_favoriteProducts);
      } else {
        _filteredProducts =
            _favoriteProducts.where((product) {
              final description = product.description?.toLowerCase() ?? '';
              return description.contains(searchText);
            }).toList();
      }
    });
  }

  // 高亮文本的方法
  InlineSpan _buildHighlightedText(String text, String highlight) {
    if (highlight.isEmpty || text.isEmpty) {
      return TextSpan(text: text, style: TextStyle(color: Colors.grey[600]));
    }

    final List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;

    while ((indexOfHighlight = text.toLowerCase().indexOf(highlight, start)) !=
        -1) {
      // 添加高亮前的文本
      if (indexOfHighlight > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, indexOfHighlight),
            style: TextStyle(color: Colors.grey[600]),
          ),
        );
      }

      // 添加高亮文本
      spans.add(
        TextSpan(
          text: text.substring(
            indexOfHighlight,
            indexOfHighlight + highlight.length,
          ),
          style: TextStyle(
            color: kBilibiliPink,
            fontWeight: FontWeight.bold,
            // backgroundColor: Colors.yellow.withOpacity(0.3),
          ),
        ),
      );

      start = indexOfHighlight + highlight.length;
    }

    // 添加剩余文本
    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return TextSpan(children: spans);
  }

  Widget _buildHighlightedDescription({
    required String description,
    required String searchText,
  }) {
    final defaultStyle = TextStyle(fontSize: 11, color: Colors.grey[600]);

    if (description.isEmpty) {
      return Text('暂无描述', style: defaultStyle);
    }

    if (searchText.isEmpty || !description.toLowerCase().contains(searchText)) {
      return Text(
        description,
        style: defaultStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final matchIndex = description.toLowerCase().indexOf(searchText);
    final visibleStart = max(0, matchIndex - 1); // 确保匹配文本前有 个字符的上下文
    final visibleText = description.substring(
      visibleStart,
      min(description.length, visibleStart + 50), // 最多显示50个字符
    );

    return Tooltip(
      message: description, // 鼠标悬停时显示完整描述
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: _buildHighlightedText(visibleText, searchText),
      ),
    );
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    final favoriteKeys = allKeys.where(
      (key) => key.startsWith('favorite_') && prefs.getBool(key) == true,
    );

    final productIds =
        favoriteKeys.map((key) => key.replaceFirst('favorite_', '')).toList();

    final allProducts = <Product>[];
    allProducts.addAll(
      organisms.expand(
        (category) => category.parentProductGroups.expand(
          (group) =>
              group.parentProducts.expand((parent) => parent.childProducts),
        ),
      ),
    );

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

    if (mounted) {
      setState(() {
        _favoriteProducts =
            allProducts.where((product) => productIds.contains(product.id)).map(
              (product) {
                final customName =
                    prefs.getString('custom_name_${product.id}') ?? '';
                final description =
                    prefs.getString('description_${product.id}') ?? '';
                return Product(
                  id: product.id,
                  name: product.name,
                  customName: customName,
                  description: description,
                );
              },
            ).toList();
        _filteredProducts = List.from(_favoriteProducts);
        _isLoading = false;
      });
    }
  }

  Future<void> _showEditDialog(BuildContext context, Product product) async {
    final originalName =
        product.customName.isNotEmpty ? product.customName : product.name[0];
    final originalDescription = product.description ?? '';
    final nameController = TextEditingController(text: originalName);
    final descriptionController = TextEditingController(
      text: originalDescription,
    );

    await showDialog(
      context: context,
      builder:
          (context) => Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: const TextStyle(color: Colors.black87),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
            ),
            child: AlertDialog(
              title: const Text('编辑项目', style: TextStyle(color: Colors.black)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: '自定义名称',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: '简短描述',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('取消', style: TextStyle(color: Colors.grey[600])),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text('保存', style: TextStyle(color: Colors.grey[600])),
                  onPressed: () async {
                    final newName = nameController.text.trim();
                    final newDescription = descriptionController.text.trim();
                    final prefs = await SharedPreferences.getInstance();

                    if (newName.isNotEmpty && newName != product.name[0]) {
                      await prefs.setString(
                        'custom_name_${product.id}',
                        newName,
                      );
                    } else {
                      await prefs.remove('custom_name_${product.id}');
                    }

                    if (newDescription.isNotEmpty) {
                      await prefs.setString(
                        'description_${product.id}',
                        newDescription,
                      );
                    } else {
                      await prefs.remove('description_${product.id}');
                    }

                    if (mounted) {
                      await _loadFavorites();
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black38, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _searchController.text.isEmpty) {
        _loadFavorites();
      }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 2.0, // 减小上下边距（原来是16）
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    enabled: !_isSearchLocked,
                    style: TextStyle(fontSize: 14), // 添加这一行，设置字号
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      hintText: '搜索描述...',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 4, // 更小的值
                        horizontal: 8,
                      ),
                      constraints: BoxConstraints(
                        maxHeight: 36, // 直接限制最大高度
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      if (!_isSearchLocked) {
                        _filterProducts();
                      }
                    },
                  ),
                ),
                SizedBox(width: 2),
                IconButton(
                  icon: Icon(
                    _isSearchLocked ? Icons.lock : Icons.lock_open,
                    color: _isSearchLocked ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearchLocked = !_isSearchLocked;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredProducts.isEmpty
                    ? Center(
                      child: Text(
                        _searchController.text.isEmpty ? '暂无收藏内容' : '没有找到匹配的描述',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        final otherNames =
                            product.name.length > 2
                                ? product.name.sublist(2).join(', ')
                                : '暂无其它名称';
                        final searchText = _searchController.text.toLowerCase();
                        final description = product.description ?? '';

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 5,
                          ),
                          child: ListTile(
                            title: Text(
                              product.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.customName.isNotEmpty
                                      ? product.name[0]
                                      : otherNames,
                                  style: TextStyle(fontSize: 11),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                          120,
                                    ),
                                    child: _buildHighlightedDescription(
                                      description: description,
                                      searchText: searchText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed:
                                      () => _showEditDialog(context, product),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.star_rounded,
                                    color: kBilibiliPink,
                                  ),
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool(
                                      'favorite_${product.id}',
                                      false,
                                    );
                                    await prefs.remove(
                                      'custom_name_${product.id}',
                                    );
                                    await prefs.remove(
                                      'description_${product.id}',
                                    );
                                    if (mounted) {
                                      _loadFavorites();
                                    }
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) =>
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
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
