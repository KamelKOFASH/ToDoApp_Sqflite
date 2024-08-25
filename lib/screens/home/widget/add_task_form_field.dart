import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.controller,
    this.isDescription = false,
    required String hintText,
  });

  final TextEditingController controller;
  bool isDescription;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListTile(
        title: TextFormField(
          controller: controller,
          maxLines: !isDescription ? 4 : null,
          cursorHeight: !isDescription ? 30 : null,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            label: isDescription ? null : const Text('Content'),
            filled: true,
            fillColor: Colors.grey[200],
            border: isDescription ? InputBorder.none : null,
            hintText: !isDescription ? '' : 'Add Notes',
            prefixIcon: isDescription
                ? const Icon(
                    Icons.bookmark_border,
                    color: Colors.grey,
                  )
                : null,
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.grey,
                )),
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.black,
                )),
          ),
          onFieldSubmitted: (value) {},
          onChanged: (value) {},
        ),
      ),
    );
  }
}
