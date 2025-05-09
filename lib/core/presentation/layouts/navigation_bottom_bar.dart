import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NavigationBottomBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool showLabels;
  final int? badgeCounts;
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
    this.showLabels = true,
    this.badgeCounts = 0,
    this.useHapticFeedback = true,
    this.elevation = 6.0,
    this.height = 57,
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
      BottomNavItem(icon: Iconsax.home_copy, activeIcon: Iconsax.home, label: 'Home'),
      BottomNavItem(icon: Iconsax.note_21_copy, activeIcon: Iconsax.note_1, label: 'Orders'),
      BottomNavItem(icon: Iconsax.flash_1_copy, activeIcon: Iconsax.flash, label: 'Flash Deals'),
      BottomNavItem(icon: Iconsax.shopping_cart_copy, activeIcon: Iconsax.shopping_cart, label: 'Cart'),
      BottomNavItem(icon: Iconsax.user_copy, activeIcon: Iconsax.user, label: 'Profile'),
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Material(
      elevation: widget.elevation,
      color: backgroundColor,
      child: SizedBox(
        height: height + bottomPadding,
        child: Column(
          children: [
            Row(
              children:
                  _navItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: widget.animationDuration,
                        curve: widget.animationCurve,
                        height: widget.showActiveIndicator && widget.selectedIndex == index ? widget.activeIndicatorHeight : 0,
                        color: theme.primaryColor,
                      ),
                    );
                  }).toList(),
            ),
            // Navigation items
            Expanded(
              child: Row(
                children: List.generate(_navItems.length, (index) {
                  final item = _navItems[index];
                  return _buildNavItem(
                    icon: item.icon,
                    activeIcon: item.activeIcon,
                    label: item.label,
                    index: index,
                    badgeCount: item.label == 'Cart' ? widget.badgeCounts : null,
                    itemActiveColor: theme.primaryColor,
                    itemInactiveColor: Colors.grey,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    int? badgeCount,
    required Color itemActiveColor,
    required Color itemInactiveColor,
  }) {
    final isSelected = widget.selectedIndex == index;
    final theme = Theme.of(context);
    final color = isSelected ? itemActiveColor : itemInactiveColor;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(index),
          splashColor: itemActiveColor.withOpacity(0.2),
          highlightColor: itemActiveColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 30, maxHeight: 72),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with badge
                SizedBox(
                  height: 26,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: widget.animationDuration,
                        curve: widget.animationCurve,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                        child: AnimatedSwitcher(
                          duration: widget.animationDuration,
                          switchInCurve: widget.animationCurve,
                          switchOutCurve: widget.animationCurve,
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child));
                          },
                          child: Icon(
                            isSelected ? activeIcon : icon,
                            key: ValueKey(isSelected ? 'active_$index' : 'inactive_$index'),
                            size: 26,
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
                  const SizedBox(height: 3),
                  SizedBox(
                    height: 25,
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
