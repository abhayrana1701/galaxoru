import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'databaseHelper.dart';
import 'profile.dart';
import 'screen1.dart';
import 'screen3.dart';
import 'package:elastic_drawer/elastic_drawer.dart';
import 'dart:typed_data';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<double> widths=[-1,0,0,0,0,0];
  List icons=[CupertinoIcons.house,CupertinoIcons.question_circle,CupertinoIcons.flame,CupertinoIcons.square_list,CupertinoIcons.info,CupertinoIcons.arrow_right_square,];
  List options=["Home","Qurious","Elemental","My Posts","About","Log Out"];
  int oldIndex=0;

  late List<Map<String, dynamic>> _userData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Initialize the controller
    // Fetch user data from the database
    _fetchUserData();
  }

  // Function to fetch user data
  void _fetchUserData() async {
    // Fetch the data
    final userData = await DatabaseHelper().getUserInfo();

    // Update the UI once data is fetched
    setState(() {
      _userData = userData;
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  void _switchTab(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {

    // Assuming you have only one user and you're displaying the first one
    final user = _userData.first;

    // Getting the profile picture from the database and handling null case
    Uint8List? profilePicBytes = user['profilePic'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 100,
              automaticallyImplyLeading: false, // Hides the drawer button
              pinned: true,
              floating: true,
              snap: true,
              title: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(userData: _userData,),)).then(
                        (value) {
                          setState(() {
                            _fetchUserData();
                          });
                        },
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: profilePicBytes != null
                              ? MemoryImage(profilePicBytes)
                              : AssetImage('assets/profile.jpg') as ImageProvider,  // Placeholder image,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user['username'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              user['title']!=null?user['title']:"--",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottom: TabBar(
                controller: _tabController, // Use the controller here
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color.fromRGBO(145, 0, 255, 1),
                indicatorWeight: 3,
                dividerColor: Colors.black,
                dividerHeight: 0,
                tabs: [
                  Tab(text: 'Discover'),
                  Tab(text: 'Qurious'),
                  Tab(text: 'Elemental'),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none_rounded, color: Colors.white),
                ),
              ],
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController, // Use the controller here
          children: [
            Screen3(),
            Center(child: Text('Questions', style: TextStyle(color: Colors.white, fontSize: 24))),
            Screen1(),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor:Color.fromRGBO(21,19,24,1),
        child: Container(
          width:MediaQuery.of(context).size.width*0.6,
          height:MediaQuery.of(context).size.height,
          color: Color.fromRGBO(21,19,24,1),
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:50),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(child: Image(image: AssetImage("assets/profile.jpg"),)),
                ),
                SizedBox(height:5),
                Text("Abhay Rana",style: TextStyle(color:Colors.white),),
                Expanded(
                  child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              widths[oldIndex]=0;
                              widths[index]=MediaQuery.of(context).size.width;
                            });
                            oldIndex=index;
                            if(index<3){
                              _switchTab(index);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top:0,bottom: 8),
                            child: Container(
                              width:MediaQuery.of(context).size.width,
                              height:45,
                              decoration: BoxDecoration(
                                  color:Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        width:widths[index]==-1?MediaQuery.of(context).size.width:widths[index],
                                        height:45,
                                        decoration: BoxDecoration(
                                            color:Color.fromRGBO(145, 0, 255, 1),
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(width:10),
                                        Icon(icons[index],color: Colors.white,),
                                        SizedBox(width:10),
                                        Text(options[index],style: TextStyle(color:Colors.white),),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
