import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';  // This is the correct import for Uint8List
import 'package:http_parser/http_parser.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

import 'databaseHelper.dart';

class Profile extends StatefulWidget {
  final List<Map<String, dynamic>> userData;
  const Profile({super.key,required this.userData});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>with SingleTickerProviderStateMixin  {

  double appBarHeight=200;

  List<String> celestialCodes = [
    "App Development",
    "Business",
    "Doctor",
    "Dietician",
    "Engineer",
    "Teacher",
    "Designer",
    "Lawyer",
    "Scientist",
    "Marketing",
    "Accounting",
    "Finance",
    "Project Manager",
    "Software Engineer",
    "Graphic Designer",
    "UX/UI Designer",
    "Data Scientist",
    "Psychologist",
    "Nurse",
    "Consultant",
    "Chef",
    "Photographer",
    "Artist",
    "Musician",
    "Writer",
    "Journalist",
    "Architect",
    "Web Developer",
    "Cybersecurity Expert",
    "HR Manager",
    "Real Estate",
    "Researcher",
    "Retail",
    "Construction",
    "Customer Service",
    "Translator",
    "Nutritional Expert",
    "Pharmacist",
    "Physiotherapist",
    "Social Worker",
    "Carpenter",
    "Electrician",
    "Plumber",
    "Veterinarian",
    "Pilot",
    "Mechanic",
    "Hairdresser",
    "Tailor",
    "Librarian",
    "Event Planner",
    "Interior Designer",
    "Fitness Trainer",
    "Personal Assistant",
    "Life Coach",
    "Public Relations",
    "Legal Advisor",
    "Real Estate Agent",
    "Copywriter",
    "SEO Specialist",
    "Data Analyst",
    "Music Producer",
    "Film Director",
    "Video Editor",
    "Photographer",
    "Travel Blogger",
    "E-commerce Specialist",
    "Entrepreneur",
    "Startup Advisor",
    "Mobile App Developer",
    "Cloud Engineer",
    "Network Engineer",
    "Database Administrator",
    "Blockchain Developer",
    "Game Developer",
    "AR/VR Specialist",
    "UX Researcher",
    "Sales Manager",
    "Customer Support",
    "Marketing Strategist",
    "Brand Consultant",
    "Event Coordinator",
    "Fashion Stylist",
    "Wedding Planner",
    "Influencer",
    "Public Speaker",
    "Motivational Speaker",
    "Technical Support",
    "Virtual Assistant",
    "Content Writer",
    "App Tester",
    "Project Coordinator",
    "Security Analyst",
    "Operations Manager",
    "Product Manager",
    "Financial Advisor",
    "Content Manager",
    "Influencer Marketing",
    "Blogger",
    "Graphic Artist",
    "Copy Editor",
    "Research Scientist",
    "Game Designer",
    "Web Designer",
    "Data Entry",
    "Social Media Manager",
    "Technical Writer",
    "Online Tutor",
    "Voiceover Artist"
  ];


  late TabController _tabController;

  late final user;
  Uint8List? profilePicBytes;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Initialize the controller
    // Assuming you have only one user and you're displaying the first one
    user = widget.userData.first;
    title=user["title"]??"None";
    // Getting the profile picture from the database and handling null case
    profilePicBytes = user['profilePic'];
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  bool isCelestialCodeExpanded=false;
  double height=140;

  void showUpdatingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:Colors.white
              ),
              width:MediaQuery.of(context).size.width*0.2,
              height:MediaQuery.of(context).size.width*0.2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: Color.fromRGBO(145, 0, 255, 1),
                  size: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double setProfilewidth=0;
  IconData setProfileIcon=CupertinoIcons.pencil;

  TextEditingController titleController=TextEditingController();
  final String baseUrl = "http://localhost:3000"; // Replace with your server URL
  final FlutterSecureStorage storage = FlutterSecureStorage();

  String title="None";
  // Method to update the title
  Future<void> updateTitle(String newTitle) async {
    final token = await storage.read(key: 'jwt_token');
    var response;
    if (token == null) {
      response=http.Response('Unauthorized', 401);
    }

      response = await http.put(
      Uri.parse('$baseUrl/update-title'), // Endpoint to update title
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Attach JWT token for authentication
      },
      body: jsonEncode({'title': newTitle}),
    );
    if (response.statusCode == 200) {
      titleController.text="";

    // Create an instance of DatabaseHelper
    final dbHelper = DatabaseHelper();
    // Call the updateTitle function, passing the userId and new title
    await dbHelper.updateTitle(newTitle);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title updated successfully!')),
      );
      setState(() {
        title=newTitle;
      });
    } else {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(responseData['message'] ?? 'Failed to update title')),
      );
    }
    Navigator.of(context).pop();
  }

  // Combined function to pick and upload profile picture
  Future<void> pickAndUploadProfilePic(BuildContext context,ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source,imageQuality: 50);

      if (pickedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected')),
        );
        return;
      }

      showUpdatingDialog(context);
      Future.delayed(Duration(seconds: 3), () {

      });

      final File profilePic = File(pickedFile.path);
      final token = await storage.read(key: 'jwt_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unauthorized')),
        );
        return;
      }

      final request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/update-profile-pic'))
        ..headers['Authorization'] = 'Bearer $token';

      final mimeType = lookupMimeType(profilePic.path);
      request.files.add(await http.MultipartFile.fromPath(
        'profilePic',
        profilePic.path,
        contentType: mimeType != null ? MediaType.parse(mimeType) : MediaType('image', 'jpeg'),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Read image as bytes
        Uint8List imageBytes = await File(pickedFile.path).readAsBytes();
        // Create an instance of DatabaseHelper
        final dbHelper = DatabaseHelper();
        // Update profile picture in the database
        await dbHelper.updateProfilePic(imageBytes);
        setState(() {
          profilePicBytes=imageBytes;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully!')),
        );
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Failed to update profile picture')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    Navigator.of(context).pop();
  }

  FocusNode titleFocusNode = FocusNode();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
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
              title: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              setProfilewidth = setProfilewidth == 0.0 ? 60.0 : 0.0; // Toggle the width between 0 and 40
                              setProfileIcon = setProfileIcon == CupertinoIcons.pencil ? CupertinoIcons.clear : CupertinoIcons.pencil;
                            });
                          },
                          child: Icon(
                            setProfileIcon,
                            color: Colors.white,
                          ),
                        ),
                        AnimatedContainer(
                          width: setProfilewidth,
                          height: 25,
                          duration: Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        setProfilewidth = setProfilewidth == 0.0 ? 60.0 : 0.0; // Toggle the width between 0 and 40
                                        setProfileIcon = setProfileIcon == CupertinoIcons.pencil ? CupertinoIcons.clear : CupertinoIcons.pencil;
                                      });
                                      pickAndUploadProfilePic(context, ImageSource.camera);
                                    },
                                    child: Icon(FontAwesomeIcons.camera, size: 15, color: Color.fromRGBO(253, 46, 116, 1)),
                                  ),
                                  SizedBox(width: 20),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          setProfilewidth = setProfilewidth == 0.0 ? 60.0 : 0.0; // Toggle the width between 0 and 40
                                          setProfileIcon = setProfileIcon == CupertinoIcons.pencil ? CupertinoIcons.clear : CupertinoIcons.pencil;
                                        });
                                        pickAndUploadProfilePic(context, ImageSource.gallery);
                                      },
                                      child: Icon(FontAwesomeIcons.image, size: 15, color: Color.fromRGBO(127, 102, 255, 1))
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              background: profilePicBytes != null
                  ? Image.memory(
                profilePicBytes!, // Using MemoryImage to load profile image if available
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/profileaa.jpg', // Default image if profilePicBytes is null
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
                  (context, index) =>Column(
                    children: [
                      SizedBox(height:15),
                      AnimatedContainer(
                        height:height,
                        duration: Duration(milliseconds: 700),
                        width: MediaQuery.of(context).size.width,
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

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['username'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 4), // Add space between the texts
                              Text(
                                "Name",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Divider(
                                color: Colors.white54,
                                thickness: 0.5,
                              ),
                              GestureDetector(
                                onTap:(){
                                  setState(() {
                                    isCelestialCodeExpanded?height=140:height=400;
                                    isCelestialCodeExpanded=!isCelestialCodeExpanded;
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Icon(
                                          !isCelestialCodeExpanded?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4), // Add space between the rows
                                    Text(
                                      "Celestial Code",
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 14,
                                      ),
                                    ),
                                   AnimatedContainer(
                                     duration: Duration(milliseconds: 700),
                                     height: isCelestialCodeExpanded ? height - 140 : 0.0,
                                     //color:Colors.red,
                                     child:SingleChildScrollView(
                                       scrollDirection: Axis.vertical,
                                       child: Column(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           SizedBox(height:10),
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               SizedBox(
                                                 height:40,
                                                 width:MediaQuery.of(context).size.width*0.75,
                                                 child: TextField(
                                                   focusNode: titleFocusNode,
                                                   style: TextStyle(color: Colors.white),
                                                   controller: titleController,
                                                   cursorColor: Colors.white,
                                                   decoration: InputDecoration(
                                                     hintText: "Custom Code",
                                                     hintStyle: TextStyle(color:Colors.white,fontSize: 12),
                                                     filled: false,  // Transparent background
                                                     border: OutlineInputBorder(
                                                       borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                                       borderSide: BorderSide(
                                                         color: Colors.white, // White border color
                                                         width: 2.0, // Border width
                                                       ),
                                                     ),
                                                     enabledBorder: OutlineInputBorder(
                                                       borderRadius: BorderRadius.circular(10.0),
                                                       borderSide: BorderSide(
                                                         color: Colors.white, // White border color
                                                         width: 2.0,
                                                       ),
                                                     ),
                                                     focusedBorder: OutlineInputBorder(
                                                       borderRadius: BorderRadius.circular(10.0),
                                                       borderSide: BorderSide(
                                                         color: Colors.white, // White border color when focused
                                                         width: 2.0,
                                                       ),
                                                     ),
                                                       contentPadding: EdgeInsets.only(left:5,right:5),
                                                   ),
                                                 ),
                                               ),
                                               GestureDetector(
                                                 onTap: (){
                                                   titleFocusNode.unfocus(); // Unfocus the specific text field
                                                   setState(() {
                                                     isCelestialCodeExpanded?height=140:height=400;
                                                     isCelestialCodeExpanded=!isCelestialCodeExpanded;
                                                   });
                                                   showUpdatingDialog(context);
                                                   Future.delayed(Duration(seconds: 3), () {
                                                     updateTitle(titleController.text.toString());
                                                   });
                                                 },
                                                 child: Container(
                                                   alignment: Alignment.center,
                                                   height:40,
                                                   width:MediaQuery.of(context).size.width*0.15,
                                                   decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.all(Radius.circular(10)),
                                                       color: Colors.white
                                                   ),
                                                   child:Text("Set",style: TextStyle(color:Color.fromRGBO(145, 0, 255, 1)),),
                                                 ),
                                               )
                                             ],
                                           ),
                                           ListView.builder(
                                               physics: NeverScrollableScrollPhysics(),
                                               shrinkWrap: true,
                                               itemCount:celestialCodes.length,
                                               itemBuilder: (context, index) {
                                                 return InkWell(
                                                   onTap: (){
                                                     setState(() {
                                                       isCelestialCodeExpanded?height=140:height=400;
                                                       isCelestialCodeExpanded=!isCelestialCodeExpanded;
                                                     });
                                                     showUpdatingDialog(context);
                                                     Future.delayed(Duration(seconds: 3), () {
                                                       updateTitle(celestialCodes[index]);
                                                     });
                                                   },
                                                     child: Padding(
                                                       padding: const EdgeInsets.only(top:5,bottom: 5),
                                                       child: Text(celestialCodes[index],style: TextStyle(color: Colors.white),),
                                                     )
                                                 );
                                               },
                                           ),

                                         ],
                                       ),
                                     )
                                   ),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                      TabBar(
                        controller: _tabController, // Use the controller here
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Color.fromRGBO(145, 0, 255, 1),
                        indicatorWeight: 3,
                        dividerColor: Colors.black,
                        dividerHeight: 0,
                        tabs: [
                          Tab(text: 'My Posts'),
                          Tab(text: 'My Questions'),
                        ],
                      ),
                      // PPadding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Container(
                      //         width: MediaQuery.of(context).size.width * 0.25,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.all(Radius.circular(15)),
                      //           border: Border.all(
                      //             color: Colors.transparent, // Transparent border for gradient overlay
                      //           ),
                      //           gradient: LinearGradient(
                      //             colors: [
                      //               Color(0xFF8A2BE2), // Neon Purple
                      //               Color(0xFFDA70D6), // Light Purple
                      //             ],
                      //             begin: Alignment.topLeft,
                      //             end: Alignment.bottomRight,
                      //           ),
                      //         ),
                      //         child: Container(
                      //           margin: const EdgeInsets.all(1.5),
                      //           decoration: BoxDecoration(
                      //             color: Colors.black,
                      //             borderRadius: BorderRadius.all(Radius.circular(13.5)),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(12),
                      //             child: Column(
                      //               children: [
                      //                 Text(
                      //                   "5",
                      //                   style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 18,
                      //                   ),
                      //                 ),
                      //                 Text(
                      //                   "Posts",
                      //                   style: TextStyle(
                      //                     color: Colors.white70,
                      //                     fontSize: 12,
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         width: MediaQuery.of(context).size.width * 0.25,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.all(Radius.circular(15)),
                      //           border: Border.all(color: Colors.transparent),
                      //           gradient: LinearGradient(
                      //             colors: [
                      //               Color(0xFF8A2BE2),
                      //               Color(0xFFDA70D6),
                      //             ],
                      //             begin: Alignment.topLeft,
                      //             end: Alignment.bottomRight,
                      //           ),
                      //         ),
                      //         child: Container(
                      //           margin: const EdgeInsets.all(1.5),
                      //           decoration: BoxDecoration(
                      //             color: Colors.black,
                      //             borderRadius: BorderRadius.all(Radius.circular(13.5)),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(12),
                      //             child: Column(
                      //               children: [
                      //                 Text(
                      //                   "10",
                      //                   style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 18,
                      //                   ),
                      //                 ),
                      //                 Text(
                      //                   "Followers",
                      //                   style: TextStyle(
                      //                     color: Colors.white70,
                      //                     fontSize: 12,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         width: MediaQuery.of(context).size.width * 0.25,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.all(Radius.circular(15)),
                      //           border: Border.all(color: Colors.transparent),
                      //           gradient: LinearGradient(
                      //             colors: [
                      //               Color(0xFF8A2BE2),
                      //               Color(0xFFDA70D6),
                      //             ],
                      //             begin: Alignment.topLeft,
                      //             end: Alignment.bottomRight,
                      //           ),
                      //         ),
                      //         child: Container(
                      //           margin: const EdgeInsets.all(1.5),
                      //           decoration: BoxDecoration(
                      //             color: Colors.black,
                      //             borderRadius: BorderRadius.all(Radius.circular(13.5)),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(12),
                      //             child: Column(
                      //               children: [
                      //                 Text(
                      //                   "2",
                      //                   style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 18,
                      //                   ),
                      //                 ),
                      //                 Text(
                      //                   "Following",
                      //                   style: TextStyle(
                      //                     color: Colors.white70,
                      //                     fontSize: 12,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height:800)
                    ],
                  ),
              childCount: 1, // Number of items in the list
            ),
          ),
        ],
      ),
    );
  }
}
