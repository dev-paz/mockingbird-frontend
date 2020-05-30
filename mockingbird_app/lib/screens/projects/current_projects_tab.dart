import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/empty_state.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'package:mockingbirdapp/screens/projects/project_card.dart';
import 'package:provider/provider.dart';
import 'create_project/create_project_screen.dart';
import 'edit_project/edit_project_wrapper.dart';

class CurrentProjectsTab extends StatefulWidget {
  @override
  _CurrentProjectsTabState createState() => _CurrentProjectsTabState();
}

class _CurrentProjectsTabState extends State<CurrentProjectsTab> {
  User currentUser;
  Project currentProject;
  bool loading = true;
  String error;


  _fetchUserProjects() async {
    setState(() {
      loading = true;
    });
    bool ok = await currentUser.getAllProjects();
    if(!ok){
      error = "Error loading projects";
    }
    setState(() {
      loading = false;
    });
  }

  _navigateEditProjectScreen(BuildContext context, String projectId, String projectName) async {
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => EditProjectWrapper(projectId: projectId, projectName: projectName)),
    );
    _fetchUserProjects();
  }

  Widget projectList(String projectStatus){
    num counter = 0;
    for(var i = 0; i < currentUser.projects.length; i++ ) {
      if(currentUser.projects[i].status == projectStatus){
        counter++;
      }
    }
    if (counter == 0) {
      return EmptyStateWidget(
        icon: Icons.format_paint,
        text: "No projects"
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: currentUser.projects.map((p){
          if (p.status == projectStatus){
            return ProjectCard(
              onCardPressed: () async {
                currentProject.id = p.id;
                _navigateEditProjectScreen(context, p.id, p.name);
              },
              project: p,
            );
          } else {
            return Container();
          }
        }
        ).toList()
      ),
    );
  }

  @override
  void initState() {
    currentProject = Provider.of<Project>(context, listen: false);
    currentUser = Provider.of<User>(context, listen: false);
    _fetchUserProjects();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            color: Colors.blue,
            child: new SafeArea(
              child: Column(
                children: <Widget>[
                  new Expanded(child: new Container()),
                  new TabBar(
                    indicatorColor: Colors.pink,
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("In Progress",
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 20
                         )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Completed",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            )
                        ),
                      ),                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: loading ? Loading(size: 50.0): TabBarView(
          children: <Widget>[
            projectList("started"),
            projectList("completed"),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CreateProjectScreen(),
                ),
              ).then((v) {
                _fetchUserProjects();
              });
            },
            label: Text('Create Project'),
            icon: Icon(Icons.format_paint),
            backgroundColor: Colors.pink,
          ),
        ),
      ),
    );
  }
}
