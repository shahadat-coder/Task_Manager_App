import 'package:flutter/material.dart';
import 'package:module_11_live_class/Api/models/TaskListModel.dart';

class TaskListTile extends StatelessWidget {
  final VoidCallback onDeleteTap, onEditTap;

  const TaskListTile({
    Key? key,
    required this.data,
    required this.onDeleteTap,
    required this.onEditTap,
  }) : super(key: key);

  final TaskData data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data.title ?? 'Unknown'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.description ?? 'Unknown'),
          Text(data.createdDate ?? ''),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Chip(
                label: Text(
                  data.status ?? 'New',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                elevation: 5,
                backgroundColor: Colors.lightBlueAccent,
              ),
              const Spacer(),
              IconButton(
                onPressed: onEditTap,
                icon: const Icon(
                  Icons.edit_calendar_outlined,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: onDeleteTap,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

