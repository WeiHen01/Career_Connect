// // import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:pie_chart/pie_chart.dart';
//
// import '../../controller/request_controller.dart';
// import '../../models/user.dart';
//
//
// class ViewStats extends StatefulWidget {
//   const ViewStats({super.key});
//
//   @override
//   State<ViewStats> createState() => _ViewStatsState();
// }
//
// class _ViewStatsState extends State<ViewStats> {
//   late List<User> companyuser;
//   late List<User> jobseekers;
//   late Map<String, int> dataMap;
//   late List<Color> colorList;
//   String choiceIndex = "";
//
//   Future<void> getJobSeeker() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? server = prefs.getString("localhost");
//     WebRequestController req = WebRequestController(
//       path: "/inployed/user/admin/ctrlUserJobSeeker/Job Seeker",
//       server: "http://$server:8080",
//     );
//
//     await req.get();
//
//     if (req.status() == 200) {
//       List<dynamic> data = req.result();
//       setState(() {
//         jobseekers = data.map((json) => User.fromJson(json)).toList();
//       });
//     } else {
//       throw Exception('Failed to fetch job');
//     }
//   }
//
//   Future<void> getCompanyUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? server = prefs.getString("localhost");
//     WebRequestController req = WebRequestController(
//       path: "/inployed/user/admin/ctrlUserCompany/Company",
//       server: "http://$server:8080",
//     );
//
//     await req.get();
//
//     if (req.status() == 200) {
//       List<dynamic> data = req.result();
//       setState(() {
//         companyuser = data.map((json) => User.fromJson(json)).toList();
//       });
//     } else {
//       throw Exception('Failed to fetch job');
//     }
//   }
//
//   Future<void> fetchData() async {
//     // Fetch jobseekers and companyuser data
//     await getJobSeeker();
//     await getCompanyUser();
//
//     dataMap = {
//       "Job Seekers": jobseekers.length.toInt(),
//       "Company": companyuser.length.toInt(),
//     };
//
//     colorList = [
//       const Color(0xffFE9539),
//       const Color(0xff3EF094)
//     ];
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     jobseekers = [];
//     companyuser = [];
//     dataMap = {};
//     colorList = [];
//     fetchData();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Pie Chart"),
//       ),
//       body: Center(
//         child: dataMap != null && colorList != null
//             ? PieChart(
//                 dataMap: dataMap,
//                 colorList: colorList!,
//                 chartRadius: MediaQuery.of(context).size.width / 2,
//                 // centerText:
//               )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }
//
//
