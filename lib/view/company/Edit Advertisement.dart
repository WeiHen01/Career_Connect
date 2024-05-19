import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/OneSignalController.dart';
import '../../controller/request_controller.dart';
import '../../models/advertisement.dart';

class EditCompanyAds extends StatefulWidget {
  final int ads;
  const EditCompanyAds({required this.ads});

  @override
  State<EditCompanyAds> createState() => _EditCompanyAdsState();
}

class _EditCompanyAdsState extends State<EditCompanyAds> {

  TextEditingController positionTxtCtrl = TextEditingController();
  TextEditingController descTxtCtrl = TextEditingController();
  TextEditingController jobtimeCtrl = TextEditingController();
  TextEditingController industryCtrl = TextEditingController();
  TextEditingController salaryMinCtrl = TextEditingController();
  TextEditingController salaryMaxCtrl = TextEditingController();

  String? dropdownRemote;
  String? dropdownJobCommit;
  String? dropdownDate;
  String? newSalary;

  Advertisement? _job;
  int adsid = 0;
  String salary = "";
  int? minSalary, maxSalary;

  Future<void> getCurrentJobInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? server = prefs.getString("localhost");
    WebRequestController req = WebRequestController(
        path: "/inployed/job/${widget.ads}",
        server: "http://$server:8080");

    await req.get();

    if (req.status() == 200) {
      final Map<String, dynamic> responseData = req.result();
      final job = Advertisement.fromJson(responseData);

      setState(() {
        _job = job;
        salary = job.salary;
        positionTxtCtrl.text = job.jobPosition;
        descTxtCtrl.text = job.jobDescription;
        jobtimeCtrl.text = job.jobTime;
        industryCtrl.text = job.industry;
        dropdownRemote = job.jobRemote;
        dropdownJobCommit = job.jobCommit;
        dropdownDate = job.jobDate;

        List<String> parts = job.salary.split(' - ');

        if (parts.length == 2) {
          String amountA = parts[0].replaceAll('RM', '');
          String amountB = parts[1].replaceAll('RM', '');

          int variableA = int.tryParse(amountA) ?? 0;
          int variableB = int.tryParse(amountB) ?? 0;

          salaryMinCtrl.text = variableA.toString();
          salaryMaxCtrl.text = variableB.toString();
        } else {
          print('Invalid input format');
        }
      });
    } else {
      throw Exception('Failed to fetch job info');
    }
  }

  Future<void> updateJob() async {
    Map<String, dynamic> requestBody = {};

    if (positionTxtCtrl.text.isNotEmpty) {
      requestBody["jobPosition"] = positionTxtCtrl.text;
    }

    if (descTxtCtrl.text.isNotEmpty) {
      requestBody["jobDescription"] = descTxtCtrl.text;
    }

    if (jobtimeCtrl.text.isNotEmpty) {
      requestBody["jobTime"] = jobtimeCtrl.text;
    }

    if (industryCtrl.text.isNotEmpty) {
      requestBody["industry"] = industryCtrl.text;
    }

    if (salaryMinCtrl.text.isNotEmpty) {
      if (salaryMaxCtrl.text.isNotEmpty) {
        newSalary = "RM${salaryMinCtrl.text} - RM${salaryMaxCtrl.text}";
      } else {
        newSalary = salaryMinCtrl.text;
      }

      requestBody["salary"] = newSalary;
    }

    if (dropdownDate != null && dropdownDate!.isNotEmpty) {
      requestBody["jobDate"] = dropdownDate;
    }

    if (dropdownJobCommit != null && dropdownJobCommit!.isNotEmpty) {
      requestBody["jobCommit"] = dropdownJobCommit;
    }

    if (dropdownRemote != null && dropdownRemote!.isNotEmpty) {
      requestBody["jobRemote"] = dropdownRemote;
    }

    final prefs = await SharedPreferences.getInstance();
    String? server = prefs.getString("localhost");
    WebRequestController req = WebRequestController(
        path: "/inployed/job/update/jobPost/${widget.ads}",
        server: "http://$server:8080");

    req.setBody(requestBody);
    await req.put();

    if (req.status() == 200) {
      Fluttertoast.showToast(
        msg: 'Update successfully',
        backgroundColor: Colors.white,
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16.0,
      );

      positionTxtCtrl.clear();
      descTxtCtrl.clear();
      jobtimeCtrl.clear();
      industryCtrl.clear();
      dropdownRemote = null;
      dropdownJobCommit = null;
      dropdownDate = null;
      salaryMinCtrl.clear();
      salaryMaxCtrl.clear();

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: 'Update failed!',
        backgroundColor: Colors.white,
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentJobInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Color(0xFF0087B2)
          ),
        ),
        title: Text("Edit your job", style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, color: Colors.white,
            fontSize: 26
        ),),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF0C2134),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Update Job", style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 28,
                      fontWeight: FontWeight.bold
                  )),
                ],
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFECE3F6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Job Position", style: GoogleFonts.poppins(
                        color: Colors.black, fontSize: 18,
                        fontWeight: FontWeight.bold
                    )),
                    TextField(
                      controller: positionTxtCtrl,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white70,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Current :${_job?.jobPosition}",
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.bold
                        ),
                        labelText: "Current :${_job?.jobPosition}",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                          fontSize: 15
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Job Description", style: GoogleFonts.poppins(
                        color: Colors.black, fontSize: 18,
                        fontWeight: FontWeight.bold
                    )),
                    SingleChildScrollView(
                      child: TextField(
                        controller: descTxtCtrl,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        autocorrect: true,
                        autofocus: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.description),
                          filled: true,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Current :${_job?.jobDescription}",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.bold
                          ),
                          labelText: "Current :${_job?.jobDescription}",
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 15,
                          ),
                        ),
                        style: GoogleFonts.poppins(
                            fontSize: 15
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Job Remote", style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 18,
                                    fontWeight: FontWeight.bold
                                )),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Job Commitment", style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 18,
                                    fontWeight: FontWeight.bold
                                )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white70,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: dropdownRemote,
                                      hint: Text("Select Remote Option"),
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("Remote", style: GoogleFonts.poppins(fontSize: 15)),
                                          value: "Remote",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Hybrid", style: GoogleFonts.poppins(fontSize: 15)),
                                          value: "Hybrid",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Onsite", style: GoogleFonts.poppins(fontSize: 15)),
                                          value: "Onsite",
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          dropdownRemote = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white70,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: dropdownJobCommit,
                                      hint: Text("Select Commitment Level"),
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("Full Time", style: GoogleFonts.poppins(fontSize: 15)),
                                          value: "Full Time",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Part Time", style: GoogleFonts.poppins(fontSize: 15)),
                                          value: "Part Time",
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          dropdownJobCommit = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Job Time", style: GoogleFonts.poppins(
                        color: Colors.black, fontSize: 18,
                        fontWeight: FontWeight.bold
                    )),
                    TextField(
                      controller: jobtimeCtrl,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white70,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Current :${_job?.jobTime}",
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.bold
                        ),
                        labelText: "Current :${_job?.jobTime}",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                          fontSize: 15
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Industry", style: GoogleFonts.poppins(
                        color: Colors.black, fontSize: 18,
                        fontWeight: FontWeight.bold
                    )),
                    TextField(
                      controller: industryCtrl,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.business),
                        filled: true,
                        fillColor: Colors.white70,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Current :${_job?.industry}",
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.bold
                        ),
                        labelText: "Current :${_job?.industry}",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                          fontSize: 15
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Salary", style: GoogleFonts.poppins(
                        color: Colors.black, fontSize: 18,
                        fontWeight: FontWeight.bold
                    )),
                    TextField(
                      controller: salaryMinCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.monetization_on),
                        filled: true,
                        fillColor: Colors.white70,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Min",
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.bold
                        ),
                        labelText: "Current Min Salary: ${salary.split(' - ')[0]}",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                          fontSize: 15
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: salaryMaxCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.monetization_on),
                        filled: true,
                        fillColor: Colors.white70,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Max",
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.bold
                        ),
                        labelText: "Current Max Salary: ${salary.split(' - ')[1]}",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                          fontSize: 15
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Job Date", style: GoogleFonts.poppins(
                        color: Colors.black, fontSize: 18,
                        fontWeight: FontWeight.bold
                    )),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white70,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dropdownDate,
                          hint: Text("Select Job Date"),
                          items: [
                            DropdownMenuItem(
                              child: Text("1 month", style: GoogleFonts.poppins(fontSize: 15)),
                              value: "1 month",
                            ),
                            DropdownMenuItem(
                              child: Text("2 month", style: GoogleFonts.poppins(fontSize: 15)),
                              value: "2 month",
                            ),
                            DropdownMenuItem(
                              child: Text("3 month", style: GoogleFonts.poppins(fontSize: 15)),
                              value: "3 month",
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              dropdownDate = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: updateJob,
                        child: Text("Update Job", style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 16
                        )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}