import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addPost.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  List backgroundColors = [
    Color.fromRGBO(255, 204, 204, 1), // Lighter Neon Red
    Color.fromRGBO(204, 255, 204, 1), // Lighter Neon Green
    Color.fromRGBO(229, 204, 255, 1), // Lighter Neon Purple
    Color.fromRGBO(204, 255, 255, 1), // Lighter Neon Cyan
  ];

  List iconColors = [
    Color.fromRGBO(255, 51, 51, 1), // Bright Neon Red
    Color.fromRGBO(0, 204, 0, 1), // Bright Neon Green
    Color.fromRGBO(153, 0, 255, 1), // Bright Neon Purple
    Color.fromRGBO(0, 204, 204, 1), // Bright Neon Cyan
  ];

  List optionNames=[
    "Latest",
    "Explore",
    "Favorites",
    "Topics"
  ];

  List optionIcons = [
    CupertinoIcons.time_solid,        // Filled version for "Latest"
    CupertinoIcons.compass_fill,      // Filled version for "Explore"
    CupertinoIcons.heart_fill,        // Filled version for "Favorites"
    CupertinoIcons.book_solid,        // Filled version for "Topics"
  ];


  bool expandTopics=false;
  void _showStatefulDialog(BuildContext context) {
    int selectedItem = 0;

    // Categories with real image URLs
    final List<Map<String, String>> categories = [
      {"title": "Business", "imageUrl": "https://images.unsplash.com/photo-1507679799987-c73779587ccf"},
      {"title": "Tech", "imageUrl": "https://images.unsplash.com/photo-1518770660439-4636190af475"},
      {"title": "Lifestyle", "imageUrl": "https://images.unsplash.com/photo-1541534401786-599c6409a3e3"},
      {"title": "Health", "imageUrl": "https://images.unsplash.com/photo-1505751172876-fa1923c5c528"},
      {"title": "Sports", "imageUrl": "https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf"},
      {"title": "Entertainment", "imageUrl": "https://images.unsplash.com/photo-1519659522779-db325d5b8b40"},
      {"title": "Travel", "imageUrl": "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: !expandTopics?MediaQuery.of(context).size.width * 0.85:MediaQuery.of(context).size.height* 0.85,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF9B4DFF), // Neon Purple
                          Color(0xFF6A0DAD), // Deep Purple
                          Color(0xFFAE0EFF), // Bright Neon Purple
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Select the Topics',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 80,
                            physics: BouncingScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedItem = index;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                final category = categories[index];
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          "assets/profile.jpg",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          category['title']!,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: categories.length,
                            ),
                          ),
                        ),
                        SizedBox(height:15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: (){
                              setState((){
                                expandTopics=!expandTopics;
                              });
                            },
                            child: Container(
                              width:30,height:30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white)
                              ),
                              child: Transform.rotate(
                                angle: !expandTopics?(45 * 3.1415927 / 180):(- 135 * 3.1415927 / 180) , // Rotates the icon by 45 degrees (pointing bottom-right)
                                child: Icon(
                                  Icons.arrow_forward, // You can replace this with any arrow icon
                                  color: Colors.white, // Customize the color as per your design
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search', // Hint text
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey), // Prefix icon
                  fillColor: Color.fromRGBO(31, 31, 31, 1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5), // Border radius
                    borderSide: BorderSide(color: Colors.transparent), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5), // Border radius for focused state
                    borderSide: BorderSide(color: Colors.transparent), // Border color when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5), // Border radius for enabled state
                    borderSide: BorderSide(color: Colors.transparent), // Border color when enabled
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure equal space between elements
                children: List.generate(backgroundColors.length, (index) {
                  return GestureDetector(
                    onTap: (){
                      if(index==3){
                        _showStatefulDialog(context);
                      }
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: backgroundColors[index],
                          child: Icon(
                            optionIcons[index],
                            color: iconColors[index],
                            size: 30,
                          ),
                        ),
                        Text(optionNames[index],style: TextStyle(color:Colors.white),)
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height:15),

              Text("For You",style: TextStyle(color: Colors.white,fontSize: 20),),

              SizedBox(height:15),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 270,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(28, 28, 30, 1), // Dark background
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: ClipOval(child: Image.asset("assets/profile1.jpg")),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "John",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Bold name
                                    ),
                                    Text(
                                      "2 hours ago",
                                      style: TextStyle(color: Colors.grey[400]), // Lighter color for timestamp
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 77, 77, 1), // Light Red
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Image(
                                  image: AssetImage("assets/web.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text("Enabling businesses to reach global audiences.",style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 1,),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space evenly for icons
                              children: [
                                Icon(CupertinoIcons.heart, color: Color.fromRGBO(255, 77, 77, 1)), // Light Red
                                Icon(CupertinoIcons.bubble_left, color: Color.fromRGBO(77, 153, 255, 1)), // Light Blue
                                Icon(CupertinoIcons.arrow_right_circle, color: Color.fromRGBO(77, 255, 77, 1)), // Light Green
                                Icon(CupertinoIcons.bookmark, color: Color.fromRGBO(255, 204, 77, 1)), // Light Yellow
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width:10),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 270,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(28, 28, 30, 1), // Dark background
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: ClipOval(child: Image.asset("assets/profile.jpg")),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Abhay",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Bold name
                                    ),
                                    Text(
                                      "3 hours ago",
                                      style: TextStyle(color: Colors.grey[400]), // Lighter color for timestamp
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 77, 77, 1), // Light Red
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Image(
                                  image: AssetImage("assets/ai.jpeg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text("AI enhances creativity, assisting artists and writers in bringing ideas to life.",style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 1,),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space evenly for icons
                              children: [
                                Icon(CupertinoIcons.heart, color: Color.fromRGBO(255, 77, 77, 1)), // Light Red
                                Icon(CupertinoIcons.bubble_left, color: Color.fromRGBO(77, 153, 255, 1)), // Light Blue
                                Icon(CupertinoIcons.arrow_right_circle, color: Color.fromRGBO(77, 255, 77, 1)), // Light Green
                                Icon(CupertinoIcons.bookmark, color: Color.fromRGBO(255, 204, 77, 1)), // Light Yellow
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height:15),

              Text("Spotlight Picks",style: TextStyle(color: Colors.white,fontSize: 20),),

              SizedBox(height:15),
              Container(
                width:MediaQuery.of(context).size.width*0.7,
                height:150,
                decoration: BoxDecoration(
                  color:Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image(image: AssetImage("assets/node.png"),fit: BoxFit.cover,)),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPost(),));
          },
          shape: CircleBorder(),
          backgroundColor: Color.fromRGBO(145, 0, 255, 1),
          child: Icon(CupertinoIcons.pencil,color: Colors.white,size: 30,),
      ),
    );
  }
}
