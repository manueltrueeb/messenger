import 'package:flutter/material.dart';
import 'package:messenger1/pages/auth/login_page.dart';
/*import 'package:messenger1/pages/chat_home_page.dart';*/ //this import field is only needed for the expansion
import 'package:messenger1/pages/home_page.dart';
import 'package:messenger1/service/auth_service.dart';
import 'package:messenger1/widgets/wigdets.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.email, required this.userName}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "Profile", 
          style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27
          ),
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
              widget.userName,
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
            //here above is the code for a possible extension to the application
            ListTile(
              onTap: (){
                nextScreen(context, const HomePage());
              },
              contentPadding: 
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups", 
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: (){},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(fontSize: 17),),
                Text(widget.userName, style: const TextStyle(fontSize: 17),)
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("E-Mail", style: TextStyle(fontSize: 17),),
                Text(widget.email, style: const TextStyle(fontSize: 17),)
              ],
            )
          ],
        ),
      ),
    );
  }
}