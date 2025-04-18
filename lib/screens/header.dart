import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegmart/screens/notification_screen.dart';
import 'package:vegmart/screens/search_screen.dart';

class Header extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String) onSearch;
  final Function(int) onCategoryChanged;
  final Function() onCartPressed;
  final int cartItemCount;

  const Header({
    super.key,
    required this.scrollController,
    required this.onSearch,
    required this.onCategoryChanged,
    required this.onCartPressed,
    required this.cartItemCount,
  });

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  final bool _searchExpanded = false;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  late int _selectedIndex;
  late AnimationController _controller;
  late TabController _tabController;
  final _notificationKey = GlobalKey();

  final List<CategoryItem> categories = [
    CategoryItem('All', 'icons/shopping-basket.png', const Color(0xFFFC8019)),
    CategoryItem('Vegetables', 'icons/vegetable.png', const Color(0xFF4CAF50)),
    CategoryItem('Fruits', 'icons/fruits.png', const Color(0xFF2196F3)),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _tabController = TabController(length: categories.length, vsync: this, initialIndex: _selectedIndex);
    _searchFocusNode.addListener(() {
      setState(() => _isSearching = _searchFocusNode.hasFocus);
    });
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
        pageBuilder:
            (context, animation, secondaryAnimation) => SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.pin, background: _buildHeaderContent()),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(98),
        child: Column(children: [_buildSearchBar(), _buildCategoryBar()]),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      children: [
        // Top spacing
        SizedBox(height: MediaQuery.of(context).padding.top + 12),
        // Delivery info row
        if (!_searchExpanded) _buildDeliveryInfoRow(),
      ],
    );
  }

  Widget _buildDeliveryInfoRow() {
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
                  SizedBox(width: 32, height: 32, child: Image.asset("location.png")),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery to Home...',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'I-24, 2nd Floor, Honour...',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey[900]),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 17),
                      Icon(Icons.keyboard_arrow_down_outlined, color: Colors.grey[900], size: 25),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications, color: Colors.black87, size: 32),

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
                          border: Border.all(color: Colors.white, width: 1.5),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: _buildCollapsedSearch(),
      ),
    );
  }

  Widget _buildCollapsedSearch() {
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
                  color: _isSearching ? const Color(0xFFFC8019) : const Color(0xFF999999),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(color: Colors.grey[_isSearching ? 800 : 600], fontSize: 15),
                  child: const Text('Search for products...'),
                ),
              ),
              Container(
                width: 1,
                height: 24,
                color: const Color(0xFFEEEEEE).withOpacity(0.8),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              IconButton(
                icon: const Icon(Icons.mic_rounded, color: Color(0xFF0DB561)),
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

  Widget _buildCategoryBar() {
    return Column(
      children: [
        SizedBox(
          height: 75,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate equal width for each category item
              final itemWidth = constraints.maxWidth / categories.length;

              return Row(
                children: List.generate(categories.length, (index) {
                  final category = categories[index];
                  final isSelected = _tabController.index == index;

                  return GestureDetector(
                    onTapDown: (_) => setState(() => {}),
                    onTapUp: (_) => setState(() => {}),
                    onTapCancel: () => setState(() => {}),
                    onTap: () {
                      _tabController.animateTo(index);
                      widget.onCategoryChanged(index);
                      _controller.forward(from: 0);
                    },
                    child: SizedBox(width: itemWidth, child: _CategoryItem(category.name, category.icon, isSelected)),
                  );
                }),
              );
            },
          ),
        ),
        Container(height: 1, color: Color(0xFFECECEC)),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String text;
  final String icon;
  final bool isSelected;

  const _CategoryItem(this.text, this.icon, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent, width: 2.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon above text
          SizedBox(width: 40, height: 40, child: Image.asset(icon)),
          const SizedBox(height: 4),
          // Category text
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : const Color(0xFF757575),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem {
  final String name;
  final String icon;
  final Color color;

  CategoryItem(this.name, this.icon, this.color);
}
