import 'package:flutter/material.dart';
import 'package:module_11_live_class/Api/models/Network_Response.dart';
import 'package:module_11_live_class/Api/models/SummaryModel.dart';
import 'package:module_11_live_class/Api/models/TaskListModel.dart';
import 'package:module_11_live_class/Api/services/Network_Caller.dart';
import 'package:module_11_live_class/Api/utils/url.dart';
import 'package:module_11_live_class/UI/screens/Update_task_status_Screen.dart';
import 'package:module_11_live_class/UI/screens/addNewTaskScreen.dart';
import 'package:module_11_live_class/UI/screens/auth/Update_Task_Bottonsheet.dart';
import 'package:module_11_live_class/Wigdets/SummaryCard.dart';
import 'package:module_11_live_class/Wigdets/TaskListStyle.dart';
import 'package:module_11_live_class/Wigdets/UserProfileBanner.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getCountSummaryInprogress = false, _getNewTaskInprogress = false;
  SummaryCountModel _summaryCountModel = SummaryCountModel();
  TaskListModel _newTaskListModel = TaskListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getCountSummary();
      await getNewTask();
    });
  }

  Future<void> getCountSummary() async {
    _getCountSummaryInprogress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Summary data get failed!")));
      }
    }
    _getCountSummaryInprogress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getNewTask() async {
    _getNewTaskInprogress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response = await NetworkCaller()
        .getRequest(Urls.newTasks); // Check if this is the correct API URL
    if (response.isSuccess) {
      _newTaskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("New Task data failed!")));
      }
    }
    _getNewTaskInprogress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      _newTaskListModel.data!.removeWhere((element) => element.sId == taskId);
      if (mounted) {
        setState(() {});
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Delete doesn't work")));
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfileBanner(),
            _getCountSummaryInprogress
                ? const LinearProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _summaryCountModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 25,
                            width: 96,
                            child: SummaryCard(
                              number: _summaryCountModel.data![index].sum ?? 0,
                              title: _summaryCountModel.data![index].sId ?? 'New',
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 5,
                          );
                        },
                      ),
                    )),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getNewTask();
                },
                child: _getNewTaskInprogress
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemCount: _newTaskListModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListTile(
                            data: _newTaskListModel.data![index],
                            onEditTap: () {
                             // showEditBottomSheet(_newTaskListModel.data![index]);
                              showStatusUpdateBottomSheet(_newTaskListModel.data![index]);
                            },
                            onDeleteTap: () {
                              deleteTask(_newTaskListModel.data![index].sId!);
                            },
                          ); // Replace with your actual TaskListTile implementation
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 5,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddNewTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showEditBottomSheet(TaskData task) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return UpdateTaskSheet(
            task: task,
            onUpdate: () {
              getNewTask();
            },
          );
        }
        );
  }
  void showStatusUpdateBottomSheet(TaskData task){

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
         return UpdateTaskStatusScreen(task: task, onUpdate: (){
            getNewTask();
          });
        },
    );
  }
}
