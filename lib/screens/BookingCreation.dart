import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_color.dart';
import '../theme/app_theme.dart';

class BookingCreation extends StatefulWidget {
  const BookingCreation({super.key});
  @override
  State<BookingCreation> createState() => _BookingCreationState();
}
class _BookingCreationState extends State<BookingCreation> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: const Text(
            'Exports',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white, size: 32),
          toolbarHeight: 80,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0057D8),
                  Color(0xFF1c86ff),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(
                  FontAwesomeIcons.userGear,
                  size: 26,
                ),
                color: Colors.white,
                onPressed: () {

                }),
            IconButton(
              icon: Stack(
                children: [
                  const Icon(
                    FontAwesomeIcons.bell,
                    size: 26,
                  ),
                  // Bell icon
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.orange, // Notification dot color
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              color: Colors.white,
              onPressed: () {},
            ),
          ]),
      drawer: Drawer(
        child: ListView(
          children: const [Text('Drawer Item')],
        ),
      ),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            color: AppColors.background,
            child:   Padding(
              padding: const EdgeInsets.only(top: 16,left: 12,right: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Booking Creation',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      decoration:  BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          AppColors.gradient1,
                          AppColors.gradient2,
                        ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child:   Padding(
                        padding: const EdgeInsets.only(top: 12,left: 10,bottom: 12,right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text("BOOKING INFO.",style: TextStyle(color: AppColors.cardTextColor,fontSize:16,fontWeight: FontWeight.w700),),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,color: AppColors.cardTextColor,),
                                    Text(" AGA",style: TextStyle(color: AppColors.cardTextColor,fontSize:13,fontWeight: FontWeight.w400),),
                                    Icon(Icons.arrow_forward,color: AppColors.cardTextColor,),
                                    Text(" ALL",style: TextStyle(color: AppColors.cardTextColor,fontSize:13,fontWeight: FontWeight.w400),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color:Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text("NEW BOOKING"),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Card(
                      color: AppColors.white,
                      surfaceTintColor: AppColors.white,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),

                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("BASIC DETAILS",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14),
                            ),
                            Row(

                            ),
                          ],
                        ),
                      ),
                    )


                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    100), // Adjust the height as needed
                painter: AppBarPainterGradient(),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: (){

              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.chart_pie),
                  Text("Dashboard"),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){

              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help_outline,color: AppColors.primary,),
                  Text("User Help",style: TextStyle(color: AppColors.primary),),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
