import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key, required this.number, required this.title,
  });
  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$number',style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),),
              Text(title,style: const TextStyle(fontSize: 10),),
            ],
          ),
        ),
      ),
    );
  }
}