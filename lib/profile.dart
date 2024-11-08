import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  double appBarHeight=200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: appBarHeight, // Initial height of the AppBar
            floating: false,
            pinned: true, // Keeps the app bar visible when scrolling down
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                children: [
                  SizedBox(width:10),
                  Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              background: Image.asset(
                'assets/profileaa.jpg', // Background image for the AppBar
                fit: BoxFit.cover,
              ),
            ),
            stretch: true, // Enables the stretching effect
            stretchTriggerOffset: 100.0, // Controls how much to pull down to stretch
            onStretchTrigger: () async {
              // Optional: Perform an action when fully stretched
              print("AppBar stretched");
            },
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                title: Text('Item #$index'),
              ),
              childCount: 50, // Number of items in the list
            ),
          ),
        ],
      ),
    );
  }
}
