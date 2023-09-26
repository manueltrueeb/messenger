import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger1/helper/helper_function.dart';
import 'package:messenger1/pages/auth/login_page.dart';
/*import 'package:messenger1/pages/chat_home_page.dart';*/
import 'package:messenger1/pages/profile_page.dart';
import 'package:messenger1/pages/search_page.dart';
import 'package:messenger1/service/auth_service.dart';
import 'package:messenger1/service/database_service.dart';
import 'package:messenger1/widgets/group_tile.dart';
import 'package:messenger1/widgets/wigdets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value){
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val){
      setState(() {
        userName = val!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot){
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            nextScreen(context, const SearchPage());
          }, 
          icon: const Icon(
            Icons.search,
          )) 
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Groups", 
          style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle, 
              size: 150, 
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center, 
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            /*ListTile(
              onTap: (){
                nextScreen(context, const ChatHomePage());
              },
              contentPadding: 
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.chat),
              title: const Text(
                "Chats", 
                style: TextStyle(color: Colors.black),
              ),
            ),*/
            ListTile(
              onTap: (){},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: 
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups", 
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: (){
                nextScreenReplace(
                  context, 
                  ProfilePage(
                    userName: userName,
                    email: email,
                  )
                );
              },
              contentPadding: 
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person_sharp),
              title: const Text(
                "Profile", 
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel, 
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context)=> const LoginPage()),
                              (route) => false);
                          },
                          icon: const Icon(
                            Icons.done, 
                            color: Colors.green,
                          ),
                        )
                      ],
                    );
                });
              },
              contentPadding: 
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout", 
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialogue(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add, 
          color: Colors.white, 
          size: 30,
        ),
      ),
    );
  }

  popUpDialogue(BuildContext context){
    showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(
          builder: ((context, setState) {
          return AlertDialog(
            title: const Text(
              "Create Group", 
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true 
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                    )
                  : TextField(
                    onSubmitted: (value) {
                      if(groupName!="") {
                    setState(() {
                      _isLoading = true;
                    });
                    createRoom();
                  }
                    },
                    onChanged: (val){
                      setState(() {
                        groupName = val;
                      });
                    },
                    style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20)),
                        errorBorder : OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red),
                          borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20)),
                      )
                    ),
              ]
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor), 
                child: const Text("CANCEL"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if(groupName!="") {
                    setState(() {
                      _isLoading = true;
                    });
                    createRoom();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor), 
                child: const Text("CREATE"),
              )
            ],
          );
          }));
      });
  }

  createRoom() {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                      .createGroup(userName, 
                        FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete((){
                          _isLoading = false;
                        }
                    );
                    Navigator.of(context).pop();
                    showSnackbar(context, Colors.green, "Group sucessfully created");
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['groups'] != null){
            if(snapshot.data['groups'].length != 0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupID: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']
                  );
                },
              );
            }
            else{
              return noGroupWidget();
            }
          }
          else{
            return noGroupWidget();
          }
        }
        else{
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: Icon(
              Icons.add_circle, 
              color: Colors.grey [700], 
              size: 75,
            ),
            onTap: (){
              popUpDialogue(context);
            },
          ),
          const SizedBox(height: 20,),
          const Text(
            "There are currently no chats available. Klick on the button to start chatting.", 
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

}