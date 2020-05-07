import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/empty_state.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'package:mockingbirdapp/screens/projects/create_project/create_project_screen.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/screens/projects/edit_project/edit_project_wrapper.dart';
import 'package:mockingbirdapp/screens/projects/project_card.dart';
import 'package:provider/provider.dart';

class ProjectsList extends StatefulWidget {
  @override
  _ProjectsListState createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  User currentUser;
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

  @override
  void initState() {
    currentUser = Provider.of<User>(context, listen: false);
    _fetchUserProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Project>(
      builder: (context, currentProject, child) {
        return error != null ? Center(
            child: EmptyStateWidget(
                icon: Icons.error,
                text: error
            )
        ) :
        Scaffold(
          backgroundColor: Colors.grey[200],
          body: loading ? Loading(size: 100.0) :
          currentUser.projects.length == 0 ? Center(
            child: EmptyStateWidget(
                icon: Icons.format_paint,
                text: "No projects"
            )
          ) :
          SingleChildScrollView(
            child: Column(
              children: currentUser.projects.map((p) => ProjectCard(
                  onCardPressed: () async {
                  currentProject.id = p.id;
                  _navigateEditProjectScreen(context, p.id, p.name);
                },
                project: p,
              )).toList(),
            ),
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
        );
      },
    );
  }
}
