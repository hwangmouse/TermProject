import 'package:flutter/material.dart';
import 'SubjectAddScreen.dart';
import 'package:term_project/inapp_algorithm/SubjectData.dart';
import 'package:term_project/DataManager.dart';
import 'package:term_project/cons/colors.dart';


class CategoryManagementScreen extends StatefulWidget {
  @override
  _CategoryManagementScreenState createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  List<SubjectData> subjectCategories = [];
  //List<String> generalCategories = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final subjects = await DataManager.loadSubjects();
    setState(() {
      subjectCategories = subjects;
    });
  }

  void _addSubjectCategory() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SubjectAddScreen(
              subjectList: subjectCategories,
            ),
      ),
    ).then((newSubject) {
      if (newSubject != null && newSubject is SubjectData) {
        setState(() {
          // 중복 방지
          if (!subjectCategories.contains(newSubject)) {
            subjectCategories.add(newSubject);
          }
        });
      }
    });
  }

  // Pass the current subject data to the edit screen
  void _editSubjectCategory(int index) async {
    final updatedSubject = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SubjectAddScreen(
              subjectList: subjectCategories,
              existingSubject: subjectCategories[index],
            ),
      ),
    );
    // Update the list with the modified data and save it to the JSON file
    if (updatedSubject != null && updatedSubject is SubjectData) {
      setState(() {
        subjectCategories[index] = updatedSubject; // list update
      });
      await _saveToLocalFile(); // JSON file save
    }
  }

  void _deleteSubjectCategory(int index) async {
    // Display a confirmation dialog for deletion
    final confirm = await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Delete Subject'),
            content: Text('Are you sure you want to delete this subject?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete'),
              ),
            ],
          ),
    );
    // Delete the item if confirmed
    if (confirm == true) {
      setState(() {
        subjectCategories.removeAt(index); // remove from list
      });
      await _saveToLocalFile(); // JSON file save
    }
  }

  // Save to the local file
  Future<void> _saveToLocalFile() async {
    await DataManager.saveSubjects(subjectCategories); // use DataManager
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Management'),
        centerTitle: true,
        backgroundColor: PRIMARY_COLOR,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: subjectCategories.length,
          itemBuilder: (context, index) {
            final subject = subjectCategories[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 8.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: Icon(
                    Icons.book,
                    color: PRIMARY_COLOR,
                  ),
                ),
                title: Text(
                  subject.subjectName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "Credits: ${subject.creditHours}, Major: ${subject.isMajor
                      ? 'Yes'
                      : 'No'}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editSubjectCategory(index);
                    } else if (value == 'delete') {
                      _deleteSubjectCategory(index);
                    }
                  },
                  itemBuilder: (context) =>
                  [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  icon: Icon(Icons.more_vert),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSubjectCategory,
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.add),
      ),
    );
  }
}


/*
  void _addGeneralCategory() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Add General Category'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter General Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String name = controller.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    generalCategories.add(name);
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editGeneralCategory(int index) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        controller.text = generalCategories[index];
        return AlertDialog(
          title: Text('Edit General Category'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Edit Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String updatedName = controller.text.trim();
                if (updatedName.isNotEmpty) {
                  setState(() {
                    generalCategories[index] = updatedName;
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editSubjectCategory(int index) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        controller.text = subjectCategories[index].subjectName;
        return AlertDialog(
          title: Text('Edit Subject'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Edit Subject Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String updatedName = controller.text.trim();
                if (updatedName.isNotEmpty) {
                  setState(() {
                    subjectCategories[index].subjectName = updatedName;
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSubjectCategory(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Subject'),
        content: Text('Are you sure you want to delete this subject?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                subjectCategories.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteGeneralCategory(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                generalCategories.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
 */

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Management'),
      ),
      body: ListView(
        children: [
          // Subject Category Section
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Subjects'),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: _addSubjectCategory,
            ),
          ),
          ...subjectCategories.asMap().entries.map((entry) {
            int index = entry.key;
            SubjectData subject = entry.value;
            return ListTile(
              title: Text(subject.subjectName),
              subtitle: Text("Credit: ${subject.creditHours}, Major: ${subject.isMajor ? 'Yes' : 'No'}"),
              leading: Icon(Icons.book),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editSubjectCategory(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteSubjectCategory(index),
                  ),
                ],
              ),
            );
          }).toList(),
          Divider(),
          // General Category Section
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('General'),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: _addGeneralCategory,
            ),
          ),
          ...generalCategories.asMap().entries.map((entry) {
            int index = entry.key;
            String category = entry.value;
            return ListTile(
              title: Text(category),
              leading: Icon(Icons.category),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editGeneralCategory(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteGeneralCategory(index),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
 */