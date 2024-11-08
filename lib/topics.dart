import 'package:flutter/material.dart';

// Define a class to hold the data for each item in the list
class TopicItem {
  final String imageUrl;
  final String title;
  final String description;

  TopicItem({required this.imageUrl, required this.title, required this.description});
}

class Topics extends StatefulWidget {
  const Topics({super.key});

  @override
  State<Topics> createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  double _maxScrollExtent = 0.0;

  List<double> widths=[100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0];

  // List of TopicItems with real images and other fields
  List<TopicItem> topics = [
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1604675439367-4d09899e477b",
      title: "Technology",
      description: "Latest trends in technology.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1590518222752-604b7259455d",
      title: "Science",
      description: "Exploring the wonders of science.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1573136979370-5dbab07ed233",
      title: "Health",
      description: "Advancements in health and wellness.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1521747116042-5b6e506c5e39",
      title: "Business",
      description: "The future of global businesses.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1578503936621-1bba51a3b69f",
      title: "Art",
      description: "The beauty and evolution of art.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1521791141633-40569fbd9cc1",
      title: "Space",
      description: "Discovering the universe beyond.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1486218554978-190f5b14a8db",
      title: "Nature",
      description: "The wonders of nature and wildlife.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1517953182595-29edc3f9f82f",
      title: "Business",
      description: "How to grow your business.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1508501370210-dccffec020fc",
      title: "Food",
      description: "Delicious food recipes and trends.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1470794621221-0c0e98e3f4fa",
      title: "Music",
      description: "The power of music in culture.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1600811513758-915c1d3d1a5e",
      title: "Fitness",
      description: "Staying fit and healthy every day.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1534514604214-cf1e06ec506d",
      title: "Sports",
      description: "The thrill of sports and competitions.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1576787240425-67246b946b44",
      title: "Education",
      description: "The future of education in the modern world.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1535466181987-c1c7b2f0f0bb",
      title: "Travel",
      description: "Discovering the world through travel.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1517489883778-8f688e2b5ec9",
      title: "Photography",
      description: "Capturing the world through a lens.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1605918608540-5c1166dbf5a9",
      title: "Gaming",
      description: "The rise of gaming culture.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1557683307-f5922f925aa2",
      title: "Fashion",
      description: "The latest fashion trends.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1536515101574-c1ef42fbe423",
      title: "Finance",
      description: "Understanding personal finance.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1589656872621-b74be5c98142",
      title: "Environment",
      description: "Protecting our planet for future generations.",
    ),
    TopicItem(
      imageUrl: "https://images.unsplash.com/photo-1548422258-9a29c981dfb9",
      title: "Lifestyle",
      description: "Living a healthy and happy lifestyle.",
    ),
  ];

  int maxContainersAtScreen = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      maxContainersAtScreen = (MediaQuery.of(context).size.height / 150).floor();
      print(maxContainersAtScreen);
    });
  }

  void _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
      _maxScrollExtent = _scrollController.position.maxScrollExtent;
    });

    // Get the status bar height
    double statusBarHeight = MediaQuery.of(context).padding.top;

    // Calculate the screen height without the status bar
    double screenHeight = MediaQuery.of(context).size.height - statusBarHeight;

    // The height of each container in the list
    double containerHeight = 150.0;

    // Calculate the index of the container near the bottom of the screen
    int indexAtBottom = ((_scrollPosition + screenHeight) / containerHeight).floor();
    setState(() {
      for (int i = 0; i < indexAtBottom; i++) {
        widths[i] = 0;
      }
    });
    print('Container index at bottom: $indexAtBottom');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: topics.length,  // Use the length of the topic list
        itemBuilder: (context, index) {
          TopicItem topic = topics[index];  // Get the topic data for this index
          return Container(
            alignment: Alignment.center,
            width: 100,
            height: 150,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: Image.network(
                      topic.imageUrl,  // Use image from the URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                if (index >= maxContainersAtScreen)
                  AnimatedContainer(
                    width: widths[index],
                    duration: Duration(milliseconds: 800),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      topic.description,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
