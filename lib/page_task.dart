import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harmony/Task.dart';
import 'package:harmony/const/colors.dart';
import 'loading_screen.dart';
import 'package:tflite_text_classification/tflite_text_classification.dart';
class TaskPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  int index = 1;
  List<List<Task>> priority = [[],[],[],[],[],[],[],[],[]];
  late final openAI;
  String initprompt = """ 1. Intense manual work, high intensity sport ac- tivities or sport competition: tree cutting. carrying heavy loads, jogging and running (>9 km/h), racquetball, badminton, swim- ming, tennis, cross country skiing (>8 km/ h), hiking and mountain climbing, etc.
2. Leisure and sport activities of higher intensity (not competitive): canoeing (5 to 8 km/h). bicycling (>15 km/h), dancing, skiing, bad- minton, gymnastic, swimming, tennis, horse riding, walking, (>6 km/h), etc.

3. Manual work at moderate pace: mining, car- pentry, house building, lumbering and wood cutting, snow shoveling, loading and unloading goods, etc.

4. Leisure activities and sports in a recreational environment: baseball, golf, volleyball, canoeing or rowing, archery, bowling, cycling (<10 km/h), table tennis, etc.

5. Light manual work: floor sweeping, window washing, driving a truck, painting, waiting on tables, nursing chores, several house chores, electrician, barman, walking at 4 to 6 km/h.

6. Slow walk (<4 km/h), driving, to dress, to shower, etc.

7. Light activity standing: washing, shaving. combing, cooking, etc.
8. Sitting: eating, listening, writing, etc.
9. Sleeping, Resting in bed.

Categorise the given task based on the categorise given above. 
Response should be in the form  "Category: *number* "

The task is
""";
  String new_task = "";
  @override
  void initState() {
    openAI = OpenAI.instance.build(token: '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',baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),enableLog: true);
    print(priority.length);
    super.initState();
  }
  void example(String prompt,String task) async {
    ///request Enter the prompt as you wish. Example include Hello!
    final request = ChatCompleteText(
        messages: [Messages(role: Role.user,content: prompt)]
        ,model: GptTurboChatModel());
        setState(() {
          isLoading = true;
        });
    ///call api to onChatCompletion
    final it = await openAI.onChatCompletion(request: request);
    String response = it ?.choices.last.message?.content;
    print(response);
    priority[int.parse(response[response.length-1]) - 1].add(new Task(task, false));
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading? Loading(): Scaffold(
      body: ListView(
        children: <Widget>[
          //_getToolbar(context),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Task',
                            style: new TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Lists',
                            style: new TextStyle(
                                fontSize: 28.0, color: Colors.grey[700],fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: new Column(
                  children: <Widget>[
                    new Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.all(Radius.circular(7.0))),
                      child: new IconButton(
                        icon: new Icon(Icons.add),
                        onPressed: () {
                          showDialog(context: context, builder: (context){
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)
                              ),
                              backgroundColor: sColor,
                              elevation: 20,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'New Task',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 20
                                              ),
                                            ),
                                            onChanged: (val)
                                            {
                                              new_task = val;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            primary: pColor
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            example(initprompt + new_task,new_task);
                                          });
                                          Navigator.of(context, rootNavigator: true).pop('dialog');
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        }, child: Text('Add',style: TextStyle(color: Colors.white)),
                                    )
                                    )],
                                ),
                              ),
                            );
                          });
                        },
                        iconSize: 30.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('Add Task',
                          style: TextStyle(color: Colors.black45)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Container(
              height: 360.0,
              padding: EdgeInsets.only(bottom: 25.0),
              child: getExpenseItemsStatic(),
              ),
            ),
        ],
      ),
    );
  }

  Widget getExpenseItemsStatic() {

    return ListView.builder(itemCount: priority.length, itemBuilder: (BuildContext context, int index) {
      return buildListCard(priority[index], index+1);
    }, physics: const BouncingScrollPhysics(), padding: EdgeInsets.only(left: 40.0, right: 40.0),
      scrollDirection: Axis.horizontal);
  }

  Widget buildListCard(List <Task> plist, int i) {
    // Extract data from the map
    String listName = "Priority $i";
    String listColor = "0xFF805f9b";
    List<Task> tasks = plist;

    return GestureDetector(
      onTap: () {
        // Handle list tap
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        color: Color(int.parse(listColor)),
        child: Container(
          width: 250.0,
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                  child: Container(
                    child: Text(
                      listName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 50.0),
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 15.0, right: 5.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 220.0,
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (BuildContext ctxt, int i) {
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  tasks[i].isdone = !tasks[i].isdone;
                                });
                              },
                              child: ListTile(
                                leading: Icon(
                                    tasks[i].isdone
                                        ? FontAwesomeIcons.checkCircle
                                        : FontAwesomeIcons.circle,
                                    color: tasks[i].isdone
                                        ? Colors.white70
                                        : Colors.white,
                                    size: 20.0,
                                  ),

                                  title: tasks[i].isdone? Text(
                                    tasks[i].name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      decoration: TextDecoration.lineThrough
                                    ),

                                  ):Text(
                                    tasks[i].name,
                                    style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        tasks.removeAt(i);
                                      });
                                    },
                                      child: Icon(Icons.delete,size: 20,color: Colors.white70,))
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  applymodel (String task) async{
    var result = await TfliteTextClassification().classifyText(
        params: TextClassifierParams(
            text: task,
            modelType: ModelType.wordVec,
            modelPath: "assets/model.tflite",
            delegate: 0));
    setState(() {
      priority[int.parse(result.toString())].add(new Task(task,false));
    });

  }
  // void _addTaskPressed() {
  //   // Handle add task button press
  //   Navigator.of(context).push(
  //     new PageRouteBuilder(
  //       pageBuilder: (_, __, ___) => new NewTaskPage(),
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) =>
  //           new ScaleTransition(
  //             scale: new Tween<double>(
  //               begin: 1.5,
  //               end: 1.0,
  //             ).animate(
  //               CurvedAnimation(
  //                 parent: animation,
  //                 curve: Interval(
  //                   0.50,
  //                   1.00,
  //                   curve: Curves.linear,
  //                 ),
  //               ),
  //             ),
  //             child: ScaleTransition(
  //               scale: Tween<double>(
  //                 begin: 0.0,
  //                 end: 1.0,
  //               ).animate(
  //                 CurvedAnimation(
  //                   parent: animation,
  //                   curve: Interval(
  //                     0.00,
  //                     0.50,
  //                     curve: Curves.linear,
  //                   ),
  //                 ),
  //               ),
  //               child: child,
  //             ),
  //           ),
  //     ),
  //   );
  // }


}
