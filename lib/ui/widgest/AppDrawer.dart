import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lpms/screens/slot_booking/ExportDashboard.dart';
import 'package:lpms/screens/slot_booking/ImportDashboard.dart';
import 'package:lpms/theme/app_color.dart';
import '../../core/dimensions.dart';
import '../../core/img_assets.dart';
import '../../screens/login/login_new.dart';
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

    if (widget.selectedScreen == 'Import' ||
        widget.selectedScreen == 'Export') {
      showSlotBookingItems = true;
    }
  }

  bool isMenuExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: ScreenDimension.onePercentOfScreenHight * 29,
            child: DrawerHeader(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            lpaiImage2,
                            height: ScreenDimension.onePercentOfScreenHight * 7,
                          ),
                          SizedBox(
                            width: ScreenDimension.onePercentOfScreenWidth * 1,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Land Ports \n",
                                  style: TextStyle(
                                    fontSize: ScreenDimension.textSize *
                                        AppDimensions.bodyTextLarge,
                                    color: const Color(0xff266d96),
                                    fontWeight: FontWeight.w800,
                                    height: 1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: "Authority of India\n",
                                  style: TextStyle(
                                    fontSize: ScreenDimension.textSize *
                                        AppDimensions.bodyTextLarge,
                                    color: const Color(0xff266d96),
                                    fontWeight: FontWeight.w800,
                                    height: 1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: "Systematic Seamless Secure",
                                  style: TextStyle(
                                    fontSize: ScreenDimension.textSize * 1.0,
                                    color: AppColors.textColorPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenDimension.onePercentOfScreenHight,
                  ),
                  CustomDivider(
                    space: 0,
                    color: AppColors.textColorPrimary,
                    hascolor: true,
                    thickness: 1,
                  ),

                  SizedBox(
                    height: ScreenDimension.onePercentOfScreenHight,
                  ),

                  // Profile section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: CustomText(
                            text: "PROFILE",
                            fontColor: AppColors.textColorPrimary,
                            fontSize: ScreenDimension.textSize *
                                AppDimensions.TEXTSIZE_1_3,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: ScreenDimension.onePercentOfScreenHight *
                                  AppDimensions.TEXTSIZE_2_3,
                              child: Image.asset(
                                lpaiImage2,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: ScreenDimension.onePercentOfScreenWidth *
                                  AppDimensions.WIDTH2,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: loginMaster.first.firstName,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w600,
                                    fontColor: AppColors.textColorPrimary,
                                    fontSize: ScreenDimension.textSize *
                                        AppDimensions.TEXTSIZE_1_5,
                                  ),
                                  CustomText(
                                    text: "===",
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w400,
                                    fontColor: AppColors.textColorPrimary,
                                    fontSize: ScreenDimension.textSize *
                                        AppDimensions.TEXTSIZE_1_3,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const LoginPageNew(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: SvgPicture.asset(
                                  logout,
                                  height:
                                      ScreenDimension.onePercentOfScreenHight *
                                          AppDimensions.ICONSIZE_2_6,
                                )),
                            SizedBox(
                              width: ScreenDimension.onePercentOfScreenWidth *
                                  AppDimensions.WIDTH6,
                            ),
                            SvgPicture.asset(
                              more,
                              height: ScreenDimension.onePercentOfScreenHight *
                                  AppDimensions.ICONSIZE_2_6,
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: ScreenDimension.onePercentOfScreenHight,
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CustomText(
                    text: "SERVICES",
                    fontColor: AppColors.textColorPrimary,
                    fontSize:
                        ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start),
              ),
              Container(
                width: double.infinity,
                height:ScreenDimension.onePercentOfScreenHight*30,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Search field
                    GroupIdCustomTextField(
                      controller: null,
                      focusNode: null,
                      hasIcon: true,
                      hastextcolor: true,
                      animatedLabel: false,
                      needOutlineBorder: true,
                      isShowPrefixIcon: true,
                      isIcon: true,
                      isSearch: true,
                      prefixIconcolor: AppColors.black,
                      hintText: "Search Menu",
                      onPress: () {},
                      readOnly: false,
                      onChanged: (value) {
                        setState(() {
                          // searchQuery = value;
                        });
                      },
                      fillColor: AppColors.white,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      hintTextcolor: AppColors.black.withOpacity(0.7),
                      verticalPadding: 0,
                      maxLength: 15,
                      fontSize:
                          ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_8,
                      circularCorner: ScreenDimension.onePercentOfScreenWidth *
                          AppDimensions.CIRCULARBORDER,
                      boxHeight: ScreenDimension.onePercentOfScreenHight *
                          AppDimensions.HEIGHT6,
                      isDigitsOnly: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please fill out this field";
                        } else {
                          return null;
                        }
                      },
                    ),

                    SizedBox(
                      height: ScreenDimension.onePercentOfScreenHight,
                    ),

                    // Dynamic menu items
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Column(children: [
                        ExpansionTile(
                          title: CustomText(
                            text: "Slot Booking",
                            textAlign: TextAlign.left,
                            fontWeight:
                                isMenuExpanded ? FontWeight.w600 : FontWeight.w500,
                            fontColor: isMenuExpanded
                                ? AppColors.primary
                                : AppColors.textColorPrimary,
                            fontSize: ScreenDimension.textSize *
                                AppDimensions.TEXTSIZE_1_5,
                          ),
                          shape: const Border(),
                          onExpansionChanged: (bool value) {
                            setState(() {
                              isMenuExpanded = value;
                            });
                          },
                          leading: SvgPicture.asset(
                            slot,
                            height: ScreenDimension.onePercentOfScreenHight *
                                AppDimensions.ICONSIZE_2_5,
                            color: isMenuExpanded
                                ? AppColors.primary
                                : AppColors.textColorPrimary,
                          ),
                          trailing: SvgPicture.asset(
                            isMenuExpanded ? circleUp : circleDown,
                            height: ScreenDimension.onePercentOfScreenHight *
                                AppDimensions.ICONSIZE_2_5,
                            color: isMenuExpanded
                                ? AppColors.primary
                                : AppColors.textColorPrimary,
                          ),
                          initiallyExpanded: showSlotBookingItems,
                          backgroundColor: isMenuExpanded ? Colors.white : null,
                          children: [
                            ListTile(
                              leading: SvgPicture.asset(
                                exportSvg,
                                height:
                                    ScreenDimension.onePercentOfScreenHight *
                                        AppDimensions.ICONSIZE_2_5,
                                color: widget.selectedScreen == 'Export'
                                    ? AppColors.primary
                                    : AppColors.textColorPrimary,
                              ),
                              title: CustomText(
                                text: "Export",
                                textAlign: TextAlign.left,
                                fontWeight: widget.selectedScreen == 'Export'
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontColor: widget.selectedScreen == 'Export'
                                    ? AppColors.primary
                                    : AppColors.textColorPrimary,
                                fontSize: ScreenDimension.textSize *
                                    AppDimensions.TEXTSIZE_1_5,
                              ),
                              selected: widget.selectedScreen == 'Export',
                              selectedTileColor:
                                  AppColors.primary.withOpacity(0.1),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ExportScreen()),
                                );
                              },
                            ),
                            ListTile(
                              leading: SvgPicture.asset(
                                importSvg,
                                height:
                                    ScreenDimension.onePercentOfScreenHight *
                                        AppDimensions.ICONSIZE_2_5,
                                color: widget.selectedScreen == 'Import'
                                    ? AppColors.primary
                                    : AppColors.textColorPrimary,
                              ),
                              title: CustomText(
                                text: "Import",
                                textAlign: TextAlign.left,
                                fontWeight: widget.selectedScreen == 'Import'
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontColor: widget.selectedScreen == 'Import'
                                    ? AppColors.primary
                                    : AppColors.textColorPrimary,
                                fontSize: ScreenDimension.textSize *
                                    AppDimensions.TEXTSIZE_1_5,
                              ),
                              selected: widget.selectedScreen == 'Import',
                              selectedTileColor:
                                  AppColors.primary.withOpacity(0.1),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ImportScreen()),
                                );
                              },
                            ),
                          ],
                        )
                      ]),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: ScreenDimension.onePercentOfScreenHight,
              ),

              // App info section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: CustomText(
                        text: "APP INFO",
                        fontColor: AppColors.textColorPrimary,
                        fontSize: ScreenDimension.textSize *
                            AppDimensions.TEXTSIZE_1_3,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start),
                  ),
                  Container(
                    width: double.infinity,
                    margin:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 0),
                    decoration: BoxDecoration(
                      color: AppColors.lightPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      manual,
                                      height: ScreenDimension
                                          .onePercentOfScreenHight *
                                          AppDimensions.ICONSIZE3,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    CustomText(
                                      text: "Product Manual",
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w500,
                                      fontColor: AppColors.textColorPrimary,
                                      fontSize: ScreenDimension.textSize *
                                          AppDimensions.TEXTSIZE_1_5,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      comments,
                                      height: ScreenDimension
                                          .onePercentOfScreenHight *
                                          AppDimensions.ICONSIZE3,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    CustomText(
                                      text: "FAQ",
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w500,
                                      fontColor: AppColors.textColorPrimary,
                                      fontSize: ScreenDimension.textSize *
                                          AppDimensions.TEXTSIZE_1_5,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    // widget.onDrawerCloseIcon();
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        info,
                                        height: ScreenDimension
                                            .onePercentOfScreenHight *
                                            AppDimensions.ICONSIZE3,
                                        color: AppColors.textColorPrimary,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      CustomText(
                                        text: "App release note",
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w500,
                                        fontColor:
                                        AppColors.textColorPrimary,
                                        fontSize: ScreenDimension.textSize *
                                            AppDimensions.TEXTSIZE_1_5,
                                      ),
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

  // Dynamic menu data passed from outside
  final List<MenuData> menuItems;

  const AppDrawer({
    super.key,
    required this.onDrawerCloseIcon,
    required this.menuItems,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  TextEditingController searchEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  String searchQuery = "";
  Map<String, bool> expandedMenus = {};

  String? selectedMenuTitle;
  String? selectedSubmenuTitle;

  List<MenuData> get filteredMenuItems {
    if (searchQuery.isEmpty) {
      return widget.menuItems;
    }
    return widget.menuItems.where((menu) {
      if (menu.title.toLowerCase().contains(searchQuery.toLowerCase())) {
        return true;
      }
      if (menu.hasSubmenu) {
        return menu.submenuItems.any((submenu) =>
            submenu.title.toLowerCase().contains(searchQuery.toLowerCase()));
      }

      return false;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    searchEditingController.addListener(_onSearchChanged);

    // Initialize expanded state for all menu items
    for (var menu in widget.menuItems) {
      expandedMenus[menu.title] = false;
    }
  }

  @override
  void dispose() {
    searchEditingController.removeListener(_onSearchChanged);
    searchEditingController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width * 0.90,
      color: AppColors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with logo and close button
                  Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 20, top: 48, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              lpaiImage2,
                              height:
                                  ScreenDimension.onePercentOfScreenHight * 7,
                            ),
                            SizedBox(
                              width:
                                  ScreenDimension.onePercentOfScreenWidth * 1,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Land Ports \n",
                                    style: TextStyle(
                                      fontSize: ScreenDimension.textSize *
                                          AppDimensions.bodyTextLarge,
                                      color: const Color(0xff266d96),
                                      fontWeight: FontWeight.w800,
                                      height: 1.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Authority of India\n",
                                    style: TextStyle(
                                      fontSize: ScreenDimension.textSize *
                                          AppDimensions.bodyTextLarge,
                                      color: const Color(0xff266d96),
                                      fontWeight: FontWeight.w800,
                                      height: 1.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Systematic Seamless Secure",
                                    style: TextStyle(
                                      fontSize: ScreenDimension.textSize * 1.0,
                                      color: AppColors.textColorPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: widget.onDrawerCloseIcon,
                            child: SvgPicture.asset(
                              cancel,
                              height: ScreenDimension.onePercentOfScreenHight *
                                  AppDimensions.HEIGHT3,
                            ))
                      ],
                    ),
                  ),

                  CustomDivider(
                    space: 0,
                    color: AppColors.textColorPrimary,
                    hascolor: true,
                    thickness: 1,
                  ),

                  SizedBox(
                    height: ScreenDimension.onePercentOfScreenHight,
                  ),

                  // Profile section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: CustomText(
                            text: "PROFILE",
                            fontColor: AppColors.textColorPrimary,
                            fontSize: ScreenDimension.textSize *
                                AppDimensions.TEXTSIZE_1_3,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: ScreenDimension.onePercentOfScreenHight *
                                  AppDimensions.TEXTSIZE_2_3,
                              child: Image.asset(
                                lpaiImage2,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: ScreenDimension.onePercentOfScreenWidth *
                                  AppDimensions.WIDTH2,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: loginMaster.first.firstName,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w600,
                                    fontColor: AppColors.textColorPrimary,
                                    fontSize: ScreenDimension.textSize *
                                        AppDimensions.TEXTSIZE_1_5,
                                  ),
                                  CustomText(
                                    text: "===",
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w400,
                                    fontColor: AppColors.textColorPrimary,
                                    fontSize: ScreenDimension.textSize *
                                        AppDimensions.TEXTSIZE_1_3,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  widget.onDrawerCloseIcon();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const LoginPageNew(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: SvgPicture.asset(
                                  logout,
                                  height:
                                      ScreenDimension.onePercentOfScreenHight *
                                          AppDimensions.ICONSIZE_2_6,
                                )),
                            SizedBox(
                              width: ScreenDimension.onePercentOfScreenWidth *
                                  AppDimensions.WIDTH6,
                            ),
                            SvgPicture.asset(
                              more,
                              height: ScreenDimension.onePercentOfScreenHight *
                                  AppDimensions.ICONSIZE_2_6,
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: ScreenDimension.onePercentOfScreenHight,
                  ),

                  // Services section with search and menus
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: CustomText(
                            text: "SERVICES",
                            fontColor: AppColors.textColorPrimary,
                            fontSize: ScreenDimension.textSize *
                                AppDimensions.TEXTSIZE_1_3,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),
                      ),
                      Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            // Search field
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
                              onPress: () {},
                              readOnly: false,
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              fillColor: AppColors.white,
                              textInputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              hintTextcolor: AppColors.black.withOpacity(0.7),
                              verticalPadding: 0,
                              maxLength: 15,
                              fontSize: ScreenDimension.textSize *
                                  AppDimensions.TEXTSIZE_1_8,
                              circularCorner:
                                  ScreenDimension.onePercentOfScreenWidth *
                                      AppDimensions.CIRCULARBORDER,
                              boxHeight:
                                  ScreenDimension.onePercentOfScreenHight *
                                      AppDimensions.HEIGHT6,
                              isDigitsOnly: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please fill out this field";
                                } else {
                                  return null;
                                }
                              },
                            ),

                            SizedBox(
                              height: ScreenDimension.onePercentOfScreenHight,
                            ),

                            // Dynamic menu items
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              child: Column(
                                children: filteredMenuItems.isEmpty
                                    ? [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: CustomText(
                                            text: "No menu items found",
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w500,
                                            fontColor:
                                                AppColors.textColorSecondary,
                                            fontSize: ScreenDimension.textSize *
                                                AppDimensions.TEXTSIZE_1_5,
                                          ),
                                        )
                                      ]
                                    : filteredMenuItems
                                        .map((menuItem) =>
                                            _buildMenuItemWithSubmenu(menuItem))
                                        .toList(),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: ScreenDimension.onePercentOfScreenHight,
                  ),

                  // App info section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: CustomText(
                            text: "APP INFO",
                            fontColor: AppColors.textColorPrimary,
                            fontSize: ScreenDimension.textSize *
                                AppDimensions.TEXTSIZE_1_3,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),
                      ),
                      Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 0),
                        decoration: BoxDecoration(
                          color: AppColors.lightPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          manual,
                                          height: ScreenDimension
                                                  .onePercentOfScreenHight *
                                              AppDimensions.ICONSIZE3,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        CustomText(
                                          text: "Product Manual",
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          fontColor: AppColors.textColorPrimary,
                                          fontSize: ScreenDimension.textSize *
                                              AppDimensions.TEXTSIZE_1_5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          comments,
                                          height: ScreenDimension
                                                  .onePercentOfScreenHight *
                                              AppDimensions.ICONSIZE3,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        CustomText(
                                          text: "FAQ",
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          fontColor: AppColors.textColorPrimary,
                                          fontSize: ScreenDimension.textSize *
                                              AppDimensions.TEXTSIZE_1_5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () async {
                                        widget.onDrawerCloseIcon();
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            info,
                                            height: ScreenDimension
                                                    .onePercentOfScreenHight *
                                                AppDimensions.ICONSIZE3,
                                            color: AppColors.textColorPrimary,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          CustomText(
                                            text: "App release note",
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w500,
                                            fontColor:
                                                AppColors.textColorPrimary,
                                            fontSize: ScreenDimension.textSize *
                                                AppDimensions.TEXTSIZE_1_5,
                                          ),
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

          // Footer
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
                  fontColor: AppColors.textColorSecondary,
                  fontSize:
                      ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,
                ),
                CustomText(
                  text: "App Build 1.0.0",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontColor: AppColors.textColorSecondary,
                  fontSize:
                      ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItemWithSubmenu(MenuData menuItem) {
    bool isMenuExpanded = expandedMenus[menuItem.title] ?? false;
    bool isSelected = selectedMenuTitle == menuItem.title;

    if (searchQuery.isNotEmpty && menuItem.hasSubmenu) {
      final hasMatchingSubmenu = menuItem.submenuItems.any((submenu) =>
          submenu.title.toLowerCase().contains(searchQuery.toLowerCase()));
      if (hasMatchingSubmenu) {
        isMenuExpanded = true;
      }
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: menuItem.hasSubmenu
                        ? () {
                            setState(() {
                              // Toggle the expansion state of this menu
                              expandedMenus[menuItem.title] = !isMenuExpanded;
                              // Set as selected parent menu
                              selectedMenuTitle = menuItem.title;
                              // Clear submenu selection when parent is clicked
                              selectedSubmenuTitle = null;
                            });
                          }
                        : () {
                            // Handle navigation for menu items without submenus
                            setState(() {
                              selectedMenuTitle = menuItem.title;
                              selectedSubmenuTitle = null;
                            });
                            widget.onDrawerCloseIcon();
                            if (menuItem.onTap != null) {
                              menuItem.onTap!();
                            }
                          },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          menuItem.icon,
                          height: ScreenDimension.onePercentOfScreenHight *
                              AppDimensions.ICONSIZE3,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textColorPrimary,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: CustomText(
                            text: menuItem.title,
                            textAlign: TextAlign.left,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontColor: isSelected
                                ? AppColors.primary
                                : AppColors.textColorPrimary,
                            fontSize: ScreenDimension.textSize *
                                AppDimensions.TEXTSIZE_1_5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (menuItem.hasSubmenu)
                  InkWell(
                    onTap: () {
                      setState(() {
                        // Toggle the expansion state of this menu
                        expandedMenus[menuItem.title] = !isMenuExpanded;
                        // Set as selected parent menu when clicked
                        selectedMenuTitle = menuItem.title;
                      });
                    },
                    child: SvgPicture.asset(
                      isMenuExpanded ? circleUp : circleDown,
                      height: ScreenDimension.onePercentOfScreenHight *
                          AppDimensions.ICONSIZE3,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textColorPrimary,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (menuItem.hasSubmenu && isMenuExpanded)
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Stack(
              children: [
                // Vertical indentation line
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 1,
                  child: Container(
                    width: 2,
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var submenu in menuItem.submenuItems)
                      // If searching, only show matching submenu items
                      if (searchQuery.isEmpty ||
                          submenu.title
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            color: selectedSubmenuTitle == submenu.title
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedSubmenuTitle = submenu.title;
                                  selectedMenuTitle = menuItem.title;
                                });
                                widget.onDrawerCloseIcon();
                                if (submenu.onTap != null) {
                                  submenu.onTap!();
                                }
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    submenu.icon,
                                    height: ScreenDimension
                                            .onePercentOfScreenHight *
                                        AppDimensions.ICONSIZE3,
                                    color: selectedSubmenuTitle == submenu.title
                                        ? AppColors.primary
                                        : AppColors.textColorPrimary,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: CustomText(
                                      text: submenu.title,
                                      textAlign: TextAlign.start,
                                      fontWeight:
                                          selectedSubmenuTitle == submenu.title
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                      fontColor:
                                          selectedSubmenuTitle == submenu.title
                                              ? AppColors.primary
                                              : AppColors.textColorPrimary,
                                      fontSize: ScreenDimension.textSize *
                                          AppDimensions.TEXTSIZE_1_4,
                                    ),
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
      ],
    );
  }
}

class MenuData {
  final String title;
  final String icon;
  final bool hasSubmenu;
  final List<SubmenuItem> submenuItems;
  final VoidCallback? onTap;

  MenuData({
    required this.title,
    required this.icon,
    this.hasSubmenu = false,
    this.submenuItems = const [],
    this.onTap,
  });
}

class SubmenuItem {
  final String title;
  final String icon;
  final String route;
  final VoidCallback? onTap;

  SubmenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.onTap,
  });
}

// class AppDrawer extends StatefulWidget {
//   final VoidCallback onDrawerCloseIcon;
//
//   const AppDrawer({super.key, required this.onDrawerCloseIcon});
//
//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }
//
// class _AppDrawerState extends State<AppDrawer> {
//   TextEditingController searchEditingController = TextEditingController();
//   FocusNode searchFocusNode = FocusNode();
//
//   bool isImportExpanded = false;
//   bool isExportExpanded = false;
//   String searchQuery = "";
//
//   // Define menu structure with submenus
//   final List<MenuData> allMenuItems = [
//     MenuData(
//       title: "Dashboard",
//       icon: dashboard,
//       hasSubmenu: false,
//     ),
//     MenuData(
//       title: "Import",
//       icon: importSvg,
//       hasSubmenu: true,
//       submenuItems: [
//         SubmenuItem(title: "Create Import", route: '/import/create'),
//         SubmenuItem(title: "View Import", route: '/import/view'),
//         SubmenuItem(title: "Import Status", route: '/import/status'),
//       ],
//     ),
//     MenuData(
//       title: "Export",
//       icon: exportSvg,
//       hasSubmenu: true,
//       submenuItems: [
//         SubmenuItem(title: "Create Export", route: '/export/create'),
//         SubmenuItem(title: "View Export", route: '/export/view'),
//         SubmenuItem(title: "Export Reports", route: '/export/reports'),
//       ],
//     ),
//   ];
//
//   List<MenuData> get filteredMenuItems {
//     if (searchQuery.isEmpty) {
//       return allMenuItems;
//     }
//
//     return allMenuItems.where((menu) {
//       if (menu.title.toLowerCase().contains(searchQuery.toLowerCase())) {
//         return true;
//       }
//       if (menu.hasSubmenu) {
//         return menu.submenuItems.any((submenu) =>
//             submenu.title.toLowerCase().contains(searchQuery.toLowerCase()));
//       }
//
//       return false;
//     }).toList();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     searchEditingController.addListener(_onSearchChanged);
//   }
//
//   @override
//   void dispose() {
//     searchEditingController.removeListener(_onSearchChanged);
//     searchEditingController.dispose();
//     searchFocusNode.dispose();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     setState(() {
//       searchQuery = searchEditingController.text;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: double.infinity,
//       width: MediaQuery.of(context).size.width * 0.90,
//       color: AppColors.white,
//       child: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header with logo and close button
//                   Container(
//                     padding: const EdgeInsets.only(left: 10, right: 20, top: 48, bottom: 12),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Image.asset(lpaiImage2, height: ScreenDimension.onePercentOfScreenHight * 7,),
//                             SizedBox(width: ScreenDimension.onePercentOfScreenWidth*1,),
//                             Text.rich(
//                               TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: "Land Ports \n",
//                                     style:TextStyle(
//                                       fontSize: ScreenDimension.textSize *AppDimensions.bodyTextLarge,
//                                       color: const Color(0xff266d96),
//                                       fontWeight: FontWeight.w800,
//                                       height: 1.0,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: "Authority of India\n",
//                                     style:  TextStyle(
//                                       fontSize: ScreenDimension.textSize * AppDimensions.bodyTextLarge,
//                                       color: const Color(0xff266d96),
//                                       fontWeight: FontWeight.w800,
//                                       height: 1.0,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: "Systematic Seamless Secure",
//                                     style:  TextStyle(
//                                       fontSize: ScreenDimension.textSize * 1.0,
//                                       color: AppColors.textColorPrimary,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           ],
//                         ),
//                         InkWell(
//                             onTap: widget.onDrawerCloseIcon,
//                             child: SvgPicture.asset(cancel, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.HEIGHT3,))
//                       ],
//                     ),
//                   ),
//
//                   CustomDivider(
//                     space: 0,
//                     color: AppColors.textColorPrimary,
//                     hascolor: true,
//                     thickness: 1,
//                   ),
//
//                   SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
//
//                   // Profile section
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20.0),
//                         child: CustomText(
//                             text: "PROFILE",
//                             fontColor: AppColors.textColorPrimary,
//                             fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3,
//                             fontWeight: FontWeight.w500,
//                             textAlign: TextAlign.start
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(0.18),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               radius: ScreenDimension.onePercentOfScreenHight * AppDimensions.TEXTSIZE_2_3,
//                               child: Image.asset(lpaiImage2, fit: BoxFit.cover,),
//                             ),
//                             SizedBox(width: ScreenDimension.onePercentOfScreenWidth * AppDimensions.WIDTH2,),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomText(
//                                     text: loginMaster.first.firstName,
//                                     textAlign: TextAlign.center,
//                                     fontWeight: FontWeight.w600,
//                                     fontColor: AppColors.textColorPrimary,
//                                     fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                   CustomText(
//                                     text: "===",
//                                     textAlign: TextAlign.center,
//                                     fontWeight: FontWeight.w400,
//                                     fontColor: AppColors.textColorPrimary,
//                                     fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3,),
//                                 ],
//                               ),
//                             ),
//                             InkWell(
//                                 onTap: () {
//                                   widget.onDrawerCloseIcon();
//                                   Navigator.push(context, CupertinoPageRoute(builder: (context) => const ImportScreen(),));
//                                 },
//                                 child: SvgPicture.asset(logout, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE_2_6,)),
//                             SizedBox(width: ScreenDimension.onePercentOfScreenWidth * AppDimensions.WIDTH6,),
//                             SvgPicture.asset(more, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE_2_6,)
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//
//                   SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
//
//                   // Services section with search and menus
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20.0),
//                         child: CustomText(
//                             text: "SERVICES",
//                             fontColor: AppColors.textColorPrimary,
//                             fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3,
//                             fontWeight: FontWeight.w500,
//                             textAlign: TextAlign.start
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//                         decoration: BoxDecoration(
//                           color: AppColors.background,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           children: [
//                             // Search field
//                             GroupIdCustomTextField(
//                               controller: searchEditingController,
//                               focusNode: searchFocusNode,
//                               hasIcon: true,
//                               hastextcolor: true,
//                               animatedLabel: false,
//                               needOutlineBorder: true,
//                               isShowPrefixIcon: true,
//                               isIcon: true,
//                               isSearch: true,
//                               prefixIconcolor: AppColors.black,
//                               hintText: "Search Menu",
//                               onPress: () {},
//                               readOnly: false,
//                               onChanged: (value) {
//                                 setState(() {
//                                   searchQuery = value;
//                                 });
//                               },
//                               fillColor: AppColors.white,
//                               textInputType: TextInputType.text,
//                               inputAction: TextInputAction.next,
//                               hintTextcolor: AppColors.black.withOpacity(0.7),
//                               verticalPadding: 0,
//                               maxLength: 15,
//                               fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_8,
//                               circularCorner: ScreenDimension.onePercentOfScreenWidth * AppDimensions.CIRCULARBORDER,
//                               boxHeight: ScreenDimension.onePercentOfScreenHight * AppDimensions.HEIGHT6,
//                               isDigitsOnly: false, // Changed to false for text search
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return "Please fill out this field";
//                                 } else {
//                                   return null;
//                                 }
//                               },
//                             ),
//
//                             SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
//
//                             // Menu items
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                               child: Column(
//                                 children: [
//                                   for (var menuItem in filteredMenuItems)
//                                     _buildMenuItemWithSubmenu(menuItem),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//
//                   SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
//
//                   // App info section
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20.0),
//                         child: CustomText(
//                             text: "APP INFO",
//                             fontColor: AppColors.textColorPrimary,
//                             fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3,
//                             fontWeight: FontWeight.w500,
//                             textAlign: TextAlign.start
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
//                         decoration: BoxDecoration(
//                           color: AppColors.lightPurple,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         SvgPicture.asset(manual, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3,),
//                                         SizedBox(width: 20,),
//                                         CustomText(
//                                           text: "Product Manual",
//                                           textAlign: TextAlign.center,
//                                           fontWeight: FontWeight.w500,
//                                           fontColor: AppColors.textColorPrimary,
//                                           fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 5,),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         SvgPicture.asset(comments, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3,),
//                                         SizedBox(width: 12,),
//                                         CustomText(
//                                           text: "FAQ",
//                                           textAlign: TextAlign.center,
//                                           fontWeight: FontWeight.w500,
//                                           fontColor: AppColors.textColorPrimary,
//                                           fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 5,),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: InkWell(
//                                       onTap: () async {
//                                         widget.onDrawerCloseIcon();
//                                       },
//                                       child: Row(
//                                         children: [
//                                           SvgPicture.asset(info, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3, color: AppColors.textColorPrimary,),
//                                           SizedBox(width: 15,),
//                                           CustomText(
//                                             text: "App release note",
//                                             textAlign: TextAlign.center,
//                                             fontWeight: FontWeight.w500,
//                                             fontColor: AppColors.textColorPrimary,
//                                             fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//
//           // Footer
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             color: AppColors.background,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 CustomText(
//                   text: "KLSPL",
//                   textAlign: TextAlign.center,
//                   fontWeight: FontWeight.w500,
//                   fontColor: AppColors.textColorSecondary,
//                   fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                 CustomText(
//                   text: "App Build 1.0.0",
//                   textAlign: TextAlign.center,
//                   fontWeight: FontWeight.w500,
//                   fontColor: AppColors.textColorSecondary,
//                   fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   // Build menu item with submenu support
//   Widget _buildMenuItemWithSubmenu(MenuData menuItem) {
//     bool isMenuExpanded = menuItem.title == "Import" ? isImportExpanded :
//     menuItem.title == "Export" ? isExportExpanded : false;
//
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   SvgPicture.asset(
//                     menuItem.icon,
//                     height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3,
//                   ),
//                   SizedBox(width: 20),
//                   CustomText(
//                     text: menuItem.title,
//                     textAlign: TextAlign.center,
//                     fontWeight: FontWeight.w500,
//                     fontColor: AppColors.textColorPrimary,
//                     fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,
//                   ),
//                 ],
//               ),
//               if (menuItem.hasSubmenu)
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       if (menuItem.title == "Import") {
//                         isImportExpanded = !isImportExpanded;
//                         if (isImportExpanded) isExportExpanded = false;
//                       } else if (menuItem.title == "Export") {
//                         isExportExpanded = !isExportExpanded;
//                         if (isExportExpanded) isImportExpanded = false;
//                       }
//                     });
//                   },
//                   child: SvgPicture.asset(
//                     isMenuExpanded ? circleUp : circleDown,
//                     height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//
//         // Show submenu items if expanded
//         if (menuItem.hasSubmenu && isMenuExpanded)
//           Container(
//             margin: EdgeInsets.only(left: 35),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 for (var submenu in menuItem.submenuItems)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//                     child: InkWell(
//                       onTap: () {
//                         widget.onDrawerCloseIcon();
//
//                       },
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.arrow_right,
//                             size: 20,
//                             color: AppColors.textColorPrimary,
//                           ),
//                           SizedBox(width: 10),
//                           CustomText(
//                             text: submenu.title,
//                             textAlign: TextAlign.start,
//                             fontWeight: FontWeight.w400,
//                             fontColor: AppColors.textColorPrimary,
//                             fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }
//
// class MenuData {
//   final String title;
//   final String icon;
//   final bool hasSubmenu;
//   final List<SubmenuItem> submenuItems;
//
//   MenuData({
//     required this.title,
//     required this.icon,
//     this.hasSubmenu = false,
//     this.submenuItems = const [],
//   });
// }
//
// class SubmenuItem {
//   final String title;
//   final String route;
//
//   SubmenuItem({
//     required this.title,
//     required this.route,
//   });
// }

// class AppDrawer extends StatefulWidget {
//
//   final VoidCallback onDrawerCloseIcon;
//
//   const AppDrawer({super.key,
//  required this.onDrawerCloseIcon});
//
//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }
//
// class _AppDrawerState extends State<AppDrawer> {
//
//   TextEditingController searchEditingController = TextEditingController();
//   FocusNode searchFocusNode = FocusNode();
//
//   bool isImportExpanded = false;
//   bool isExportExpanded = false;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: double.infinity,
//       width: MediaQuery.of(context).size.width * 0.90, // Set to 75% of screen width
//       color: AppColors.white,
//       child: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.only(left: 10, right: 20, top: 48, bottom: 12),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Image.asset(lpaiImage2, height: ScreenDimension.onePercentOfScreenHight * 7,),
//                             SizedBox(width: ScreenDimension.onePercentOfScreenWidth*1,),
//                             Text.rich(
//                               TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: "Land Ports \n",
//                                     style:TextStyle(
//                                       fontSize: ScreenDimension.textSize *AppDimensions. bodyTextLarge,
//                                       color: const Color(0xff266d96),
//                                       fontWeight: FontWeight.w800,
//                                       height: 1.0,
//                                     ),
//
//                                   ),
//                                   TextSpan(
//                                     text: "Authority of India\n",
//                                     style:  TextStyle(
//                                       fontSize: ScreenDimension.textSize * AppDimensions.bodyTextLarge,
//                                       color: const Color(0xff266d96),
//                                       fontWeight: FontWeight.w800,
//                                       height: 1.0,
//
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: "Systematic Seamless Secure",
//                                     style:  TextStyle(
//                                       fontSize: ScreenDimension.textSize * 1.0,
//                                       color: AppColors.textColorPrimary,
//                                       fontWeight: FontWeight.w600,
//
//                                     ),
//                                   ),
//
//                                 ],
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           ], ),
//                         // Image.asset(lpaiImage, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.HEIGHT6, fit: BoxFit.cover,),
//                         InkWell(
//                             onTap: widget.onDrawerCloseIcon,
//                             child: SvgPicture.asset(cancel, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.HEIGHT3,))
//                       ],
//                     ),
//                   ),
//                   CustomDivider(
//                     space: 0,
//                     color: AppColors.textColorPrimary,
//                     hascolor: true,
//                     thickness: 1,
//                   ),
//                   SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20.0),
//                         child: CustomText(text: "PROFILE", fontColor: AppColors.textColorPrimary, fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
//                       ),
//                       Container(
//                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(0.18),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               radius: ScreenDimension.onePercentOfScreenHight *  AppDimensions.TEXTSIZE_2_3,
//                               child: Image.asset(lpaiImage2,fit: BoxFit.cover,),
//                             ),
//                             SizedBox(width: ScreenDimension.onePercentOfScreenWidth * AppDimensions.WIDTH2,),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomText(
//                                     text: loginMaster.first.firstName,
//                                     textAlign: TextAlign.center,
//                                     fontWeight: FontWeight.w600,
//                                     fontColor:  AppColors.textColorPrimary,
//                                     fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                   CustomText(
//                                     text: "===",
//                                     textAlign: TextAlign.center,
//                                     fontWeight: FontWeight.w400,
//                                     fontColor:  AppColors.textColorPrimary,
//                                     fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3,),
//                                 ],
//                               ),
//                             ),
//                             InkWell(
//                                 onTap: () {
//                                   widget.onDrawerCloseIcon();
//                                   Navigator.push(context, CupertinoPageRoute(builder: (context) => const ImportScreen(),));
//                                 },
//                                 child: SvgPicture.asset(logout, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE_2_6 ,)),
//                             SizedBox(width: ScreenDimension.onePercentOfScreenWidth * AppDimensions.WIDTH6,),
//                             SvgPicture.asset(more, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE_2_6 ,)
//                           ],
//                         ),
//
//
//
//                       )
//                     ],
//                   ),
//                   SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20.0),
//                         child: CustomText(text: "SERVICES", fontColor: AppColors.textColorPrimary, fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//                         decoration: BoxDecoration(
//                           color: AppColors.background,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           children: [
//                             GroupIdCustomTextField(
//                               controller: searchEditingController,
//                               focusNode: searchFocusNode,
//                               hasIcon: true,
//                               hastextcolor: true,
//                               animatedLabel: false,
//                               needOutlineBorder: true,
//                               isShowPrefixIcon: true,
//                               isIcon: true,
//                               isSearch: true,
//                               prefixIconcolor: AppColors.black,
//                               hintText: "Search Menu",
//                               onPress: () {},
//                               readOnly: false,
//                               onChanged: (value) async {
//
//                               },
//                               fillColor: AppColors.white,
//                               textInputType: TextInputType.text,
//                               inputAction: TextInputAction.next,
//                               hintTextcolor: AppColors.black.withOpacity(0.7),
//                               verticalPadding: 0,
//                               maxLength: 15,
//                               fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_8,
//                               circularCorner: ScreenDimension.onePercentOfScreenWidth * AppDimensions.CIRCULARBORDER,
//                               boxHeight: ScreenDimension.onePercentOfScreenHight * AppDimensions.HEIGHT6,
//                               isDigitsOnly: true,
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return "Please fill out this field";
//                                 } else {
//                                   return null;
//                                 }
//                               },
//                             ),
//                             SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         SvgPicture.asset(dashboard, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
//                                         SizedBox(width: 15,),
//                                         CustomText(
//                                           text: "Dashboard",
//                                           textAlign: TextAlign.center,
//                                           fontWeight: FontWeight.w500,
//                                           fontColor:  AppColors.textColorPrimary,
//                                           fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10,),
//                                   /* Container(
//                                     decoration: BoxDecoration(
//                                       color: (isImportExpanded) ? AppColors.cardTextColor : AppColors.background,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: _buildMenuItem(
//                                         icon: importSvg,
//                                         title: "Import (${widget.importSubMenuList!.length})",
//                                         isMenuExpanded: isImportExpanded,
//                                         onIconTap: () {
//                                           setState(() {
//                                             isImportExpanded = !isImportExpanded;
//                                           });
//                                         },
//                                         subMenuList: isImportExpanded ? widget.importSubMenuList : null,
//
//                                       ),
//                                     ),
//                                   ),*/
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//
//                                         Row(
//                                           children: [
//                                             SvgPicture.asset(exportSvg, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
//                                             SizedBox(width: 20,),
//                                             CustomText(
//                                               text: "Import",
//                                               textAlign: TextAlign.center,
//                                               fontWeight: FontWeight.w500,
//                                               fontColor:  AppColors.textColorPrimary,
//                                               fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                           ],
//                                         ),
//                                         SvgPicture.asset(circleDown, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
//
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 10,),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//
//                                         Row(
//                                           children: [
//                                             SvgPicture.asset(exportSvg, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
//                                             const SizedBox(width: 20,),
//                                             CustomText(
//                                               text: "Export ",
//                                               textAlign: TextAlign.center,
//                                               fontWeight: FontWeight.w500,
//                                               fontColor:  AppColors.textColorPrimary,
//                                               fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                           ],
//                                         ),
//                                         SvgPicture.asset(circleDown, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
//
//                                       ],
//                                     ),
//                                   ),
//
//
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//
//
//
//                       )
//                     ],
//                   ),
//                   SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20.0),
//                         child: CustomText(text: "APP INFO", fontColor: AppColors.textColorPrimary, fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
//                         decoration: BoxDecoration(
//                           color: AppColors.lightPurple,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         SvgPicture.asset(manual, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
//                                         SizedBox(width: 20,),
//                                         CustomText(
//                                           text: "Product Manual",
//                                           textAlign: TextAlign.center,
//                                           fontWeight: FontWeight.w500,
//                                           fontColor:  AppColors.textColorPrimary,
//                                           fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 5,),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         SvgPicture.asset(comments, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3 ,),
//                                         SizedBox(width: 12,),
//                                         CustomText(
//                                           text: "FAQ",
//                                           textAlign: TextAlign.center,
//                                           fontWeight: FontWeight.w500,
//                                           fontColor:  AppColors.textColorPrimary,
//                                           fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 5,),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: InkWell(
//                                       onTap: () async {
//                                         widget.onDrawerCloseIcon();
//                                         // final releaseNoteModel = await loadReleaseNotes();
//                                         // showDialog(
//                                         //   context: context,
//                                         //   barrierDismissible: false,
//                                         //   builder: (BuildContext context) {
//                                         //     return ReleaseNoteDialog(releaseNoteModel: releaseNoteModel);
//                                         //   },
//                                         // );
//
//                                       },
//
//                                       child: Row(
//                                         children: [
//                                           SvgPicture.asset(info, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3, color: AppColors.textColorPrimary ,),
//                                           SizedBox(width: 15,),
//                                           CustomText(
//                                             text: "App release note",
//                                             textAlign: TextAlign.center,
//                                             fontWeight: FontWeight.w500,
//                                             fontColor:  AppColors.textColorPrimary,
//                                             fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//
//
//
//                       )
//                     ],
//                   )
//
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             color: AppColors.background,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 CustomText(
//                   text: "KLSPL",
//                   textAlign: TextAlign.center,
//                   fontWeight: FontWeight.w500,
//                   fontColor:  AppColors.textColorSecondary,
//                   fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//                 CustomText(
//                   text: "App Build 1.0.0",
//                   textAlign: TextAlign.center,
//                   fontWeight: FontWeight.w500,
//                   fontColor:  AppColors.textColorSecondary,
//                   fontSize: ScreenDimension.textSize * AppDimensions.TEXTSIZE_1_5,),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//
//
// }
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
      this.color = AppColors.black,
      this.hascolor = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
            color: hascolor == true
                ? color.withOpacity(0.2)
                : color.withOpacity(0),
            height: height,
            thickness: thickness),
      ],
    );
  }
}
