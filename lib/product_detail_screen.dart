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
import 'dart:ui';
import 'price_tag.dart';
import 'price_calendar.dart';

// 闲鱼科技蓝
const Color xianyuBlue = Color(0xFF00E5FF);
// 酷安绿
const Color coolapkGreen = Color(0xFF2E8B57);
// 赛博朋克绿
const Color cyberpunkGreen = Color(0xFF00FFD1);
//表格颜色样式
final List<Color> tableColors = [Colors.yellow.shade100, Colors.yellow.shade50];
//表格名称字体颜色
const Color tableFontColors = Colors.black;

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String? _enlargedImageUrl;
  List<Map<String, dynamic>> _priceHistory = [];
  bool _isFavorited = false;
  late final String _favoriteKey;
  late TabController _tabController;
  final List<String> _tabs = ['介绍', '记账', '报价'];
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false; // 是否滚动超过 50px
  bool _showBackToTop = false;
  final double _backToTopThreshold = 129.9; // 显示返回顶部按钮的滚动阈值

  void _handleScroll() {
    // 检查是否滚动超过 50 像素
    final bool isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
    // 检查是否显示返回顶部按钮
    final bool showBackToTop = _scrollController.offset > _backToTopThreshold;
    if (showBackToTop != _showBackToTop) {
      setState(() {
        _showBackToTop = showBackToTop;
      });
    }
  }

  // 添加返回顶部方法
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

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
    setState(() {
      _enlargedImageUrl = imageUrl;
    });
  }

  void _closeEnlargedImage() {
    setState(() {
      _enlargedImageUrl = null;
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
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadPriceHistory();
    _scrollController.addListener(_handleScroll); // 添加滚动监听
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
    final priceData = await quotedPrice();
    setState(() {
      _priceHistory = priceData;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBottomGap() {
    return SizedBox(height: 180);
  }

  Widget _buildDetailContent() {
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
![示例图片](https://sparrow-done-1360679961.cos.ap-guangzhou.myqcloud.com/${widget.product.id}_picture_1.jpg)
![示例图片](https://sparrow-done-1360679961.cos.ap-guangzhou.myqcloud.com/${widget.product.id}_picture_2.jpg)
   
&emsp;&emsp;这是一段示例描述。产品ID: '${widget.product.id}' 以下几种薄荷品种通常产量较大：  
&emsp;&emsp;这是一段示例描述。产品ID: '${widget.product.id}_markdown_1' 以下几种薄荷品种通常产量较大：  
&emsp;&emsp;这是一段示例描述。产品ID: '${widget.product.id}_picture_1' 以下几种薄荷品种通常产量较大：
- **“73~8”薄荷**：由轻工业部香料工业科学研究所培育的青茎高产品种。该品种生长旺盛，抗逆性强，叶片油腺密度大，挥发油产量较高。其分枝多，节间短，叶大，腺鳞分布较密，鲜草得油率0.3% - 0.51%，每667米²产油量为9.75 - 15.22千克，含薄荷油为80.1% - 87.6%。
- **“上海39号”薄荷（亚洲39）**：轻工业部香料工业科学研究所培育的紫茎型薄荷新品种。生长旺盛，“头刀”薄荷株高90 - 120cm，“二刀”薄荷70 - 80cm，分枝多，抗逆性、适应性强，鲜草产量高。
- **“阜油1号”薄荷**：属于青茎类型品系。生长健壮，抗倒伏、抗逆性强，“头刀”主茎100 - 140cm，“二刀”主茎50 - 70cm；具有早熟性，比一般品种早开花7 - 10天。
- **青茎圆叶种**：植株的茎上部呈青色，叶短卵圆形有光泽，株矮，分枝多，富含薄荷脑。在肥沃土地上种植，其高产特性明显，是栽培中的优良品种之一。

![示例图片](http://gd-hbimg.huaban.com/2288348e418d1372bab85e5266cae51b2d66503c6155b-KgiKde)
#### &emsp;第一节
&emsp;&emsp;《夜蝉》的故事发生在一个宁静而又略显封闭的小镇。小镇的生活节奏缓慢，人们过着平淡而又规律的日子，仿佛时间在这里停滞了一般。然而，一起突如其来的谋杀案打破了这份宁静，如同平静的湖面投入了一颗巨石。  
&emsp;&emsp;案件发生在一个看似普通的夜晚，一位与小镇生活息息相关的人物被发现离奇死亡。随着调查的展开，各种线索逐渐浮出水面，但这些线索却如同夜空中的繁星，看似繁多却又各自独立，让人难以捉摸其中的关联。北村薰以其独特的叙事手法，将读者带入了一个充满悬念和神秘色彩的世界，让人们对这起案件充满了好奇和探索的欲望。
#### &emsp;第二节
&emsp;&emsp;这是一段示例描述。《零的焦点》则以一对夫妻的生活为切入点，展现了一幅日本战后社会的众生相。女主人公绫子看似拥有幸福美满的家庭，然而，丈夫的神秘失踪打破了这份平静。随着调查的深入，一系列惊人的真相逐渐浮出水面。原来，丈夫的过去涉及到一些不为人知的秘密，而这些秘密与当时日本社会的种种问题紧密相连。在这个过程中，作者揭示了战争给人们带来的创伤以及战后社会的混乱与迷茫。人们在追求物质生活的同时，往往忽略了内心的真实需求，导致道德观念的扭曲和人际关系的冷漠。通过对这起案件的描写，读者不仅能够感受到推理小说的紧张刺激，还能对社会现实进行深刻的反思。  

""";

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade900,
            child: Column(
              children: [
                SizedBox(height: 10),
                //柜式布局
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        '',
                        style: const TextStyle(
                          fontSize: 5,
                          fontWeight: FontWeight.bold,
                        ),
                      ), //勿删！为了防止第一行文本被选中时候屏幕不受控滚动
                      // 第一行
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch, // 让子部件拉伸填满高度
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 2,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: tableColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8), // 左上角
                                  topRight: Radius.circular(0), // 右上角
                                  bottomLeft: Radius.circular(0), // 左下角
                                  bottomRight: Radius.circular(0), // 右下角
                                ),
                              ),
                              child: const Center(
                                child: SelectableText(
                                  '商品名称',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: tableFontColors,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 2,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: tableColors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0), // 左上角
                                    topRight: Radius.circular(8), // 右上角
                                    bottomLeft: Radius.circular(0), // 左下角
                                    bottomRight: Radius.circular(0), // 右下角
                                  ),
                                ),
                                child: Center(
                                  child: SelectableText(
                                    widget.product.name[0],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 第二行
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 2,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: tableColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0), // 左上角
                                  topRight: Radius.circular(0), // 右上角
                                  bottomLeft: Radius.circular(0), // 左下角
                                  bottomRight: Radius.circular(0), // 右下角
                                ),
                              ),
                              child: const Center(
                                child: SelectableText(
                                  '搜索路径',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: tableFontColors,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 2,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: tableColors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0), // 左上角
                                    topRight: Radius.circular(0), // 右上角
                                    bottomLeft: Radius.circular(0), // 左下角
                                    bottomRight: Radius.circular(0), // 右下角
                                  ),
                                ),
                                child: Center(
                                  child: SelectableText(
                                    '$fieldPath>>$categoryPath',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //第三行
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 2,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: tableColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0), // 左上角
                                  topRight: Radius.circular(0), // 右上角
                                  bottomLeft: Radius.circular(0), // 左下角
                                  bottomRight: Radius.circular(0), // 右下角
                                ),
                              ),
                              child: const Center(
                                child: SelectableText(
                                  '英文名称',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: tableFontColors,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 2,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: tableColors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0), // 左上角
                                    topRight: Radius.circular(0), // 右上角
                                    bottomLeft: Radius.circular(0), // 左下角
                                    bottomRight: Radius.circular(0), // 右下角
                                  ),
                                ),
                                child: Center(
                                  child: SelectableText(
                                    widget.product.name.length > 1
                                        ? widget.product.name[1]
                                        : '暂无',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 第四行
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 2,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: tableColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0), // 左上角
                                  topRight: Radius.circular(0), // 右上角
                                  bottomLeft: Radius.circular(8), // 左下角
                                  bottomRight: Radius.circular(0), // 右下角
                                ),
                              ),
                              child: const Center(
                                child: SelectableText(
                                  '其它名称',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: tableFontColors,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 2,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: tableColors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0), // 左上角
                                    topRight: Radius.circular(0), // 右上角
                                    bottomLeft: Radius.circular(0), // 左下角
                                    bottomRight: Radius.circular(8), // 右下角
                                  ),
                                ),
                                child: Center(
                                  child: SelectableText(
                                    widget.product.name.length > 2
                                        ? '${widget.product.name.sublist(2).join(', ')}'
                                        : '暂无',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),

                Container(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16), // 左上角
                      topRight: Radius.circular(16), // 右上角
                      bottomLeft: Radius.circular(0), // 左下角
                      bottomRight: Radius.circular(0), // 右下角
                    ),
                  ),
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
                            width: MediaQuery.of(context).size.width * 0.6,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          _buildBottomGap(),
        ],
      ),
    );
  }

  Widget _buildPriceContent() {
    return PriceTagContent(
      priceHistory: _priceHistory,
      bottomGap: _buildBottomGap(),
      productId: widget.product.id,
    );
  }

  Widget _buildCalendarContent() {
    return PriceCalendar(
      bottomGap: _buildBottomGap(),
      productId: widget.product.id,
      productName: widget.product.name[0],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
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
              SizedBox(width: _isScrolled ? 10 : 10),
              if (!_isScrolled)
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
              AnimatedOpacity(
                opacity: _isScrolled ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Align(
                  alignment: Alignment.centerLeft, // 左对齐
                  child: Text(
                    _isScrolled
                        ? widget.product.name[0]
                        : widget.product.name[0],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                : NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (
                    BuildContext context,
                    bool innerBoxIsScrolled,
                  ) {
                    return <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        expandedHeight: 80.0,
                        pinned: false,
                        flexibleSpace: Stack(
                          children: [
                            // 背景图片
                            Positioned.fill(
                              child: Image.asset(
                                'assets/images/beach1.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            // 标题（暂时移除）
                            /*  Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5,
                                      sigmaY: 5,
                                    ),
                                    child: IntrinsicWidth(
                                      child: IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: kBilibiliPink.withOpacity(
                                              0.7,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: kBilibiliPink,
                                              width: 2.0,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal: 4,
                                          ),
                                          child: Text(
                                            widget.product.name[0],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _StickyTabBarDelegate(
                          child: TabBar(
                            labelColor: Colors.blue, // 选中标签的文字颜色
                            unselectedLabelColor: Colors.grey, // 未选中标签的文字颜色
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ), // 选中标签的文字样式
                            unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                            ), // 未选中标签的文字样式
                            indicatorColor: Colors.blue, // 指示器颜色
                            indicatorWeight: 4.0, // 指示器厚度
                            controller: _tabController,
                            tabs:
                                _tabs
                                    .map((String name) => Tab(text: name))
                                    .toList(),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDetailContent(),
                      _buildCalendarContent(),
                      _buildPriceContent(),
                    ],
                  ),
                ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              right: 7, // 水平偏移量（根据需求调整）
              bottom: 14, // 垂直偏移量（根据需求调整）
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: _toggleFavorite,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _isFavorited
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: _isFavorited ? kBilibiliPink : Colors.grey[500],
                        size: 40, // 适当缩小图标以适配小尺寸
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 添加返回顶部按钮
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              right: 13,
              bottom: _showBackToTop ? 80.0 : 80.0, // 当显示时上移，避免与收藏按钮重叠
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showBackToTop ? 1.0 : 0.0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: _scrollToTop,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_upward,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: child);
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
