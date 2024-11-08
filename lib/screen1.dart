import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:circular_progress_bar_with_lines/circular_progress_bar_with_lines.dart';
import 'package:dynamic_stack_card_swiper/dynamic_stack_card_swiper.dart';
import 'package:reorderable_staggered_scroll_view/reorderable_staggered_scroll_view.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("AceSpace",style: TextStyle(color: Colors.white,fontSize: 25),),
            ),
            AttendanceHeatmap(),
            AttendanceOverview(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OverallAttendance(),
                AssignmentDeadline(),
              ],
            ),
            SubjectsAttendanceSwipeStack(),
            AttenLineVisualizer(),
            MoneySpent(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FeeWidget(),
                HolidaysWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class AttendanceHeatmap extends StatefulWidget {
  const AttendanceHeatmap({super.key});

  @override
  State<AttendanceHeatmap> createState() => _AttendanceHeatmapState();
}

class _AttendanceHeatmapState extends State<AttendanceHeatmap> {
  List<String> months = ["Jan", "Feb", "March", "April", "May", "June", "July", "August", "Sep", "Oct", "Nov", "Dec"];

  final List<Color> neonGreenLevels = [
    Color.fromRGBO(59, 59, 61, 1),
    Color.fromRGBO(57, 255, 20, 1.0), // Bright Neon Green
    Color.fromRGBO(80, 255, 30, 0.8),  // Slightly Less Bright
    Color.fromRGBO(100, 255, 40, 0.6), // Medium Brightness
    Color.fromRGBO(150, 255, 60, 0.4), // Dimmer Neon Green
  ];

  List<int> daysInMonth(int year) {
    return [
      31,
      (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28,
      31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(28, 28, 30, 1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top:8,left:8),
              child: Text(
                "Attendance Heatmap",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8), // Add a small space for readability
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, monthIndex) {
                  return SizedBox(
                    width: 150, // Adjust this width as per your UI needs
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            months[monthIndex],
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4), // Small space below month text
                          Expanded(
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: daysInMonth(DateTime.now().year)[monthIndex],
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                              ),
                              itemBuilder: (context, index) {
                                Random random = Random(); // Random generator
                                Color randomColor = neonGreenLevels[random.nextInt(neonGreenLevels.length)];
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: randomColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AttendanceOverview extends StatefulWidget {
  const AttendanceOverview({super.key});

  @override
  State<AttendanceOverview> createState() => _AttendanceOverviewState();
}

class _AttendanceOverviewState extends State<AttendanceOverview> {

  List heights=[0.6,0.9,0.7,0.4,0.85];
  List colors=[Color.fromRGBO(252,177,42,1),Color.fromRGBO(241,45,95,1),Color.fromRGBO(152,112,252,1),Color.fromRGBO(84,230,59,1),Color.fromRGBO(5,182,250,1)];
  List subjects=["English","Physics","Chemistry","It","Painting"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 220,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(28, 28, 30, 1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text("Attendance Overview", style: TextStyle(color: Colors.white)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height:120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space the percentage labels
                    children: const [
                      Text("100%", style: TextStyle(color: Colors.white)),
                      Text("80%", style: TextStyle(color: Colors.white)),
                      Text("60%", style: TextStyle(color: Colors.white)),
                      Text("40%", style: TextStyle(color: Colors.white)),
                      Text("20%", style: TextStyle(color: Colors.white)),
                      Text("0%", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(width: 10), // Add spacing between the columns
                Expanded(
                  child: SizedBox(
                    height: 160, // Constrain the height of the ListView
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // For example, 30 days of attendance
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height:120,
                                width:20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Color.fromRGBO(17,20,27,1)
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width:20,
                                    height:heights[index]*120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: colors[index]
                                    ),
                                  ),
                                ),
                              ),
                              Text(subjects[index],style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OverallAttendance extends StatefulWidget {
  const OverallAttendance({super.key});

  @override
  State<OverallAttendance> createState() => _OverallAttendanceState();
}

class _OverallAttendanceState extends State<OverallAttendance> {

  // Create a ValueNotifier with an initial value (e.g., 37%).
  final ValueNotifier<double> _valueNotifier = ValueNotifier(37.0);

  @override
  void dispose() {
    // Always dispose of the ValueNotifier to free up resources.
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width:MediaQuery.of(context).size.width*0.45,
        height:MediaQuery.of(context).size.width*0.45,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(28, 28, 30, 1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: DashedCircularProgressBar.aspectRatio(
            aspectRatio: 1, // width ÷ height
            progress: _valueNotifier.value,
            startAngle: 225,
            sweepAngle: 270,
            foregroundColor: Color.fromRGBO(50, 205, 50,1),
            backgroundColor: const Color(0xffeeeeee),
            foregroundStrokeWidth: 15,
            backgroundStrokeWidth: 15,
            animation: true,
            seekSize: 6,
            seekColor: const Color(0xffeeeeee),
            child:Center(
              child: ValueListenableBuilder(
                  valueListenable: _valueNotifier,
                  builder: (_, double value, __) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35
                        ),
                      ),
                      Text(
                        'Attendance',
                        style: const TextStyle(
                            color: Color(0xffeeeeee),
                            fontWeight: FontWeight.w400,
                            fontSize: 16
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
        )
      ),
    );
  }
}

class SubjectsAttendanceSwipeStack extends StatefulWidget {
  const SubjectsAttendanceSwipeStack({super.key});

  @override
  State<SubjectsAttendanceSwipeStack> createState() => _SubjectsAttendanceSwipeStackState();
}

class _SubjectsAttendanceSwipeStackState extends State<SubjectsAttendanceSwipeStack> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width:MediaQuery.of(context).size.width,
        height:80,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(28, 28, 30, 1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child:Row(
          children: [
            SizedBox(width:15),
            CircleAvatar(
              backgroundColor: Color.fromRGBO(17,20,27,1),
              child: ClipOval(child: Image(image: AssetImage('assets/english.jpg'),)),
            ),
            SizedBox(width:15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("English",style: TextStyle(color:Colors.white),),
                Text("Attendance",style: TextStyle(color:Colors.white60),),
                Text("90%",style: TextStyle(color:Colors.white),),
              ],
            ),
            SizedBox(width:15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(""),
                Text("Bunks Available",style: TextStyle(color:Colors.white60),),
                Text("5",style: TextStyle(color:Colors.white),),
              ],
            )
          ],
        )
      ),
    );
  }
}

class AttenLineVisualizer extends StatefulWidget {
  const AttenLineVisualizer({super.key});

  @override
  State<AttenLineVisualizer> createState() => _AttenLineVisualizerState();
}

class _AttenLineVisualizerState extends State<AttenLineVisualizer> {

  List<Color> gradientColors = [
    Color(0xFF8A2BE2), // Neon Purple
    Color(0xFF00FFFF), // Neon Cyan/Blue
  ];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color:Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('JAN', style: style);
        break;
      case 2:
        text = const Text('FEB', style: style);
        break;
      case 3:
        text = const Text('MAR', style: style);
        break;
      case 4:
        text = const Text('APR', style: style);
        break;
      case 5:
        text = const Text('MAY', style: style);
        break;
      case 6:
        text = const Text('JUNE', style: style);
        break;
      case 7:
        text = const Text('JULY', style: style);
        break;
      case 8:
        text = const Text('AUG', style: style);
        break;
      case 9:
        text = const Text('SEP', style: style);
        break;
      case 10:
        text = const Text('OCT', style: style);
        break;
      case 11:
        text = const Text('NOV', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color:Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '20%';
        break;
      case 2:
        text = '40%';
        break;
      case 3:
        text = '60%';
        break;
      case 4:
        text="80%";
      case 5:
        text="100%";
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width:MediaQuery.of(context).size.width,
        height:200,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(28, 28, 30, 1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color.fromRGBO(59, 59, 61, 1),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Color.fromRGBO(59, 59, 61, 1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d)),
                ),
                minX: 0,
                maxX: 12,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(2.6, 2),
                      FlSpot(4.9, 5),
                      FlSpot(6.8, 3.1),
                      FlSpot(8, 4),
                      FlSpot(9.5, 3),
                      FlSpot(11, 4),
                      FlSpot(12,4),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: gradientColors
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}


class AssignmentDeadline extends StatefulWidget {
  const AssignmentDeadline({super.key});

  @override
  State<AssignmentDeadline> createState() => _AssignmentDeadlineState();
}

class _AssignmentDeadlineState extends State<AssignmentDeadline> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width:MediaQuery.of(context).size.width*0.45,
          height:MediaQuery.of(context).size.width*0.45,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(28, 28, 30, 1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Physics Assignment 1",style: TextStyle(color:Colors.white),),
                SizedBox(height:8),
                LinearProgressIndicator(
                  value: 0.4,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 10,
                  color: Color.fromRGBO(255,7,58,1),
                ),
                Row(
                  children: [
                    Text("DeadLine",style: TextStyle(color:  Color.fromRGBO(255,7,58,1)),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor:  Color.fromRGBO(255,7,58,1),
                        radius: 2,
                      ),
                    ),
                    Text("44%",style: TextStyle(color:  Color.fromRGBO(255,7,58,1)),),
                  ],
                ),
                //SizedBox(height:10),
                Text("20 H 22 M",style: TextStyle(color: Colors.white),),
                Text("Time Left",style: TextStyle(color: Colors.white),),
                ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(59, 59, 61, 1),
                    ),
                    child: Text("Submit",style: TextStyle(color: Colors.white),),
                )
              ],
            ),
          )
      ),
    );
  }
}

class MoneySpent extends StatefulWidget {
  const MoneySpent({super.key});

  @override
  State<MoneySpent> createState() => _MoneySpentState();
}

class _MoneySpentState extends State<MoneySpent> {

  int selectedPeriodIndex=-1;
  List timePeriod = ['Day', "Week", "Month", "Quarter", "Year"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(28, 28, 30, 1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FinTrack",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height:10),
              SizedBox(
                height: 35, // Set a fixed height for the ListView
                child: ListView.builder(
                  itemCount: timePeriod.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedPeriodIndex=index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Color.fromRGBO(255,7,58,1)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  selectedPeriodIndex==index?CircleAvatar(
                                    radius: 2,
                                    backgroundColor:  Color.fromRGBO(255,7,58,1),
                                  ):Container(),
                                  SizedBox(width:2),
                                  Text(
                                    timePeriod[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height:10),
              Row(
                children: [
                  Text(
                    "₹ 1,200",
                    style: TextStyle(color: Colors.white,fontSize: 30),
                  ),
                  Transform.rotate(
                    angle: pi / 2,
                    child: Lottie.asset(
                      'assets/money.json', // Path to your Lottie file
                      width: 100, // Set the desired width
                      height: 50, // Set the desired height
                      fit: BoxFit.fill, // Fit the animation within the box
                      repeat: true, // Repeat the animation
                      reverse: false, // Play in reverse when it ends
                      animate: true, // Automatically start animation
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeeWidget extends StatefulWidget {
  const FeeWidget({super.key});

  @override
  State<FeeWidget> createState() => _FeeWidgetState();
}

class _FeeWidgetState extends State<FeeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: MediaQuery.of(context).size.width*0.45,
          height: MediaQuery.of(context).size.width*0.55,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(28, 28, 30, 1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child:Column(
            children: [
              SizedBox(height:5),
              Text("Tution Fee",style: TextStyle(color: Colors.white),),
              SizedBox(height:5),
              CircularProgressBarWithLines(
                percent: 70,
                radius: 20,
                linesLength: 30,
                linesAmount: 25,
                linesWidth: 1,
                linesColor: Color.fromRGBO(57, 255, 20,1),
                centerWidgetBuilder: (context) =>
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("70%",style: TextStyle(color: Colors.white,fontSize: 10),),
                        Text("Paid",style: TextStyle(color: Colors.white,fontSize: 10),),
                      ],
                    ),
              ),
              SizedBox(height:5),
              Text("Pending: ₹8000",style: TextStyle(color: Colors.white,),),
              Expanded(child: Container()),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width*0.45,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(57, 255, 20,1),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                ),
                child:Text("Pay Now",style: TextStyle(color: Colors.white,),),
              )
            ],
          )
      ),
    );
  }
}

class HolidaysWidget extends StatefulWidget {
  const HolidaysWidget({super.key});

  @override
  State<HolidaysWidget> createState() => _HolidaysWidgetState();
}

class _HolidaysWidgetState extends State<HolidaysWidget> {

  List holidays=["Diwali","Bhai Duj","Guru Nanak Jayanti","Christmas"];
  List dates=["31 Oct,2024","3 Nov, 2024","15 Nov, 2024","25 Dec, 2024"];
  List<Color> neonColors = [
    Color.fromRGBO(0, 123, 255, 1.0),   // Neon Blue
    Color.fromRGBO(153, 50, 204, 1.0),  // Neon Purple
    Color.fromRGBO(255, 0, 127, 1.0),   // Neon Pink
    Color.fromRGBO(50, 205, 50, 1.0),   // Neon Green
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width*0.45,
        height: MediaQuery.of(context).size.width*0.55,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(28, 28, 30, 1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upcoming Holidays",style: TextStyle(color: Colors.white),),
              Expanded(
                child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            width:6,
                            height:32,
                            decoration: BoxDecoration(
                              color: neonColors[index],
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          SizedBox(width:5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(holidays[index],style: TextStyle(color: Colors.white),),
                             Text(dates[index],style: TextStyle(color:neonColors[index],),)
                           ],
                          ),
                        ],
                      );
                    },
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
