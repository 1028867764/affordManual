import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'data/organisms_data.dart';
import 'data/industry_data.dart';
import 'price_tag.dart';
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

  Widget _buildFavoriteButton() {
    return Positioned(
      top: 85,
      right: 15,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: _buttonOpacity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              _toggleFavorite();
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Icon(
                _isFavorited ? Icons.star_rounded : Icons.star_outline_rounded,
                color: _isFavorited ? kBilibiliPink : Colors.grey[300],
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
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
    _loadPriceHistory();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
    super.dispose();
  }

  void _handleScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
      _buttonOpacity = 1.0 - (_scrollOffset.clamp(0, 100) / 100) * 0.8;
    });
  }

  Widget _buildPriceHistoryTable() {
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
              color: Colors.blue.shade50,
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
                                        id: widget.product.id,
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

    final otherNames =
        widget.product.name.length > 2
            ? '- ​**其它名称**: ${widget.product.name.sublist(2).join(', ')}\n'
            : '';

    final markdownInfo = """
### &emsp;【​**${widget.product.name[0]}​**】
- ​英文名称: ${widget.product.name.length > 1 ? widget.product.name[1] : '暂无'}
$otherNames
- ​搜索路径: $fieldPath>>$categoryPath
- ​产品ID: ${widget.product.id}
""";

    final markdownContent = """
![示例图片](http://img.tukuppt.com/photo-small/19/94/23/706589110a5f2073682.jpg)
##### &emsp;第一节
&emsp;&emsp;这是一段示例描述。《零的焦点》则以一对夫妻的生活为切入点，展现了一幅日本战后社会的众生相。女主人公绫子看似拥有幸福美满的家庭，然而，丈夫的神秘失踪打破了这份平静。随着调查的深入，一系列惊人的真相逐渐浮出水面。原来，丈夫的过去涉及到一些不为人知的秘密，而这些秘密与当时日本社会的种种问题紧密相连。在这个过程中，作者揭示了战争给人们带来的创伤以及战后社会的混乱与迷茫。人们在追求物质生活的同时，往往忽略了内心的真实需求，导致道德观念的扭曲和人际关系的冷漠。通过对这起案件的描写，读者不仅能够感受到推理小说的紧张刺激，还能对社会现实进行深刻的反思。  
##### &emsp;第二节
![示例图片](http://img.tukuppt.com/photo-small/19/94/23/706589110a5f2073682.jpg)

&emsp;&emsp;《夜蝉》的故事发生在一个宁静而又略显封闭的小镇。小镇的生活节奏缓慢，人们过着平淡而又规律的日子，仿佛时间在这里停滞了一般。然而，一起突如其来的谋杀案打破了这份宁静，如同平静的湖面投入了一颗巨石。  
&emsp;&emsp;案件发生在一个看似普通的夜晚，一位与小镇生活息息相关的人物被发现离奇死亡。随着调查的展开，各种线索逐渐浮出水面，但这些线索却如同夜空中的繁星，看似繁多却又各自独立，让人难以捉摸其中的关联。北村薰以其独特的叙事手法，将读者带入了一个充满悬念和神秘色彩的世界，让人们对这起案件充满了好奇和探索的欲望。
##### &emsp;第三节
&emsp;&emsp;这是一段示例描述。《零的焦点》则以一对夫妻的生活为切入点，展现了一幅日本战后社会的众生相。女主人公绫子看似拥有幸福美满的家庭，然而，丈夫的神秘失踪打破了这份平静。随着调查的深入，一系列惊人的真相逐渐浮出水面。原来，丈夫的过去涉及到一些不为人知的秘密，而这些秘密与当时日本社会的种种问题紧密相连。在这个过程中，作者揭示了战争给人们带来的创伤以及战后社会的混乱与迷茫。人们在追求物质生活的同时，往往忽略了内心的真实需求，导致道德观念的扭曲和人际关系的冷漠。通过对这起案件的描写，读者不仅能够感受到推理小说的紧张刺激，还能对社会现实进行深刻的反思。  
##### &emsp;☢第四节
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
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.zero,
                            child: _buildPriceHistoryTable(),
                          ),
                          Markdown(
                            data: markdownInfo,
                            shrinkWrap: true,
                            selectable: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                        0.65,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildFavoriteButton(),
                  ],
                ),
      ),
    );
  }
}
