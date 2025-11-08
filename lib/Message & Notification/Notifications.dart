// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../config/common.dart';
import 'Advisory_tab.dart';
import 'Information_tab.dart';
import 'notification_filter.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  NotificationViewFilter _filter = NotificationViewFilter.all;
  int status = NotificationViewFilter.all.index;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            "assets/images/arrow-narrow-left (1).png",
            scale: 3,
            color: notifier.textColor,
          ),
        ),
        title: Center(
          child: Text(
            "Notifications",
            style: TextStyle(
              color: notifier.textColor,
              fontSize: 16,
              fontFamily: "Manrope-Bold",
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                isScrollControlled: true,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Container(
                        height: height / 2,
                        color: notifier.background,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Sort",
                                    style: TextStyle(
                                      fontFamily: "Manrope-Bold",
                                      fontSize: 16,
                                      color: notifier.textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: notifier.textColor,
                                      ))
                                ],
                              ),
                              AppConstants.Height(10),
                              Divider(
                                color: notifier.getContainerBorder,
                                thickness: 1,
                              ),
                              AppConstants.Height(10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    status = NotificationViewFilter.all.index;
                                    _filter = NotificationViewFilter.all;
                                  });
                                },
                                child: Container(
                                  height: height / 12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: status == NotificationViewFilter.all.index
                                              ? const Color(0xFF8B0000)
                                              : notifier.getContainerBorder)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "All Status",
                                          style: TextStyle(
                                              color: notifier.textColor,
                                              fontSize: 16,
                                              fontFamily: "Manrope-Regular"),
                                        ),
                                      ),
                                      const Spacer(),
                                      Radio(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    const Color(0xFF8B0000)),
                                        // activeColor: const Color(0xff0056D2),
                                        value: NotificationViewFilter.all.index,
                                        groupValue: status,
                                        onChanged: (index) {
                                          setState(
                                            () {
                                              status = NotificationViewFilter.all.index;
                                              _filter = NotificationViewFilter.all;
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AppConstants.Height(10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    status = NotificationViewFilter.read.index;
                                    _filter = NotificationViewFilter.read;
                                  });
                                },
                                child: Container(
                                  height: height / 12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: status == NotificationViewFilter.read.index
                                              ? const Color(0xFF8B0000)
                                              : notifier.getContainerBorder)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Already Read",
                                          style: TextStyle(
                                              color: notifier.textColor,
                                              fontSize: 16,
                                              fontFamily: "Manrope-Regular"),
                                        ),
                                      ),
                                      const Spacer(),
                                      Radio(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    const Color(0xFF8B0000)),
                                        // activeColor: const Color(0xff0056D2),
                                        value: NotificationViewFilter.read.index,
                                        groupValue: status,
                                        onChanged: (value) {
                                          setState(() {
                                            status = NotificationViewFilter.read.index;
                                            _filter = NotificationViewFilter.read;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AppConstants.Height(10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    status = NotificationViewFilter.unread.index;
                                    _filter = NotificationViewFilter.unread;
                                  });
                                },
                                child: Container(
                                  height: height / 12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: status == NotificationViewFilter.unread.index
                                              ? const Color(0xFF8B0000)
                                              : notifier.getContainerBorder)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Unread",
                                          style: TextStyle(
                                              color: notifier.textColor,
                                              fontSize: 16,
                                              fontFamily: "Manrope-Regular"),
                                        ),
                                      ),
                                      const Spacer(),
                                      Radio(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    const Color(0xFF8B0000)),
                                        // activeColor: const Color(0xff0056D2),
                                        value: NotificationViewFilter.unread.index,
                                        groupValue: status,
                                        onChanged: (value) {
                                          setState(() {
                                            status = NotificationViewFilter.unread.index;
                                            _filter = NotificationViewFilter.unread;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AppConstants.Height(10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xFF8B0000)),
                                  child: const Center(
                                      child: Text("Done",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xffFFFFFF),
                                              fontFamily: "Manrope-Bold"))),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Image.asset(
              "assets/images/arrows-sort.png",
              scale: 3,
              color: const Color(0xFF8B0000),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          AppConstants.Height(30),
          Container(
            height: 55,
            width: 330,
            decoration: BoxDecoration(
                border: Border.all(color: notifier.getContainerBorder),
                borderRadius: BorderRadius.circular(10),),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: TabBar(
                padding: const EdgeInsets.only(left: 2, right: 2, top: 2,bottom: 2),
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: notifier.getContainerBorder,
                ),
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                      child: Text(
                    "Advisory",
                    style: TextStyle(color: notifier.textColor, fontSize: 13),
                  ),),
                  Tab(
                      child: Text(
                    "Information",
                    style: TextStyle(color: notifier.textColor, fontSize: 13),
                  ),),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AdvisoryTab(filter: _filter),
                InformationTab(filter: _filter),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
