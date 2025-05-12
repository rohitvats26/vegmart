import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vegmart/core/theme/app_colors.dart';
import 'package:vegmart/core/widgets/product_add_popup.dart';
import 'package:vegmart/features/product/presentation/screens/product_detail_screen.dart';
import 'package:vegmart/features/product/presentation/widgets/product_card.dart';
import 'package:vegmart/features/product/presentation/widgets/shimmer_product_card.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<String> recentSearches = ['Organic Avocado', 'Almond Milk', 'Free Range Eggs'];
  List<String> searchSuggestions = ['Organic Fruits', 'Gluten Free', 'Vegan', 'Protein', 'Dairy Free', 'Keto Friendly'];
  bool showSuggestions = false;
  bool isSearching = false;

  final List<Map<String, dynamic>> products = [
    {
      'title': 'Medium Spices Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '16',
      'originalPrice': '25',
      'quantity': '1 piece',
      'discount': '21%',
    },
    {
      'title': 'Small Bundle Pack',
      'image': 'assets/vegetables/carrots.jpg',
      'currentPrice': '20',
      'originalPrice': '35',
      'quantity': '500gm',
      'discount': '15% OFF',
    },
    {
      'title': 'Big Finite Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '32',
      'originalPrice': '45',
      'quantity': '1kg',
      'discount': '10% OFF',
    },
    {
      'title': 'Big Finite Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '32',
      'originalPrice': '45',
      'quantity': '1kg',
      'discount': '10% OFF',
    },
    {
      'title': 'Big Finite Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '32',
      'originalPrice': '45',
      'quantity': '1kg',
      'discount': '10% OFF',
    },{
      'title': 'Big Finite Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '32',
      'originalPrice': '45',
      'quantity': '1kg',
      'discount': '10% OFF',
    },{
      'title': 'Big Finite Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '32',
      'originalPrice': '45',
      'quantity': '1kg',
      'discount': '10% OFF',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _searchFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_searchFocusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {
      showSuggestions = _searchFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.removeListener(_handleFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    if (!recentSearches.contains(query)) {
      setState(() {
        recentSearches.insert(0, query);
        if (recentSearches.length > 5) {
          recentSearches.removeLast();
        }
      });
    }

    setState(() => isSearching = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 500;
    final isTablet = screenWidth >= 500 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024 && screenWidth < 1400;
    final isExtraLargeDesktop = screenWidth > 1400;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Color(0xFFF8F9FA);

    return Scaffold(
      appBar: _buildAppBar(theme, isDarkMode, isTablet, isDesktop),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          _buildMainContent(theme, colors, isMobile, isTablet, isDesktop, isExtraLargeDesktop, isDarkMode),
          if (showSuggestions && !isSearching) _buildSearchSuggestions(theme, isDarkMode, isTablet),
        ],
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme, bool isDarkMode, bool isTablet, bool isDesktop) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFFF8F9FA),
      toolbarHeight: isTablet ? 120 : 80,
      // Set custom height for AppBar
      titleSpacing: 0,
      // Remove default title spacing
      title: Container(
        padding: EdgeInsets.fromLTRB(isTablet ? 24 : 16, isDesktop ? 30 : 30, isTablet ? 24 : 16, isDesktop ? 30 : 30),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: isTablet ? 56 : 48,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E2125) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? theme.textTheme.bodyLarge!.fontSize! * 1.1 : null,
              ),
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: theme.colorScheme.primary, size: isTablet ? 28 : 24),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                hintText: 'Search groceries...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFADB5BD),
                  fontSize: isTablet ? theme.textTheme.bodyMedium!.fontSize! * 1.1 : null,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                suffixIcon:
                    _searchController.text.isEmpty
                        ? IconButton(
                          icon: Icon(Icons.mic_rounded, size: isTablet ? 24 : 20, color: theme.colorScheme.primary),
                          onPressed: () async {
                            final voiceResult = await _showVoiceSearchDialog(context);
                            if (voiceResult != null) {
                              _searchController.text = voiceResult;
                              _performSearch(voiceResult);
                            }
                          },
                        )
                        : IconButton(
                          icon: Icon(Icons.close_rounded, size: isTablet ? 24 : 20, color: theme.colorScheme.primary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => isSearching = false);
                          },
                        ),
              ),
              onChanged: (value) => setState(() {}),
              onSubmitted: _performSearch,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme, AppColors colors, bool isMobile, bool isTablet, bool isDesktop, bool isExtraLargeDesktop, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(isTablet ? 24 : 16, isTablet ? 24 : 16, isTablet ? 24 : 16, isTablet ? 120 : 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSearching) _buildPopularPacksSection(theme, isMobile, isTablet, isDesktop, isExtraLargeDesktop, isDark),
          if (isSearching) _buildSearchResults(theme, colors, isTablet),
        ],
      ),
    );
  }

  Widget _buildPopularPacksSection(ThemeData theme, bool isMobile, bool isTablet, bool isDesktop, bool isExtraLargeDesktop, bool isDark) {
    final crossAxisCount =
        isExtraLargeDesktop
            ? 7
            : isDesktop
            ? 6
            : (isTablet ? 4 : 2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
          child: Text(
            'Popular Pack',
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: isTablet ? theme.textTheme.displaySmall!.fontSize! * 1.2 : null,
              color: isDark ? Colors.white : const Color(0xFF000008),
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isExtraLargeDesktop ? 15 : 8.0,
            mainAxisSpacing: 8.0,
            mainAxisExtent: 310,
          ),
          itemCount: products.length,
          itemBuilder:
              (context, index) => ProductCard(
                title: products[index]['title'],
                imagePath: products[index]['image'],
                currentPrice: products[index]['currentPrice'],
                originalPrice: products[index]['originalPrice'],
                tag: 'Most Bought',
                quantity: products[index]['quantity'],
                discount: products[index]['discount'],
                onProductTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(),
                  ));
                },
                onAddPressed: () {
                  ProductAddPopup.show(context);
                },
              ).animate(delay: (100 * index).ms).fadeIn(duration: 300.ms).slideY(begin: 0.1),
        ),
      ],
    );
  }

  Widget _buildSearchResults(ThemeData theme, AppColors colors, bool isTablet) {
    return Column(
      children: [
        SizedBox(height: isTablet ? 60 : 40),
        Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              ).animate(onPlay: (controller) => controller.repeat()).rotate(duration: 1000.ms),
              SizedBox(height: isTablet ? 24 : 16),
              Text(
                'Searching for "${_searchController.text}"',
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: isTablet ? theme.textTheme.bodyLarge!.fontSize! * 1.1 : null),
              ),
            ],
          ),
        ),
        SizedBox(height: isTablet ? 32 : 24),
        ...List.generate(
          3,
          (index) => Padding(padding: EdgeInsets.only(bottom: isTablet ? 24 : 16), child: ShimmerProductCard(colors: colors, isTablet: isTablet)),
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions(ThemeData theme, bool isDark, bool isTablet) {
    return Positioned(
      top: kToolbarHeight + -55,
      left: isTablet ? 24 : 18,
      right: isTablet ? 24 : 16,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(20),
          color: theme.cardTheme.color,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_searchController.text.isEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(isTablet ? 20 : 16, isTablet ? 16 : 12, isTablet ? 20 : 16, isTablet ? 12 : 8),
                      child: Text(
                        'Popular Categories',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: isTablet ? theme.textTheme.bodySmall!.fontSize! * 1.1 : null,
                        ),
                      ),
                    ),
                  ..._buildSuggestionsList(theme, isTablet),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSuggestionsList(ThemeData theme, bool isTablet) {
    final query = _searchController.text.toLowerCase();
    final suggestions = query.isEmpty ? searchSuggestions : searchSuggestions.where((item) => item.toLowerCase().contains(query)).toList();

    return suggestions
        .map(
          (suggestion) => ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
            leading: Container(
              width: isTablet ? 40 : 30,
              height: isTablet ? 40 : 30,
              decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.search_rounded, size: isTablet ? 20 : 18, color: theme.colorScheme.primary),
            ),
            title: Text(
              suggestion,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: isTablet ? theme.textTheme.bodyLarge!.fontSize! * 1.1 : null),
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: isTablet ? 18 : 16, color: theme.textTheme.bodySmall?.color),
            onTap: () {
              _searchController.text = suggestion;
              _performSearch(suggestion);
              _searchFocusNode.unfocus();
            },
          ),
        )
        .toList();
  }

  Future<String?> _showVoiceSearchDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return await showDialog<String>(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: theme.cardTheme.color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isTablet ? 32 : 28)),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: isTablet ? 120 : 100,
                    height: isTablet ? 120 : 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.mic_rounded, size: isTablet ? 48 : 40, color: Colors.white),
                  ),
                  SizedBox(height: isTablet ? 32 : 24),
                  Text(
                    'Listening...',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: isTablet ? theme.textTheme.titleLarge!.fontSize! * 1.2 : null,
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Text(
                    'Say something like "Organic Avocado"',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: isTablet ? theme.textTheme.bodyMedium!.fontSize! * 1.1 : null),
                  ),
                  SizedBox(height: isTablet ? 32 : 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24, vertical: isTablet ? 18 : 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: theme.dividerColor)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.bodyLarge?.copyWith(fontSize: isTablet ? theme.textTheme.bodyLarge!.fontSize! * 1.1 : null),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24, vertical: isTablet ? 18 : 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.pop(context, 'Organic Avocado'),
                        child: Text(
                          'Simulate',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: isTablet ? theme.textTheme.bodyLarge!.fontSize! * 1.1 : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
