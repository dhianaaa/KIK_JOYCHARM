import 'package:flutter/material.dart';
import '../main.dart';
import 'dart:convert';
import '../data/tutorial_data.dart';

class TutorialView extends StatefulWidget {
  const TutorialView({super.key});

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  String selectedCategory = "All";
  String searchText = "";
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JoyCharmColors.primary,
      body: Column(
        children: [
          _header(context),
          _content(),
        ],
      ),
    );
  }

// ================= HEADER =================
  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [JoyCharmColors.primary, Color(0xFFFF7FC2)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'J',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Tutorial Craft 🎥",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ],
          ),
          const SizedBox(height: 14),

          // SEARCH
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                hintText: "Search tutorial...",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }

// ================= CONTENT =================
  Widget _content() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            _filter(),
            Expanded(
              child: selectedCategory == "All"
                  ? ListView(
                      children: tutorialData.keys
                          .map((title) => _horizontalSection(title))
                          .toList(),
                    )
                  : _verticalGrid(selectedCategory),
            ),
          ],
        ),
      ),
    );
  }

// ================= FILTER =================
  Widget _filter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _chip("All"),
            _chip("The Collection"),
            _chip("Keychain"),
            _chip("Bracelets"),
            _chip("Necklaces"),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    bool isActive = selectedCategory == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? JoyCharmColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: JoyCharmColors.primary),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : JoyCharmColors.primary,
          ),
        ),
      ),
    );
  }

// ================= HORIZONTAL SECTION =================
  Widget _horizontalSection(String title) {
    final data = tutorialData[title]!;

    // FILTER SEARCH
    final filtered = data
        .where((item) => item["title"]!.toLowerCase().contains(searchText))
        .toList();

    if (filtered.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: JoyCharmColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                return _card(
                  item["image"]!,
                  item["title"]!,
                  item["points"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// ================= VERTICAL GRID =================
  Widget _verticalGrid(String category) {
    final data = tutorialData[category]!;

    final filtered = data
        .where((item) => item["title"]!.toLowerCase().contains(searchText))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return _verticalCard(
          item["image"]!,
          item["title"]!,
          item["points"]!,
        );
      },
    );
  }

// ================= CARD =================
  Widget _card(String image, String title, String points) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Beginner",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "+$points",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.pink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _buildImage(image, 150,
              width: 200, borderRadius: BorderRadius.circular(16)),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalCard(String image, String title, String points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE BESAR
          _buildImage(image, 200,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18))),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LABEL + POINTS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Beginner Crafter",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "+$points Points",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.pink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // TITLE
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String image, double height,
      {double? width, BorderRadius? borderRadius}) {
    final isBase64 = image.startsWith('data:image');
    Widget imageWidget;
    if (isBase64) {
      final base64Str = image.split(',').last;
      final bytes = base64Decode(base64Str);
      imageWidget = Image.memory(
        bytes,
        height: height,
        width: width ?? double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(height),
      );
    } else {
      imageWidget = Image.network(
        image,
        height: height,
        width: width ?? double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(height),
      );
    }
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: imageWidget);
    }
    return imageWidget;
  }

  Widget _fallbackImage(double height) {
    return Container(
      height: height,
      color: const Color(0xFFFFEEF5),
      child: const Center(
        child: Text('🎨', style: TextStyle(fontSize: 40)),
      ),
    );
  }
}
