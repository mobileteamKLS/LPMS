import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:lpms/theme/app_color.dart';

import '../../models/ShippingList.dart';
import '../../screens/ShipmentDetails.dart';
import '../../screens/VehicleDetails.dart';
import '../../util/Global.dart';
import 'CustomTextField.dart';

// class RecursiveDrawerItem extends StatelessWidget {
//   final List categories;
//
//
//   RecursiveDrawerItem({Key? key, required this.categories}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: categories.length,
//       itemBuilder: (BuildContext context, int index) {
//         final category = categories[index];
//
//
//         return category['sub_categories'].isEmpty
//             ? ListTile(
//                 title: Text(
//                   category['name'],
//                   textAlign: TextAlign.start,
//                 ),
//               )
//             : ExpansionTileCard(
//                 animateTrailing: true,
//                 elevation: 0.0,
//                 expandedColor: Colors.white,
//                 shadowColor: Colors.white,
//                 baseColor: Colors.white,
//                 title: Text(
//                   category['name'],
//                   textAlign: TextAlign.start,
//                 ),
//                 children: <Widget>[
//                   SizedBox(
//                     child: RecursiveDrawerItem(
//                         categories: category['sub_categories']),
//                   )
//                 ],
//               );
//       },
//     );
//   }
// }

// class RecursiveDrawerItemV2 extends StatefulWidget {
//   final List categories;
//
//   const RecursiveDrawerItemV2({super.key, required this.categories});
//
//   @override
//   _RecursiveDrawerItemStateV2 createState() => _RecursiveDrawerItemStateV2();
// }
//
// class _RecursiveDrawerItemStateV2 extends State<RecursiveDrawerItemV2> {
//   List<bool> expanded = [];
//
//   @override
//   void initState() {
//     super.initState();
//     expanded = List.generate(widget.categories.length, (index) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       separatorBuilder: (context, index) => SizedBox(height: 2),
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: widget.categories.length,
//       itemBuilder: (BuildContext context, int index) {
//         final category = widget.categories[index];
//         final hasSubCategories = category['sub_categories'].isNotEmpty;
//
//         return Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 if (hasSubCategories) {
//                   setState(() {
//                     expanded[index] = !expanded[index];
//                   });
//                 }
//               },
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 color: Colors.white,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Shipping Bill No/ Date",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         const Icon(Icons.edit, color: AppColors.primary),
//                         // Edit icon
//                         const SizedBox(width: 10),
//                         Icon(
//                           expanded[index]
//                               ? Icons.keyboard_arrow_up
//                               : Icons.keyboard_arrow_down,
//                           color: Colors.grey,
//                         ),
//                         // Expand/Collapse icon
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (expanded[index])
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16.0,
//                 ),
//                 color: Colors.white,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       category['name'],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     Text(
//                       category['name'],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

class RecursiveDrawerItemV2 extends StatefulWidget {
  final List categories;

  const RecursiveDrawerItemV2({super.key, required this.categories});

  @override
  _RecursiveDrawerItemStateV2 createState() => _RecursiveDrawerItemStateV2();
}

class _RecursiveDrawerItemStateV2 extends State<RecursiveDrawerItemV2> {
  List<bool> expanded = [];

  @override
  void initState() {
    super.initState();
    expanded = List.generate(widget.categories.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 2),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.categories.length,
      itemBuilder: (BuildContext context, int index) {
        final category = widget.categories[index];
        final hasSubCategories = category['sub_categories'].isNotEmpty;

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                if (hasSubCategories) {
                  setState(() {
                    expanded[index] = !expanded[index];
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Shipping Bill No/ Date",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.edit, color: AppColors.primary),
                        // Edit icon
                        const SizedBox(width: 10),
                        Icon(
                          expanded[index]
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        // Expand/Collapse icon
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (expanded[index])
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      category['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class RecursiveDrawerItemV2New extends StatefulWidget {
  final List<ShipmentDetails> shipmentDetailsList;

  const RecursiveDrawerItemV2New(
      {super.key, required this.shipmentDetailsList});

  @override
  _RecursiveDrawerItemStateV2New createState() =>
      _RecursiveDrawerItemStateV2New();
}

class _RecursiveDrawerItemStateV2New extends State<RecursiveDrawerItemV2New> {
  List<bool> expanded = [];

  @override
  void initState() {
    super.initState();
    expanded =
        List.generate(widget.shipmentDetailsList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 2),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.shipmentDetailsList.length,
      itemBuilder: (BuildContext context, int index) {
        final shipmentDetails = widget.shipmentDetailsList[index];

        return Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Shipping Bill No/ Date",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorSecondary,
                        ),
                      ),
                      Text(
                        "${shipmentDetails.billNo}/${shipmentDetails.billDate}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColorPrimary,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(Icons.edit,
                                  size: 28, color: AppColors.primary)),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expanded[index] = !expanded[index];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.gradient1,
                              ),
                              child: Icon(
                                size: 28,
                                expanded[index]
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (expanded[index])
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShipmentInfoRow(
                      header1: "Exporter Name",
                      value1: shipmentDetails.exporterName,
                      header2: "HSN Code",
                      value2: shipmentDetails.hsnCode,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Cargo Type",
                      value1: shipmentDetails.cargoType,
                      header2: "Cargo Description",
                      value2: shipmentDetails.cargoDescription,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Quantity",
                      value1: shipmentDetails.quality,
                      header2: "Cargo Weight",
                      value2: shipmentDetails.cargoWeight,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Cargo Value",
                      value1: shipmentDetails.cargoValue,
                      header2: "",
                      value2: "",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class AddShipmentDetailsListNew extends StatefulWidget {
  final List<ShipmentDetails> shipmentDetailsList;

  const AddShipmentDetailsListNew({
    super.key,
    required this.shipmentDetailsList,
  });

  @override
  _AddShipmentDetailsListNew createState() => _AddShipmentDetailsListNew();
}

class _AddShipmentDetailsListNew extends State<AddShipmentDetailsListNew> {
  List<bool> expanded = [];
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    expanded =
        List.generate(widget.shipmentDetailsList.length, (index) => false);
    print("-----${widget.shipmentDetailsList.length}");
  }

  @override
  Widget build(BuildContext context) {

    if (widget.shipmentDetailsList.isEmpty) {
      return _buildEmptyShipmentDetails();
    } else {
      return _buildShipmentDetailsList();
    }
  }

  Widget _buildEmptyShipmentDetails() {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: AppColors.background,
            width: 4.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "SHIPMENT DETAILS",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textColorPrimary,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push<ShipmentDetails>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddShipmentDetails(),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          widget.shipmentDetailsList
                              .add(result);
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        size: 28,
                        Icons.add,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Total Count  ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorSecondary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.containerBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("0"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Method to build the widget when shipmentDetailsList is not empty
  Widget _buildShipmentDetailsList() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: (!isExpanded)
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: (!isExpanded)
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
                border: const Border(
                  bottom: BorderSide(
                    color: AppColors.background,
                    width: 4.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "SHIPMENT DETAILS",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textColorPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result =
                                  await Navigator.push<ShipmentDetails>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddShipmentDetails(),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  widget.shipmentDetailsList.add(
                                      result); // Add the ShipmentDetails object
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                size: 28,
                                Icons.add,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.gradient1,
                              ),
                              child: Icon(
                                size: 28,
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Total Count  ",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorSecondary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.containerBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                              widget.shipmentDetailsList.length.toString()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (isExpanded)
              SizedBox(
                child: RecursiveDrawerItemV2New(
                  shipmentDetailsList: shipmentList,
                ),
              ),
          ],
        )
      ],
    );
  }
}

// class AddShipmentDetailsList extends StatefulWidget {
//   final List categories;
//   final List<ShipmentDetails> shipmentDetailsList;
//
//   const AddShipmentDetailsList(
//       {super.key, required this.categories, required this.shipmentDetailsList});
//
//   @override
//   _AddShipmentDetailsList createState() => _AddShipmentDetailsList();
// }
//
// class _AddShipmentDetailsList extends State<AddShipmentDetailsList> {
//   // Tracks the expansion state of categories
//   List<bool> expanded = [];
//
//   @override
//   void initState() {
//     super.initState();
//     expanded = List.generate(widget.categories.length, (index) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.shipmentDetailsList.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
//         decoration: const BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(12),
//             topRight: Radius.circular(12),
//             bottomLeft: Radius.circular(12),
//             bottomRight: Radius.circular(12),
//           ),
//           border: Border(
//             bottom: BorderSide(
//               color: AppColors.background, // Border color
//               width: 4.0, // Border width
//             ),
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "SHIPMENT DETAILS",
//                   style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 14,
//                       color: AppColors.textColorPrimary),
//                 ),
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         final result = await Navigator.push<ShipmentDetails>(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const AddShipmentDetails(),
//                           ),
//                         );
//
//                         if (result != null) {
//                           setState(() {
//                             shipmentList
//                                 .add(result); // Add the ShipmentDetails object
//                           });
//                         }
//                       },
//                       child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           margin: const EdgeInsets.symmetric(horizontal: 8),
//                           child: const Icon(
//                               size: 28, Icons.add, color: AppColors.primary)),
//                     ),
//
//                     GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         margin: const EdgeInsets.only(left: 8),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: AppColors.gradient1),
//                         child: const Icon(
//                           size: 28,
//                           Icons.keyboard_arrow_down,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                     ),
//                     // Expand/Collapse icon
//                   ],
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 const Text(
//                   "Total Count  ",
//                   style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.textColorSecondary),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.containerBgColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     child: Text("0"),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       );
//     } else {
//       return ListView.separated(
//         separatorBuilder: (context, index) => const Divider(color: Colors.grey),
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: widget.shipmentDetailsList.length,
//         itemBuilder: (BuildContext context, int index) {
//           final category = widget.categories[index];
//           final hasSubCategories = category['sub_categories'].isNotEmpty;
//
//           return Column(
//             children: [
//               Container(
//                 padding:
//                     const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: const Radius.circular(12),
//                     topRight: const Radius.circular(12),
//                     bottomLeft: (!expanded[index])
//                         ? const Radius.circular(12)
//                         : const Radius.circular(0),
//                     bottomRight: (!expanded[index])
//                         ? const Radius.circular(12)
//                         : const Radius.circular(0),
//                   ),
//                   border: const Border(
//                     bottom: BorderSide(
//                       color: AppColors.background, // Border color
//                       width: 4.0, // Border width
//                     ),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "SHIPMENT DETAILS",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 14,
//                               color: AppColors.textColorPrimary),
//                         ),
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () async {
//                                 final result =
//                                     await Navigator.push<ShipmentDetails>(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const AddShipmentDetails(),
//                                   ),
//                                 );
//
//                                 if (result != null) {
//                                   setState(() {
//                                     shipmentList.add(
//                                         result); // Add the ShipmentDetails object
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   margin:
//                                       const EdgeInsets.symmetric(horizontal: 8),
//                                   child: const Icon(
//                                       size: 28,
//                                       Icons.add,
//                                       color: AppColors.primary)),
//                             ),
//
//                             GestureDetector(
//                               onTap: () {
//                                 if (hasSubCategories) {
//                                   setState(() {
//                                     expanded[index] = !expanded[index];
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.only(left: 8),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                     color: AppColors.gradient1),
//                                 child: Icon(
//                                   size: 28,
//                                   expanded[index]
//                                       ? Icons.keyboard_arrow_up
//                                       : Icons.keyboard_arrow_down,
//                                   color: AppColors.primary,
//                                 ),
//                               ),
//                             ),
//                             // Expand/Collapse icon
//                           ],
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           "Total Count  ",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textColorSecondary),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: AppColors.containerBgColor,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             child: Text("0"),
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//               if (expanded[index])
//                 SizedBox(
//                   child: RecursiveDrawerItemV2(
//                     categories: category['sub_categories'],
//                   ),
//                 ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }

class AddVehicleDetailsList extends StatefulWidget {
  final List categories;

  const AddVehicleDetailsList({super.key, required this.categories});

  @override
  _AddVehicleDetailsList createState() => _AddVehicleDetailsList();
}

class _AddVehicleDetailsList extends State<AddVehicleDetailsList> {
  // Tracks the expansion state of categories
  List<bool> expanded = [];

  @override
  void initState() {
    super.initState();
    expanded = List.generate(widget.categories.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(color: Colors.grey),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.categories.length,
      itemBuilder: (BuildContext context, int index) {
        final category = widget.categories[index];
        final hasSubCategories = category['sub_categories'].isNotEmpty;

        return Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: (!expanded[index])
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: (!expanded[index])
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
                border: const Border(
                  bottom: BorderSide(
                    color: AppColors.background, // Border color
                    width: 4.0, // Border width
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "VEHICLE DETAILS",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textColorPrimary),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result =
                                  await Navigator.push<ShipmentDetails>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddVehicleDetails(),
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  shipmentList.add(
                                      result); // Add the ShipmentDetails object
                                });
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: const Icon(
                                    size: 28,
                                    Icons.add,
                                    color: AppColors.primary)),
                          ),

                          GestureDetector(
                            onTap: () {
                              if (hasSubCategories) {
                                setState(() {
                                  expanded[index] = !expanded[index];
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.gradient1),
                              child: Icon(
                                size: 28,
                                expanded[index]
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          // Expand/Collapse icon
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Total Count  ",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColorSecondary),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.containerBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("0"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            if (expanded[index])
              SizedBox(
                child: RecursiveDrawerItemV2(
                  categories: category['sub_categories'],
                ),
              ),
          ],
        );
      },
    );
  }
}
