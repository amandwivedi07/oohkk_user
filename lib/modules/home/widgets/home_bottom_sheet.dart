import 'package:flutter/material.dart';
import 'package:getitgouser/shared/constants/constant.dart';
import 'package:getitgouser/shared/helper/widgets/buttons.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomeBottomSheet extends StatefulWidget {
  const MyHomeBottomSheet({super.key});

  @override
  State<MyHomeBottomSheet> createState() => _MyHomeBottomSheetState();
}

class _MyHomeBottomSheetState extends State<MyHomeBottomSheet>
    with SingleTickerProviderStateMixin {
  final ScrollController controller = ScrollController();

  late AnimationController _controller;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool tapped = false;
  bool selected = false;
  int selectedIndex = 0;
  int payindex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return SizedBox(
          height: 280,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 4),
                            blurRadius: 4)
                      ]),
                  height: 50,
                  child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.pin_drop_rounded,
                            color: Colors.red,
                          ),
                          border: InputBorder.none,
                          hintText: 'Select destination',
                          hintStyle: GoogleFonts.poppins())),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Drop Suggestions',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff666565)),
                ),
                ListTile(
                  horizontalTitleGap: 8,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: const CircleAvatar(
                    radius: 15,
                    child: Icon(Icons.watch_later_outlined),
                  ),
                  title: const Text('Charbagh Station'),
                  titleTextStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                  subtitle: const Text('Station Road, Preeti Nagar C...'),
                  subtitleTextStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff8E8989)),
                  trailing: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.favorite_border,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        constraints: BoxConstraints.tight(
                            const Size(double.infinity, 420)),
                        isScrollControlled: true,
                        useSafeArea: false,
                        showDragHandle: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                StatefulBuilder(
                                  builder: (BuildContext context, setState) {
                                    return Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ListView.builder(
                                        controller: controller,
                                        physics: const BouncingScrollPhysics(
                                            decelerationRate:
                                                ScrollDecelerationRate.normal),
                                        shrinkWrap: false,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: vehicles.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final vehicle = vehicles[index];
                                          return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedIndex =
                                                          vehicle['id'];
                                                      selected = !selected;

                                                      print(selectedIndex);
                                                    });
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    // width: 140,
                                                    // height: 135,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            width: 3,
                                                            color: selectedIndex ==
                                                                    vehicle['id']
                                                                ? AppColors.kPrimaryColor
                                                                : Colors.grey.shade400),
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              offset:
                                                                  Offset(0, 4),
                                                              blurRadius: 4,
                                                              color:
                                                                  Colors.grey)
                                                        ]),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 12),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image.asset(
                                                              scale: 1,
                                                              vehicle['img']
                                                                  .toString()),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                vehicle['name']
                                                                    .toString(),
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: selectedIndex ==
                                                                            vehicle[
                                                                                'id']
                                                                        ? AppColors
                                                                            .kPrimaryColor
                                                                        : Colors
                                                                            .black),
                                                              ),
                                                              Text(
                                                                  vehicle['seater']
                                                                      .toString(),
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: selectedIndex ==
                                                                              vehicle[
                                                                                  'id']
                                                                          ? AppColors
                                                                              .kPrimaryColor
                                                                          : Colors
                                                                              .grey)),
                                                              Text(
                                                                  vehicle['price']
                                                                      .toString(),
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: selectedIndex ==
                                                                              vehicle[
                                                                                  'id']
                                                                          ? AppColors
                                                                              .kPrimaryColor
                                                                          : Colors
                                                                              .black)),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]);
                                        },
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  height: 90,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Payment Via',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                        ListTile(
                                          visualDensity: VisualDensity.compact,
                                          onTap: () {
                                            showModalBottomSheet(
                                                shape:
                                                    const BeveledRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.zero),
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            setState) {
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Payment Methods',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            height: 90,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: ListView
                                                                .builder(
                                                              physics:
                                                                  const ClampingScrollPhysics(),
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  paymentmethods
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      index) {
                                                                final payments =
                                                                    paymentmethods[
                                                                        index];
                                                                return Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          payindex =
                                                                              payments['id'];
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        margin:
                                                                            const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5,
                                                                        ),
                                                                        height:
                                                                            60,
                                                                        width:
                                                                            60,
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.white,
                                                                            boxShadow: [
                                                                              payindex == payments['id'] ? const BoxShadow(color: Colors.grey, offset: Offset(0, 4), blurRadius: 4) : const BoxShadow(color: Colors.transparent, offset: Offset(0, 4), blurRadius: 4)
                                                                            ],
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            border: payindex == payments['id'] ? Border.all(width: 2, color: AppColors.kPrimaryColor) : Border.all(color: Colors.transparent)),
                                                                        child: Image
                                                                            .asset(
                                                                          payments['img']
                                                                              .toString(),
                                                                          fit: BoxFit
                                                                              .contain,
                                                                          width:
                                                                              70,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                      payments[
                                                                              'paythrough']
                                                                          .toString(),
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              12),
                                                                    )
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          CustomButton(
                                                              onPressed: () {},
                                                              buttonTitle:
                                                                  'Confirm'
                                                              // boxshadow: const [
                                                              //   BoxShadow(
                                                              //       color: Colors
                                                              //           .grey,
                                                              //       blurRadius:
                                                              //           4,
                                                              //       offset: Offset(
                                                              //           0,
                                                              //           4))
                                                              ),
                                                          const SizedBox(
                                                            height: 15,
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  );
                                                });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                          horizontalTitleGap: 3,
                                          leading: const CircleAvatar(
                                              radius: 28,
                                              child: Icon(
                                                Icons.monetization_on,
                                                size: 30,
                                              )),
                                          title: const Text('Cash'),
                                          titleTextStyle: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                          subtitle:
                                              const Text('Pay when trip ends'),
                                          subtitleTextStyle:
                                              GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomButton(
                                    onPressed: () {},
                                    buttonTitle: 'Confrim PickUp')
                              ],
                            ),
                          );
                        });
                  },
                ),
                ListTile(
                  horizontalTitleGap: 8,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: const CircleAvatar(
                    radius: 15,
                    child: Icon(Icons.watch_later_outlined),
                  ),
                  title: const Text('IT Metro Station'),
                  titleTextStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                  subtitle: const Text('IT Chauraha, Vishwavidyalay...'),
                  subtitleTextStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff8E8989)),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {});
                      tapped = !tapped;
                    },
                    child: tapped
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
