import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:typed_data';
import 'authService.dart';
import 'databaseHelper.dart';
import 'screen2.dart';
import 'signup.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signin() async {
    final response = await authService.signin(emailController.text, passwordController.text);

    if (response.statusCode == 200) {
      fetchUserProfile().then((value) {
        print("done");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Screen2(),));
      },);

    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signin failed')));
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    final url = Uri.parse('http://localhost:3000/profile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response data
        final profileData = json.decode(response.body);

        // Extract data from the response
        String username = profileData['fname'] ?? ''; // Changed to match backend response
        String title = profileData['title'] ?? 'None';
        Uint8List? profilePic;

        // If there's a profile picture, fetch and store it as a Uint8List
        String? profilePicPath = profileData['profilePic'];
        if (profilePicPath != null && profilePicPath.isNotEmpty) {
          // Ensure profilePicPath is a complete URL with a leading slash
          final profilePicUrl = Uri.parse('http://localhost:3000/$profilePicPath');

          // Check if the URL is valid (i.e., the full URL is properly formed)
          final profilePicResponse = await http.get(profilePicUrl);
          if (profilePicResponse.statusCode == 200) {
            profilePic = profilePicResponse.bodyBytes;
          }
        }

        // Save or update the data in the database
        final dbHelper = DatabaseHelper();
        await dbHelper.createUser(username);
        await dbHelper.updateTitle(title);
        if (profilePic != null) {
          await dbHelper.updateProfilePic(profilePic);
        }

        return profileData;
      } else {
        print('Failed to load profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching profile: $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height:20),
            Lottie.asset(
              'assets/astranaut1.json', // Replace with your animation path
              width:200,
              height:150,
              repeat: true,
            ),
            Container(
              width:MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                color: Color.fromRGBO(21,19,24,1), // Change opacity as needed
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255,145, 0, 255,), // Shadow color
                    offset: Offset(4, 4), // Offset to the bottom right
                    blurRadius: 2, // Blur radius
                    spreadRadius: 0.5, // Spread radius
                  ),
                ],
              ),
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sign In",style: TextStyle(color: Colors.white,fontSize: 35),),
                    Text("Step Into Your Space",style: TextStyle(color: Colors.white),),
                    SizedBox(height:20),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: emailController,
                        style: TextStyle(color:Colors.white),
                        cursorColor: Color.fromRGBO(145, 0, 255, 1),
                        decoration: InputDecoration(
                          hintText: "Email Id",
                          hintStyle: TextStyle(color: Colors.white,fontSize: 12),
                          contentPadding: EdgeInsets.fromLTRB(10, 0,10,0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(49,45,59,1), width: 2.0),
                            borderRadius: BorderRadius.zero,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:Color.fromRGBO(145, 0, 255, 1), width: 2.0),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:20),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: passwordController,
                        style: TextStyle(color:Colors.white),
                        decoration: InputDecoration(
                          hintText: "Password",
                          suffixText: "Show",
                          suffixStyle: TextStyle(color: Colors.white,fontSize: 12),
                          hintStyle: TextStyle(color: Colors.white,fontSize: 12),
                          contentPadding: EdgeInsets.fromLTRB(10, 0,10,0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(49,45,59,1), width: 2.0),
                            borderRadius: BorderRadius.zero,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:Color.fromRGBO(145, 0, 255, 1), width: 2.0),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:12),
                    InkWell(
                        onTap: (){

                        },

                        child: Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0,8,8,8),
                              child: Text("Forgot Password ?",style: TextStyle(color: Colors.white),),
                            )
                        )
                    ),
                    SizedBox(height:12),
                    GestureDetector(
                      onTap: (){
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(

                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Transform.scale(
                                      scale: 2, // Adjust the scale factor to increase the animation size
                                      child: SizedBox(
                                        width: 100, // Set a smaller width for the SizedBox
                                        height: 100, // Set a smaller height for the SizedBox
                                        child: Lottie.asset(
                                          'assets/loading_planet.json', // Replace with your animation path
                                          repeat: true,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Signing in...",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        Future.delayed(Duration(seconds: 3), () {
                          signin();
                        });

                      },
                      child: Container(
                        alignment: Alignment.center,
                        width:MediaQuery.of(context).size.width*0.9,
                        height:40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color.fromRGBO(145, 0, 255, 1),
                        ),
                        child:Text("Sign In",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    SizedBox(height:20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color:Colors.grey,
                            height:1,
                          ),
                        ),
                        Text("or",style: TextStyle(color: Colors.white),),
                        Expanded(
                          child: Container(
                            color:Colors.grey,
                            height:1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:20),
                    Container(
                      alignment: Alignment.center,
                      width:MediaQuery.of(context).size.width*0.9,
                      height:40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(47,45,58,1), // Starting color
                            Color.fromRGBO(38,36,49,1), // Ending color
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage("assets/google.png"),height: 25,width:25,),
                          SizedBox(width:5),
                          Text("Sign in with Google",style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              )
            ),

            //Expanded(child: Container(),),
            SizedBox(height:100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New to Galaxor?",style: TextStyle(color: Colors.white),),
                InkWell(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Signup(),));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Text("Join Here",style: TextStyle(color:Color.fromRGBO(145, 0, 255, 1),),)
                      ),
                    )
                ),
              ],
            ),
            SizedBox(height:20),
          ],
        ),
      )
    );
  }
}


