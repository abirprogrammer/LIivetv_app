import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFFF2A54), Color(0xFFFF6584)],
                  )
                : null,
            color: isSelected
                ? null
                : (isDark ? const Color(0xFF1E2230) : Colors.white),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08)),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF2A54).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label[0].toUpperCase() + label.substring(1),
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey[300] : Colors.black87),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
