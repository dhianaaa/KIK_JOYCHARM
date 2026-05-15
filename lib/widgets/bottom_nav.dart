
import 'package:flutter/material.dart';
import 'package:joycharm/main.dart';

class JCBottomNavBar extends StatefulWidget {
  final int activePage;

  const JCBottomNavBar(this.activePage, {super.key});

  @override
  State<JCBottomNavBar> createState() => _JCBottomNavBarState();
}

class _JCBottomNavBarState extends State<JCBottomNavBar> {
  void getLink(index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/catalog');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(
        icon: Icons.home_rounded,
        label: 'Home',
      ),
      _NavItem(
        icon: Icons.grid_view_rounded,
        label: 'Catalog',
      ),
      _NavItem(
        icon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) {
                final isActive = index == widget.activePage;

                return GestureDetector(
                  onTap: () => getLink(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: isActive ? 18 : 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? JoyCharmColors.primaryPastel
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          items[index].icon,
                          color: isActive
                              ? JoyCharmColors.primary
                              : JoyCharmColors.textLight,
                          size: 22,
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 6),
                          Text(
                            items[index].label,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: JoyCharmColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.label,
  });
}