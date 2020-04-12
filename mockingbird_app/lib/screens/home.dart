import 'package:flutter/material.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'package:mockingbirdapp/screens/edit_project_screen.dart';
import 'package:mockingbirdapp/services/projects.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/components/project_card.dart';
import 'package:provider/provider.dart';
import 'package:mockingbirdapp/models/ProjectStateProvider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool loading = true;
  List<Project> projects = [
  ];

   getBackendProjects() async {
     setState(() {
       loading = true;
     });
    Projects instance = Projects();
    await instance.getProjects();
     setState(() {
      loading = false;
      projects = instance.projects;
    });
   }

  @override
  void initState() {
    super.initState();
    getBackendProjects();
  }
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :Consumer<ProjectStateProvider>(
      builder: (context, projectStateProvider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text('Projects'),
            centerTitle: true,
            backgroundColor: Colors.redAccent,
          ),
          body: Column(
            children: projects.map((p) => ProjectCard(
              onCardPressed: () async {
                projectStateProvider.currentProjectID = p.id;
                await projectStateProvider.setProjectFilePath();
                print("testing thingy");
                print(projectStateProvider.filePath);
                print(projectStateProvider.currentProjectID);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProject(),
                  ),
                );
              },
              title: p.name,
              songName: p.song,
            )).toList(),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                // Add your onPressed code here!
              },
              label: Text('Create Project'),
              icon: Icon(Icons.format_paint),
              backgroundColor: Colors.redAccent,
            ),
          ),
        );
      },
    );
  }
}

typedef NavigationCallback = void Function();
