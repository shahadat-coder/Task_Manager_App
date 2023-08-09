import 'package:flutter/material.dart';
import 'package:module_11_live_class/Api/models/Network_Response.dart';
import 'package:module_11_live_class/Api/models/TaskListModel.dart';
import 'package:module_11_live_class/Api/services/Network_Caller.dart';
import 'package:module_11_live_class/Api/utils/url.dart';
import 'package:module_11_live_class/UI/screens/Update_task_status_Screen.dart';
import 'package:module_11_live_class/UI/screens/auth/Update_Task_Bottonsheet.dart';
import 'package:module_11_live_class/Wigdets/TaskListStyle.dart';
import 'package:module_11_live_class/Wigdets/UserProfileBanner.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({Key? key}) : super(key: key);

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _getProgressTasksInProgress = false;

  TaskListModel _taskListModel = TaskListModel();

  Future<void> getInProgressTasks() async {
    _getProgressTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.progressTasks);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('In progress tasks get failed')));
      }
    }
    _getProgressTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
  Future<void>deleteTask(String taskId)async{
    final NetworkResponse  response = await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      _taskListModel.data!.removeWhere((element) => element.sId == taskId );
      if (mounted) {
        setState(() {});
      }
    } else{
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar
          (const SnackBar(content: Text("Delete doesn't work")));
      }
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getInProgressTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfileBanner(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: ()async{
                  getInProgressTasks();
                },
              child: _getProgressTasksInProgress
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.separated(
                itemCount: _taskListModel.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return TaskListTile(
                            data: _taskListModel.data![index],
                            onDeleteTap: () {deleteTask(_taskListModel.data![index].sId!);},
                            onEditTap: () {
                              showStatusUpdateBottomSheet(_taskListModel.data![index]);
                            },
                          );
                        },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 4,
                  );
                },
              ),
            ),
            ),
          ],
        ),
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
              getInProgressTasks();
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
          getInProgressTasks();
        });
      },
    );
  }
}