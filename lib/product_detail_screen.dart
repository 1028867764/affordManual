import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'data/organisms_data.dart';
import 'data/industry_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'search_page.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = true;
  String? _enlargedImageUrl;
  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  List<Map<String, dynamic>> _priceHistory = [];
  bool _isFavorited = false;
  late final String _favoriteKey;
  double _scrollOffset = 0.0;
  double _buttonOpacity = 1.0;
  bool _showTitle = false;
  bool _showSearchIcon = true;
  final double _scrollThreshold = 100;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  bool _titleShownByScroll = false; // 新增：标记标题是否由主内容滚动显示
  bool _titleShownBySheet = false; // 新增：标记标题是否由抽屉滑动显示

  String getCategoryPath(Product product) {
    for (var category in organisms) {
      for (var group in category.parentProductGroups) {
        for (var parentProduct in group.parentProducts) {
          for (var childProduct in parentProduct.childProducts) {
            if (childProduct.id == product.id) {
              return category.id;
            }
          }
        }
      }
    }
    return '?';
  }

  String getFactoryCategoryPath(dynamic product) {
    for (var category in factories.keys) {
      for (var item in factories[category]!) {
        if (item['id'] == product.id) {
          return category;
        }
      }
    }
    return '?';
  }

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
    _favoriteKey = 'favorite_${widget.product.id}';
    _loadFavoriteStatus();
    _scrollController.addListener(_handleScroll);
    _sheetController.addListener(_handleSheetScroll); // 添加监听器
    _loadPriceHistory();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  // 处理底部抽屉滑动
  void _handleSheetScroll() {
    setState(() {
      // 只有当标题不是由主内容滚动显示时才处理
      if (!_titleShownByScroll) {
        _titleShownBySheet = _sheetController.size > 0.9;
        _showTitle = _sheetController.size > 0.9;
      }
    });
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorited = prefs.getBool(_favoriteKey) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorited = !_isFavorited;
    });
    await prefs.setBool(_favoriteKey, _isFavorited);
  }

  Future<void> _loadPriceHistory() async {
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
    _sheetController.removeListener(_handleSheetScroll); // 移除监听器
    _sheetController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
      // _buttonOpacity = 1.0 - (_scrollOffset.clamp(0, 100) / 100) * 0.7;  收藏按钮已经不需要变化透明度了
      // 主内容滚动控制标题显示
      if (_scrollOffset > _scrollThreshold) {
        _titleShownByScroll = true;
        _showTitle = true;
      } else {
        _titleShownByScroll = false;
        // 只有当标题不是由抽屉滑动显示时才隐藏
        if (!_titleShownBySheet) {
          _showTitle = false;
        }
      }
    });
  }

  Widget _buildPriceHistoryTable() {
    final latestData =
        (_priceHistory.toList()..sort((a, b) => b['time'].compareTo(a['time'])))
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

  Widget _buildDragHead() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(child: _buildPriceHistoryTable()), // 表格占满剩余空间
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: _toggleFavorite,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: Icon(
                  _isFavorited
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: _isFavorited ? kBilibiliPink : Colors.grey[300],
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldPath =
        widget.product.id.startsWith('organisms')
            ? "生物篇"
            : widget.product.id.startsWith('factories')
            ? "工业篇"
            : "未知";

    final categoryPath =
        widget.product.id.startsWith('organisms')
            ? getCategoryPath(widget.product)
            : widget.product.id.startsWith('factories')
            ? getFactoryCategoryPath(widget.product)
            : "未知";

    final markdownContent = """
![示例图片](http://img.tukuppt.com/photo-small/19/94/23/706589110a5f2073682.jpg)
   
&emsp;&emsp;这是一段示例描述。产品ID: ${widget.product.id}《零的焦点》则以一对夫妻的生活为切入点，展现了一幅日本战后社会的众生相。女主人公绫子看似拥有幸福美满的家庭，然而，丈夫的神秘失踪打破了这份平静。随着调查的深入，一系列惊人的真相逐渐浮出水面。原来，丈夫的过去涉及到一些不为人知的秘密，而这些秘密与当时日本社会的种种问题紧密相连。在这个过程中，作者揭示了战争给人们带来的创伤以及战后社会的混乱与迷茫。人们在追求物质生活的同时，往往忽略了内心的真实需求，导致道德观念的扭曲和人际关系的冷漠。通过对这起案件的描写，读者不仅能够感受到推理小说的紧张刺激，还能对社会现实进行深刻的反思。  
#### &emsp;第一节
![示例图片](http://img.tukuppt.com/photo-small/19/94/23/706589110a5f2073682.jpg)

&emsp;&emsp;《夜蝉》的故事发生在一个宁静而又略显封闭的小镇。小镇的生活节奏缓慢，人们过着平淡而又规律的日子，仿佛时间在这里停滞了一般。然而，一起突如其来的谋杀案打破了这份宁静，如同平静的湖面投入了一颗巨石。  
&emsp;&emsp;案件发生在一个看似普通的夜晚，一位与小镇生活息息相关的人物被发现离奇死亡。随着调查的展开，各种线索逐渐浮出水面，但这些线索却如同夜空中的繁星，看似繁多却又各自独立，让人难以捉摸其中的关联。北村薰以其独特的叙事手法，将读者带入了一个充满悬念和神秘色彩的世界，让人们对这起案件充满了好奇和探索的欲望。
#### &emsp;第二节
&emsp;&emsp;这是一段示例描述。《零的焦点》则以一对夫妻的生活为切入点，展现了一幅日本战后社会的众生相。女主人公绫子看似拥有幸福美满的家庭，然而，丈夫的神秘失踪打破了这份平静。随着调查的深入，一系列惊人的真相逐渐浮出水面。原来，丈夫的过去涉及到一些不为人知的秘密，而这些秘密与当时日本社会的种种问题紧密相连。在这个过程中，作者揭示了战争给人们带来的创伤以及战后社会的混乱与迷茫。人们在追求物质生活的同时，往往忽略了内心的真实需求，导致道德观念的扭曲和人际关系的冷漠。通过对这起案件的描写，读者不仅能够感受到推理小说的紧张刺激，还能对社会现实进行深刻的反思。  
#### &emsp;☢第三节
![示例图片](http://gd-hbimg.huaban.com/2288348e418d1372bab85e5266cae51b2d66503c6155b-KgiKde)

&emsp;&emsp;《夜蝉》的故事发生在一个宁静而又略显封闭的小镇。小镇的生活节奏缓慢，人们过着平淡而又规律的日子，仿佛时间在这里停滞了一般。然而，一起突如其来的谋杀案打破了这份宁静，如同平静的湖面投入了一颗巨石。  
&emsp;&emsp;案件发生在一个看似普通的夜晚，一位与小镇生活息息相关的人物被发现离奇死亡。随着调查的展开，各种线索逐渐浮出水面，但这些线索却如同夜空中的繁星，看似繁多却又各自独立，让人难以捉摸其中的关联。北村薰以其独特的叙事手法，将读者带入了一个充满悬念和神秘色彩的世界，让人们对这起案件充满了好奇和探索的欲望。 
    """;

    return WillPopScope(
      onWillPop: () async {
        if (_enlargedImageUrl != null) {
          _closeEnlargedImage();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // 禁用阴影
          scrolledUnderElevation: 0, // 关键！禁止滚动时 elevation 变化
          surfaceTintColor: Colors.transparent, // 禁用 Material 3 的 tint 效果
          leadingWidth: _showTitle ? 56 : 100,
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
              if (!_showTitle) const SizedBox(width: 10),
              if (!_showTitle)
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
          title: AnimatedOpacity(
            opacity: _showTitle ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: Transform.translate(
              offset: Offset(0, _showTitle ? 0 : 10),
              child: Text(widget.product.name[0]),
            ),
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
                    MaterialPageRoute(
                      builder: (context) => const MainHomePage(),
                    ),
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
                    color: Colors.black,
                    child: PhotoView(
                      imageProvider: NetworkImage(_enlargedImageUrl!),
                      minScale: PhotoViewComputedScale.contained * 0.5,
                      maxScale: PhotoViewComputedScale.covered * 3.0,
                      initialScale: PhotoViewComputedScale.contained,
                      basePosition: Alignment.center,
                      backgroundDecoration: BoxDecoration(color: Colors.black),
                      gestureDetectorBehavior: HitTestBehavior.opaque,
                      enableRotation: false,
                      loadingBuilder:
                          (context, event) =>
                              Center(child: CircularProgressIndicator()),
                      errorBuilder:
                          (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                    ),
                  ),
                )
                : _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                  children: [
                    // 主内容区域
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          // 产品名称
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SelectableText(
                              '【${widget.product.name[0]}】',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // 左右容器
                          Container(
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              children: [
                                // 左边容器 - 英文名称
                                Expanded(
                                  child: Container(
                                    height: 120,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ).copyWith(left: 0, right: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SelectableText(
                                          '英文名称',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const Spacer(),
                                        SelectableText(
                                          widget.product.name.length > 1
                                              ? widget.product.name[1]
                                              : '暂无',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // 右边容器 - 搜索路径
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ).copyWith(left: 5, right: 0),
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SelectableText(
                                          '搜索路径',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const Spacer(),
                                        SelectableText(
                                          '$fieldPath>>$categoryPath',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 其它名称
                          if (widget.product.name.length > 2)
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 0,
                              ).copyWith(top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SelectableText(
                                '其它名称: ${widget.product.name.sublist(2).join(', ')}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          // 提示文字 - 向上滑动查看详情
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                              '↑ 向上滑动查看详情',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          // 介绍文本
                          Center(
                            child: Markdown(
                              data: markdownContent,
                              shrinkWrap: true,
                              selectable: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                              imageBuilder: (uri, title, alt) {
                                return GestureDetector(
                                  onTap: () => _enlargeImage(uri.toString()),
                                  child: Center(
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
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // 留出空间给抽屉
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                        ],
                      ),
                    ),

                    // 可拖动抽屉
                    DraggableScrollableSheet(
                      controller: _sheetController,
                      initialChildSize: 0.3,
                      minChildSize: 0.3,
                      maxChildSize: 1.0,
                      snap: true,
                      snapSizes: [0.3, 0.7, 1.0],
                      builder: (
                        BuildContext context,
                        ScrollController scrollController,
                      ) {
                        //使用 GestureDetector 包裹整个 Column
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque, // 确保手势能穿透
                          onVerticalDragUpdate: (details) {
                            // 手动控制拖拽逻辑（可选）
                            _sheetController.jumpTo(
                              _sheetController.size -
                                  details.primaryDelta! /
                                      MediaQuery.of(context).size.height,
                            );
                          },
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            elevation: 8,
                            child: Column(
                              children: [
                                Container(
                                  height: 6,
                                  width: 40,
                                  margin: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                _buildDragHead(), // 替换为新的组合组件
                                Expanded(
                                  child: CustomScrollView(
                                    controller: scrollController,
                                    slivers: [
                                      SliverPadding(
                                        padding: const EdgeInsets.fromLTRB(
                                          10,
                                          5,
                                          10,
                                          15,
                                        ),
                                        sliver: SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                              // 创建1-20的数字盒子
                                              return Container(
                                                height: 60,
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[50],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: Colors.grey[300]!,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            childCount: 20, // 生成20个盒子
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
