import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  TextEditingController postController=TextEditingController();
  bool isTextFieldGifVisisble=true;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles;

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _imageFiles = pickedFiles;
        });
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }


  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35, // Half of the screen height
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.purple.withOpacity(0.7), // Shadow to give a glow effect
            //     blurRadius: 15,
            //     spreadRadius: 2,
            //     offset: Offset(0, 5),
            //   ),
            // ],
            border: Border(
              top: BorderSide(color:Color.fromRGBO(145, 0, 255, 1))
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Who can reply?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 20),
              _buildOption(context, 'Everyone', CupertinoIcons.person_2, () {
                print('Everyone selected');
                Navigator.pop(context);
              }),
              _buildOption(context, 'Accounts you follow', CupertinoIcons.person_2_fill, () {
                print('Accounts you follow selected');
                Navigator.pop(context);
              }),
              _buildOption(context, 'Nobody', CupertinoIcons.clear_circled_solid, () {
                print('Nobody selected');
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(BuildContext context, String text, IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          //border: Border.all(color: Color.fromRGBO(145, 0, 255, 1)), // Border color
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color:Colors.white
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text("Share", style: TextStyle(color:Colors.white),),
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: ClipOval(child: Image(image: AssetImage("assets/profile.jpg"),)),
                ),
                SizedBox(width:10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Abhay Rana",style: TextStyle(color: Colors.white),),
                    GestureDetector(
                      onTap: (){
                        _showBottomSheet(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.public_rounded,color: Colors.white,),
                          Text("Public",style: TextStyle(color:Colors.white),)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color:Color.fromRGBO(145, 0, 255, 1),),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        TextField(
                          maxLines: 6,
                          controller:postController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "In a universe full of possibilities, what’s your unique story? Share your stellar insights!",
                            hintStyle: TextStyle(color:Colors.white,fontSize: 12),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged:(value){
                            if(postController.text.toString()==""){
                              setState((){
                                isTextFieldGifVisisble=true;
                              });
                            }else{
                              setState((){
                                isTextFieldGifVisisble=false;
                              });
                            }
                          },
                        ),
                        Visibility(
                          visible:isTextFieldGifVisisble,
                          child: Positioned(
                            bottom:0,
                            left: 0,
                            child: Lottie.asset(
                              'assets/astranaut3.json', // Replace with your animation path
                              width: 200,
                              height: 140,
                              repeat: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if(_imageFiles!=null)
                    CarouselSlider(
                      items: _imageFiles!.asMap().entries.map((entry) {
                        int index = entry.key;
                        XFile file = entry.value;

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
                                  child: Image.file(
                                    File(file.path),
                                    //fit:BoxFit.contain
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
                                      "${index + 1}/${_imageFiles!.length}",
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              // Camera button
              IconButton(
                onPressed: () {
                  _pickMultipleImages();
                },
                icon: Icon(CupertinoIcons.camera_fill),
                color: Colors.purpleAccent,
                iconSize: 25,
                padding: EdgeInsets.all(16),
                splashRadius: 28,
              ),
              SizedBox(width: 15),

              // Hashtag button
              IconButton(
                onPressed: () {
                  // Add your hashtag action here
                },
                icon: Icon(CupertinoIcons.number),
                color: Colors.cyanAccent,
                iconSize: 25,
                padding: EdgeInsets.all(16),
                splashRadius: 28,
              ),
              SizedBox(width: 15),

              // At-the-rate button
              IconButton(
                onPressed: () {
                  // Add your at-the-rate action here
                },
                icon: Icon(CupertinoIcons.at),
                color: Colors.greenAccent,
                iconSize: 25,
                padding: EdgeInsets.all(16),
                splashRadius: 28,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              width:MediaQuery.of(context).size.width,
              height:40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color.fromRGBO(145, 0, 255, 1),
              ),
              child:Text("Post",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      )
    );
  }
}
