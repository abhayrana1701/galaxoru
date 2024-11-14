import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'addPost.dart';
import 'package:http/http.dart' as http;

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
      {"title": "Business", "image": "business.jpg"},
      {"title": "Tech", "image": "tech.jpg"},
      {"title": "Lifestyle", "image": "lifestyle.jpg"},
      {"title": "Health", "image": "health.jpg"},
      {"title": "Sports", "image": "sports.jpg"},
      {"title": "Entertainment", "image": "entertainment.png"},
      {"title": "Travel", "image": "travel.jpg"},
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
                                          "assets/${category['image']!}",
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
    setState(() {
      expandTopics=false;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPosts();
  }

  List<dynamic> posts = []; // List to store fetched posts
  // Fetch posts from the server
  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/posts')); // Update with your API URL

      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body); // Assuming response is a JSON array of posts
        });
      } else {
        print("Failed to load posts.");
      }
    } catch (error) {
      print("Error fetching posts: $error");
    }
  }


  /// Helper function to format the date based on conditions.
  String formatPostTime(String postTimestamp) {
    DateTime postDate = DateTime.parse(postTimestamp);
    DateTime now = DateTime.now();

    Duration difference = now.difference(postDate);

    if (difference.inDays == 0) {
      // Same day, show "X hours ago" or "X minutes ago"
      if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } else if (now.year == postDate.year) {
      // Within the current year, show "7 Nov"
      return DateFormat('d MMM').format(postDate);
    } else {
      // Different year, show "7 Nov 2023"
      return DateFormat('d MMM yyyy').format(postDate);
    }
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

              // SizedBox(height:15),
              // Container(
              //   width:MediaQuery.of(context).size.width*0.7,
              //   height:150,
              //   decoration: BoxDecoration(
              //     color:Colors.red,
              //     borderRadius: BorderRadius.all(Radius.circular(20)),
              //   ),
              //   child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image(image: AssetImage("assets/node.png"),fit: BoxFit.cover,)),
              // ),

              SizedBox(height:20),

              ListView.builder(
                itemCount: posts.length,
                shrinkWrap: true,  // Ensures the ListView only takes as much space as it needs
                physics: NeverScrollableScrollPhysics(),  // Disable scrolling for the ListView as the parent SingleChildScrollView already handles scrolling
                  itemBuilder: (context, index) {
                    dynamic post=posts[index];
                    String postTime = formatPostTime(post['createdAt']);
                    return Column(
                      children: [
                        Container(
                          width:MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(color:Color.fromRGBO(145, 0, 255, 1),),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: CircleAvatar(
                                        radius: 19,
                                        backgroundColor: Colors.black,
                                        child: ClipOval(child: Image(image: AssetImage("assets/profileaa.jpg"))),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded( // Allows the Column to take available space
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes content to ends
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Abhay Rana",
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(width: 5),
                                                  CircleAvatar(
                                                    backgroundColor: Color.fromRGBO(145, 0, 255, 1),
                                                    radius: 2,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    postTime,
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              Icon(Icons.more_horiz, color: Colors.white), // Placed at the far right
                                            ],
                                          ),
                                          Text(
                                            "App Developer",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),


                                SizedBox(height:15),

                                ReadMoreText(
                                  //"Today i am making my Galaxor project. it is space themed. I like space very much. My dream is to discover aliens and their technology. I want to explore other planets. I want to build my space ships. Exploring uinverse and uncovering its mysteries is my dream. I want to search planets far far away.",
                                  post['caption'] ?? "",
                                  style: TextStyle(color: Colors.white),
                                  trimLines: 5,
                                  trimCollapsedText: "read more",
                                  trimExpandedText: 'read less',
                                  lessStyle: TextStyle(color: Color.fromRGBO(145, 0, 255, 1),),
                                  moreStyle: TextStyle(color: Color.fromRGBO(145, 0, 255, 1),),
                                ),
                                if(post['images'] != null && post['images'].isNotEmpty)
                                SizedBox(height:15),
                                post['images'] != null && post['images'].isNotEmpty
                                    ? CarouselSlider(
                                  items: post['images'].map<Widget>((imagePath){
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child:Image.network(
                                                'http://localhost:3000/$imagePath', // Update with your image URL
                                                //fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.5),
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                child: Text(
                                                  "${1}/${post['images'].length}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    height: 180.0,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enableInfiniteScroll: true,
                                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                                    viewportFraction: 0.8,
                                  ),
                                ):Container(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Like button
                                        IconButton(
                                          onPressed: () {
                                            // Add your like action here
                                          },
                                          icon: Icon(CupertinoIcons.heart),
                                          color: Colors.purpleAccent,
                                          iconSize: 20,
                                          splashRadius: 2,
                                          padding: EdgeInsets.zero, // Ensure no extra padding
                                        ),

                                        // Comment button
                                        IconButton(
                                          onPressed: () {
                                            // Add your comment action here
                                          },
                                          icon: Icon(CupertinoIcons.chat_bubble_text_fill),
                                          color: Colors.cyanAccent,
                                          iconSize: 20,
                                          splashRadius: 20,
                                        ),
                                      ],
                                    ),


                                    // Share button
                                    IconButton(
                                      onPressed: () {
                                        // Add your share action here
                                      },
                                      icon: Icon(CupertinoIcons.share),
                                      color: Colors.greenAccent,
                                      iconSize: 20,
                                      splashRadius: 20,
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:20)
                      ],
                    );
                  },
              ),
              Align(
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: 2,
                  child: Container(
                    height:60,
                    child: Lottie.asset(
                      'assets/loading_planet.json', // Replace with your animation path
                      repeat: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height:80),

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
