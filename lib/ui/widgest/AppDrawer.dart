import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lpms/screens/slot_booking/ExportDashboard.dart';
import 'package:lpms/screens/slot_booking/ImportDashboard.dart';
import 'package:lpms/theme/app_color.dart';
import '../../core/dimensions.dart';
import '../../core/img_assets.dart';
import '../../util/Global.dart';
import '../../util/media_query.dart';
import 'CustomTextField.dart';
class AppDrawerOld extends StatefulWidget {
  final String selectedScreen;

  AppDrawerOld({required this.selectedScreen});

  @override
  _AppDrawerOldState createState() => _AppDrawerOldState();
}

class _AppDrawerOldState extends State<AppDrawerOld> {
  bool showSlotBookingItems = false;

  @override
  void initState() {
    super.initState();

    if (widget.selectedScreen == 'Import' || widget.selectedScreen == 'Export') {
      showSlotBookingItems = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0057D8),
                  Color(0xFF1c86ff),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Text(
              'LPMS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ExpansionTile(
            title: const Text("Slot Booking"),
            leading: const Icon(Icons.local_shipping_outlined),
            initiallyExpanded: showSlotBookingItems,
            backgroundColor: (widget.selectedScreen == 'Import' || widget.selectedScreen == 'Export')
                ? Colors.grey[300]
                : null,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.import_export_outlined,
                  color: AppColors.primary,
                ),
                title: const Text('Export'),
                selected: widget.selectedScreen == 'Export',
                selectedTileColor: Colors.grey[300],
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExportScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.import_export_outlined,
                  color: AppColors.primary,
                ),
                title: const Text('Import'),
                selected: widget.selectedScreen == 'Import',
                selectedTileColor: Colors.grey[300],
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImportScreen()),
                  );
                },
              ),
            ],
          )
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(builder: (context) => SettingsScreen()),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatefulWidget {

  final VoidCallback onDrawerCloseIcon;

  const AppDrawer({super.key,
 required this.onDrawerCloseIcon});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  TextEditingController searchEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  bool isImportExpanded = false;
  bool isExportExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width * 0.90, // Set to 75% of screen width
      color: AppColors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 20, top: 48, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(lpaiImage2, height: ScreenDimension.onePercentOfScreenHight * 7,),
                            SizedBox(width: ScreenDimension.onePercentOfScreenWidth*1,),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Land Ports \n",
                                    style:TextStyle(
                                      fontSize: ScreenDimension.textSize *AppDimensions. bodyTextLarge,
                                      color: const Color(0xff266d96),
                                      fontWeight: FontWeight.w800,
                                      height: 1.0,
                                    ),

                                  ),
                                  TextSpan(
                                    text: "Authority of India\n",
                                    style:  TextStyle(
                                      fontSize: ScreenDimension.textSize * AppDimensions.bodyTextLarge,
                                      color: const Color(0xff266d96),
                                      fontWeight: FontWeight.w800,
                                      height: 1.0,

                                    ),
                                  ),
                                  TextSpan(
                                    text: "Systematic Seamless Secure",
                                    style:  TextStyle(
                                      fontSize: ScreenDimension.textSize * 1.0,
                                      color: AppColors.textColorPrimary,
                                      fontWeight: FontWeight.w600,

                                    ),
                                  ),

                                ],
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ], ),
                        // Image.asset(lpaiImage, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.HEIGHT6, fit: BoxFit.cover,),
                        InkWell(
                            onTap: widget.onDrawerCloseIcon,
                            child: SvgPicture.asset(cancel, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.HEIGHT3,))
                      ],
                    ),
                  ),
                  CustomDivider(
                    space: 0,
                    color: AppColors.textColorPrimary,
                    hascolor: true,
                    thickness: 1,
                  ),
                  SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: CustomText(text: "PROFILE", fontColor: AppColors.textColorPrimary, fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: ScreenDimension.onePercentOfScreenHight *  AppDimensions.TEXTSIZE_2_3,
                              child: Image.asset(lpaiImage2,fit: BoxFit.cover,),
                            ),
                            SizedBox(width: ScreenDimension.onePercentOfScreenWidth * AppDimensions.WIDTH2,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: loginMaster.first.firstName,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w600,
                                    fontColor:  AppColors.textColorPrimary,
                                    fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
                                  CustomText(
                                    text: "===",
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w400,
                                    fontColor:  AppColors.textColorPrimary,
                                    fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3,),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  widget.onDrawerCloseIcon();
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const ImportScreen(),));
                                },
                                child: SvgPicture.asset(logout, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE_2_6 ,)),
                            SizedBox(width: ScreenDimension.onePercentOfScreenWidth * AppDimensions.WIDTH6,),
                            SvgPicture.asset(more, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE_2_6 ,)
                          ],
                        ),



                      )
                    ],
                  ),
                  SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: CustomText(text: "SERVICES", fontColor: AppColors.textColorPrimary, fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            GroupIdCustomTextField(
                              controller: searchEditingController,
                              focusNode: searchFocusNode,
                              hasIcon: true,
                              hastextcolor: true,
                              animatedLabel: false,
                              needOutlineBorder: true,
                              isShowPrefixIcon: true,
                              isIcon: true,
                              isSearch: true,
                              prefixIconcolor: AppColors.black,
                              hintText: "Search Menu",
                              readOnly: false,
                              onChanged: (value) async {



                              },
                              fillColor: AppColors.white,
                              textInputType: TextInputType.number,
                              inputAction: TextInputAction.next,
                              hintTextcolor: AppColors.black.withOpacity(0.7),
                              verticalPadding: 0,
                              maxLength: 15,
                              fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_8,
                              circularCorner: ScreenDimension.onePercentOfScreenWidth * AppDimensions.CIRCULARBORDER,
                              boxHeight: ScreenDimension.onePercentOfScreenHight * AppDimensions.HEIGHT6,
                              isDigitsOnly: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please fill out this field";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(dashboard, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
                                        SizedBox(width: 15,),
                                        CustomText(
                                          text: "Dashboard",
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          fontColor:  AppColors.textColorPrimary,
                                          fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  /* Container(
                                    decoration: BoxDecoration(
                                      color: (isImportExpanded) ? AppColors.cardTextColor : AppColors.background,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _buildMenuItem(
                                        icon: importSvg,
                                        title: "Import (${widget.importSubMenuList!.length})",
                                        isExpanded: isImportExpanded,
                                        onIconTap: () {
                                          setState(() {
                                            isImportExpanded = !isImportExpanded;
                                          });
                                        },
                                        subMenuList: isImportExpanded ? widget.importSubMenuList : null,

                                      ),
                                    ),
                                  ),*/
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                            SvgPicture.asset(exportSvg, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
                                            SizedBox(width: 20,),
                                            CustomText(
                                              text: "Import",
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.w500,
                                              fontColor:  AppColors.textColorPrimary,
                                              fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
                                          ],
                                        ),
                                        SvgPicture.asset(circleDown, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                            SvgPicture.asset(exportSvg, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
                                            const SizedBox(width: 20,),
                                            CustomText(
                                              text: "Export ",
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.w500,
                                              fontColor:  AppColors.textColorPrimary,
                                              fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
                                          ],
                                        ),
                                        SvgPicture.asset(circleDown, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),

                                      ],
                                    ),
                                  ),


                                ],
                              ),
                            )
                          ],
                        ),



                      )
                    ],
                  ),
                  SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: CustomText(text: "APP INFO", fontColor: AppColors.textColorPrimary, fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        decoration: BoxDecoration(
                          color: AppColors.lightPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(manual, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
                                        SizedBox(width: 20,),
                                        CustomText(
                                          text: "Product Manual",
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          fontColor:  AppColors.textColorPrimary,
                                          fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(comments, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
                                        SizedBox(width: 12,),
                                        CustomText(
                                          text: "FAQ",
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          fontColor:  AppColors.textColorPrimary,
                                          fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () async {
                                        widget.onDrawerCloseIcon();
                                        // final releaseNoteModel = await loadReleaseNotes();
                                        // showDialog(
                                        //   context: context,
                                        //   barrierDismissible: false,
                                        //   builder: (BuildContext context) {
                                        //     return ReleaseNoteDialog(releaseNoteModel: releaseNoteModel);
                                        //   },
                                        // );

                                      },

                                      child: Row(
                                        children: [
                                          SvgPicture.asset(info, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3, color: AppColors.textColorPrimary ,),
                                          SizedBox(width: 15,),
                                          CustomText(
                                            text: "App release note",
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w500,
                                            fontColor:  AppColors.textColorPrimary,
                                            fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),



                      )
                    ],
                  )

                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: AppColors.background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: "KLSPL",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontColor:  AppColors.textColorSecondary,
                  fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
                CustomText(
                  text: "App Build 1.0.0",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontColor:  AppColors.textColorSecondary,
                  fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
              ],
            ),
          )
        ],
      ),
    );
  }



}
class CustomDivider extends StatelessWidget {
  final double space;
  final Color color;
  final bool hascolor;
  double? height;
  double? thickness;

  CustomDivider(
      {Key? key,
        this.height = 0.5,
        this.thickness = 0.5,
        this.space = 20,
        this.color = AppColors.black, this.hascolor =false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color:
        hascolor ==true?
        color.withOpacity(0.2):color.withOpacity(0), height: height, thickness: thickness),
      ],
    );
  }
}
