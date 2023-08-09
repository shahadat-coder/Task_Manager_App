import 'package:flutter/material.dart';
import 'package:module_11_live_class/Api/models/Network_Response.dart';
import 'package:module_11_live_class/Api/models/TaskListModel.dart';
import 'package:module_11_live_class/Api/services/Network_Caller.dart';
import 'package:module_11_live_class/Api/utils/url.dart';


class UpdateTaskSheet extends StatefulWidget {
  final TaskData task;
  final VoidCallback onUpdate;

  const UpdateTaskSheet({super.key, required this.task, required this.onUpdate});
  @override
  State<UpdateTaskSheet> createState() => _UpdateTaskSheetState();
}

class _UpdateTaskSheetState extends State<UpdateTaskSheet> {
  late TextEditingController _titleTEController;

  late TextEditingController _descriptionTEController;

  bool _updateTaskInprogress = false;

  @override
  void initState(){
    _titleTEController = TextEditingController(text: widget.task.title);
    _descriptionTEController = TextEditingController(text: widget.task.description);
    super.initState();
  }

  Future<void> updateTask() async {
    _updateTaskInprogress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),

    };
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.createTask, requestBody);
    _updateTaskInprogress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      _titleTEController.clear();
      _descriptionTEController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("task Updated Successful")));
      }
      widget.onUpdate();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("task updated failed!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Update Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _titleTEController,
                decoration: const InputDecoration(
                  hintText: 'Subject',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _descriptionTEController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: _updateTaskInprogress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      child: const Text('Update'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}