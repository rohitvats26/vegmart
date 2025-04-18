import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationBottomBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Color activeColor;
  final Color inactiveColor;
  final bool showLabels;
  final List<int>? badgeCounts;
  final bool useHapticFeedback;
  final double elevation;
  final double? height;
  final bool showActiveIndicator;
  final double activeIndicatorHeight;
  final Duration animationDuration;
  final Curve animationCurve;
  final List<BottomNavItem>? customItems;

  const NavigationBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
    this.showLabels = true,
    this.badgeCounts,
    this.useHapticFeedback = true,
    this.elevation = 6.0,
    this.height = 50,
    this.showActiveIndicator = true,
    this.activeIndicatorHeight = 3.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.fastOutSlowIn,
    this.customItems,
  });

  @override
  State<NavigationBottomBar> createState() => _NavigationBottomBarState();
}

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color? activeColor;
  final Color? inactiveColor;

  const BottomNavItem({required this.icon, required this.activeIcon, required this.label, this.activeColor, this.inactiveColor});
}

class _NavigationBottomBarState extends State<NavigationBottomBar> {
  late List<BottomNavItem> _navItems;

  @override
  void initState() {
    super.initState();
    _navItems = widget.customItems ?? _defaultNavItems();
  }

  List<BottomNavItem> _defaultNavItems() {
    return const [
      BottomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home_outlined, label: 'Home'),
      BottomNavItem(icon: Icons.favorite_outline, activeIcon: Icons.favorite_rounded, label: 'Favorites'),
      BottomNavItem(icon: Icons.shopping_cart_outlined, activeIcon: Icons.shopping_cart_rounded, label: 'Cart'),
      BottomNavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long_rounded, label: 'Orders'),
      BottomNavItem(icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: 'Profile'),
    ];
  }

  Future<void> _handleTap(int index) async {
    if (widget.useHapticFeedback) {
      await HapticFeedback.lightImpact();
    }
    widget.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final height = widget.height ?? kBottomNavigationBarHeight;
    final backgroundColor = isDarkMode ? theme.bottomNavigationBarTheme.backgroundColor : Colors.white;

    return Stack(
      children: [
        // Bottom Navigation Bar Background
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: widget.elevation,
                  spreadRadius: widget.elevation * 0.2,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ClipRRect(
              child: Container(
                height: height + MediaQuery.of(context).padding.bottom,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                decoration: BoxDecoration(color: isDarkMode ? theme.cardColor : Colors.white),
                child: Stack(
                  children: [
                    // Active indicator line at the top of the navigation bar
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        children:
                            _navItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              return Expanded(
                                child: AnimatedContainer(
                                  duration: widget.animationDuration,
                                  curve: widget.animationCurve,
                                  height:
                                      widget.showActiveIndicator && widget.selectedIndex == index
                                          ? widget.activeIndicatorHeight
                                          : 0,
                                  color: widget.activeColor,
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    // Navigation items
                    Expanded(
                      child: Container(
                        color: backgroundColor,
                        child: Row(
                          children: List.generate(_navItems.length, (index) {
                            final item = _navItems[index];
                            return _buildNavItem(
                              icon: item.icon,
                              activeIcon: item.activeIcon,
                              label: item.label,
                              index: index,
                              badgeCount: _getBadgeCount(index),
                              itemActiveColor: item.activeColor,
                              itemInactiveColor: item.inactiveColor,
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int? _getBadgeCount(int index) {
    if (widget.badgeCounts == null || widget.badgeCounts!.length <= index) {
      return null;
    }
    return widget.badgeCounts![index];
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    int? badgeCount,
    Color? itemActiveColor,
    Color? itemInactiveColor,
  }) {
    final isSelected = widget.selectedIndex == index;
    final activeColor = itemActiveColor ?? widget.activeColor;
    final inactiveColor = itemInactiveColor ?? widget.inactiveColor;
    final color = isSelected ? activeColor : inactiveColor;
    final theme = Theme.of(context);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(index),
          splashColor: activeColor.withOpacity(0.2),
          highlightColor: activeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 30, maxHeight: 72),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with badge
                SizedBox(
                  height: 28,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: widget.animationDuration,
                        curve: widget.animationCurve,
                        padding: const EdgeInsets.all(8),
                        decoration:
                            isSelected
                                ? BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [activeColor.withOpacity(0.15), activeColor.withOpacity(0.05)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                )
                                : null,
                        child: AnimatedSwitcher(
                          duration: widget.animationDuration,
                          switchInCurve: widget.animationCurve,
                          switchOutCurve: widget.animationCurve,
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child));
                          },
                          child: Icon(
                            activeIcon,
                            key: ValueKey(isSelected ? 'active_$index' : 'inactive_$index'),
                            size: 24,
                            color: color,
                          ),
                        ),
                      ),
                      // Badge
                      if (badgeCount != null && badgeCount > 0)
                        Positioned(right: 0, top: 0, child: _buildBadge(badgeCount, theme)),
                    ],
                  ),
                ),
                // Label
                if (widget.showLabels) ...[
                  const SizedBox(height: 2),
                  SizedBox(
                    height: 16,
                    child: AnimatedDefaultTextStyle(
                      duration: widget.animationDuration,
                      curve: widget.animationCurve,
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        height: 1.1,
                      ),
                      child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1, textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(int count, ThemeData theme) {
    return AnimatedSwitcher(
      duration: widget.animationDuration,
      child: Container(
        key: ValueKey(count),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 3, spreadRadius: 1)],
        ),
        constraints: const BoxConstraints(minWidth: 16, minHeight: 16, maxWidth: 20),
        child: Center(
          child: Text(
            count > 9 ? '9+' : '$count',
            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, height: 1.2),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
