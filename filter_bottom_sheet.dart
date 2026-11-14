import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const FilterBottomSheet({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'AI', 'Mobile', 'IoT', 'Cybersecurity'];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter Kategori Seminar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...categories.map((category) => RadioListTile<String>(
                title: Text(category),
                value: category,
                groupValue: selectedCategory,
                onChanged: (value) {
                  if (value != null) {
                    onCategorySelected(value);
                    Navigator.pop(context);
                  }
                },
              )),
        ],
      ),
    );
  }
}