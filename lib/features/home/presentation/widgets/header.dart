import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegmart/features/home/data/models/category_item.dart';
import 'package:vegmart/features/home/presentation/widgets/header_category_item.dart';
import 'package:vegmart/features/notification/presentation/screens/notification_screen.dart';
import 'package:vegmart/features/product/presentation/screens/product_search_screen.dart';

class Header extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String) onSearch;
  final Function(int) onCategoryChanged;
  final Function() onCartPressed;
  final int cartItemCount;
  final int selectedCategoryIndex;

  const Header({
    super.key,
    required this.scrollController,
    required this.onSearch,
    required this.onCategoryChanged,
    required this.onCartPressed,
    required this.cartItemCount,
    required this.selectedCategoryIndex,
  });

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  final bool _searchExpanded = false;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  late AnimationController _controller;
  late TabController _tabController;
  final _notificationKey = GlobalKey();

  final List<CategoryItem> categories = [
    CategoryItem('All', 'assets/icons/bag.svg', const Color(0xFFFC8019)),
    CategoryItem('Vegetables', 'assets/icons/tomato.svg', const Color(0xFF4CAF50)),
    CategoryItem('Fruits', 'assets/icons/apple.svg', const Color(0xFF2196F3)),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _tabController = TabController(length: categories.length, vsync: this, initialIndex: widget.selectedCategoryIndex);
    _searchFocusNode.addListener(() {
      setState(() => _isSearching = _searchFocusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(covariant Header oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategoryIndex != widget.selectedCategoryIndex) {
      _tabController.animateTo(widget.selectedCategoryIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _openNotification() {
    if (!mounted) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => NotificationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _openSearchExpend() {
    if (!mounted) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProductSearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1E2125) : Colors.white;
    return SliverAppBar(
      expandedHeight: 190.0,
      floating: false,
      pinned: true,
      backgroundColor: backgroundColor,
      elevation: 0,
      surfaceTintColor: backgroundColor,
      flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.pin, background: _buildHeaderContent(isDarkMode)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Column(children: [_buildSearchBar(isDarkMode, theme), _buildCategoryBar(theme)]),
      ),
    );
  }

  Widget _buildHeaderContent(bool isDarkMode) {
    return Column(
      children: [
        // Top spacing
        SizedBox(height: MediaQuery.of(context).padding.top + 12),
        // Delivery info row
        if (!_searchExpanded) _buildDeliveryInfoRow(isDarkMode),
      ],
    );
  }

  Widget _buildDeliveryInfoRow(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Location info
          Expanded(
            child: GestureDetector(
              onTap: _showAddressSheet,
              child: Row(
                children: [
                  SizedBox(width: 35, height: 35, child: Image.asset("assets/location.png")),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery to Home...',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Color(0xFFD1D1D1) : Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'I-24, 2nd Floor, Honour...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? Color(0xFFD1D1D1) : Colors.grey[900],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 17),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: isDarkMode ? Color(0xFFD1D1D1) : Colors.grey[900],
                        size: 25,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Notification
          GestureDetector(
            key: _notificationKey,
            onTapDown: (_) => setState(() => {}),
            onTapUp: (_) {
              setState(() => {});
              HapticFeedback.lightImpact();
              widget.onCartPressed();
              _openNotification();
            },
            onTapCancel: () => setState(() => {}),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF23282C) : Colors.grey[200],
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(Icons.notifications, color: isDarkMode ? Color(0xFFD1D1D1) : Colors.black87, size: 32),

                  // Animated badge
                  if (widget.cartItemCount > 0)
                    Positioned(
                      top: 3,
                      right: 5,
                      child: Container(
                        padding: EdgeInsets.all(widget.cartItemCount > 9 ? 4 : 2),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF5F6D), Color(0xFFFF420D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: isDarkMode ? Color(0xFFD1D1D1) : Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(color: Colors.red[300]!.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 1)),
                          ],
                        ),
                        child: Text(
                          widget.cartItemCount > 9 ? '9+' : widget.cartItemCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w900, height: 1.0),
                          textAlign: TextAlign.center,
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

  Widget _buildSearchBar(bool isDarkMode, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        height: 48,
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF23282C) : Colors.white,
          borderRadius: BorderRadius.circular(24), // More rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isSearching ? 0.12 : 0.08),
              blurRadius: _isSearching ? 16 : 12,
              spreadRadius: _isSearching ? -4 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _buildCollapsedSearch(isDarkMode, theme),
      ),
    );
  }

  Widget _buildCollapsedSearch(bool isDarkMode, ThemeData theme) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(_searchFocusNode);
            _openSearchExpend();
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.search_rounded,
                  key: ValueKey(_isSearching),
                  color: isDarkMode ? Color(0xFFD4D5DA) : theme.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(color: isDarkMode ? Color(0xFFD1D1D1) : Colors.grey[600], fontSize: 15),
                  child: const Text('Search for products...'),
                ),
              ),
              Container(
                width: 1,
                height: 24,
                color: isDarkMode ? Color(0xFFD1D1D1) : const Color(0xFFEEEEEE).withOpacity(0.8),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              IconButton(
                icon: Icon(Icons.mic_rounded, color: isDarkMode ? Color(0xFFD1D1D1) : theme.primaryColor),
                iconSize: 22,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _startVoiceSearch(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startVoiceSearch() {
    // Implement voice search functionality
    HapticFeedback.lightImpact();
    // Show a dialog or start voice recognition
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Voice Search'),
            content: const Text('Speak now to search...'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
          ),
    );
  }

  void _showAddressSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Select Delivery Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _buildAddressTile(
                icon: Icons.home_rounded,
                title: 'Home',
                address: '123 Main Street, Mumbai 400001',
                selected: true,
              ),
              _buildAddressTile(
                icon: Icons.work_rounded,
                title: 'Work',
                address: '456 Business Park, Mumbai 400002',
                selected: false,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {}, // Add new address
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFC8019),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Add New Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressTile({required IconData icon, required String title, required String address, required bool selected}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: const Color(0xFFFFF0E6), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: const Color(0xFFFC8019)),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: selected ? const Color(0xFFFC8019) : Colors.black)),
      subtitle: Text(address, style: const TextStyle(fontSize: 13, color: Color(0xFF666666))),
      trailing: selected ? const Icon(Icons.check_circle, color: Color(0xFFFC8019)) : null,
      onTap: () => Navigator.pop(context),
    );
  }

  Widget _buildCategoryBar(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: Stack(
            children: [
              // Category Items Row
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / categories.length;
                  return Row(
                      children: List.generate(categories.length, (index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        _tabController.animateTo(index,
                          curve: Curves.easeOutCubic,
                        );
                        widget.onCategoryChanged(index);
                      },
                      child: SizedBox(
                        width: itemWidth,
                        child: HeaderCategoryItem(
                          category.name,
                          category.icon,
                          _tabController.index == index,
                        ),
                      ),
                    );
                  }),
                  );
                },
              ),

              // Curved Indicator - Fixed Position Version
              Positioned(
                bottom: 0,
                left: 0,
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    final position = _tabController.animation!.value;
                    final itemWidth = MediaQuery.of(context).size.width / categories.length;
                    final indicatorWidth = itemWidth * 0.7;

                    // Calculate exact position without bounce effect
                    final x = (position * itemWidth) + (itemWidth - indicatorWidth)/2;

                    return Transform.translate(
                      offset: Offset(x, 0),
                      child: Container(
                        width: indicatorWidth,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: const Color(0xFFECECEC),
        ),
      ],
    );
  }
}