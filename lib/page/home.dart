import 'dart:developer';

import 'package:clocker/item/appbar.dart';
import 'package:clocker/item/clock.dart';
import 'package:clocker/page/tabbar.dart';
import 'package:clocker/provider/log_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../helper/statusdetail.dart';
import '../helper/text_field.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff19171A),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Consumer<LogProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    Appbars(),
                    SizedBox(height: height * 0.05),
                    const ClockView(),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    AnimatedToggle(
                        values: const ["Manual", "Auto"],
                        onToggleCallback: (value) {
                          provider.changeTab(value);
                        },
                        toggleValueController: controller),
                    provider.tabValue == 0
                        ? !provider.isCalculate
                            ? SizedBox(
                                height: height * 0.6,
                                width: width,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 7 / 2,
                                  ),
                                  itemCount: provider.fieldList.length + 1,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: GestureDetector(
                                                onTap: () {
                                                  showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  ).then((value) {
                                                    String time =
                                                        '${value!.hour}:${value.minute}';
                                                    provider.addNewLog(
                                                        time, index);
                                                  });
                                                },
                                                child: VTextField(
                                                  index: index,
                                                  text: provider
                                                          .fieldList.isNotEmpty
                                                      ? index <
                                                              provider.fieldList
                                                                  .length
                                                          ? provider
                                                              .fieldList[index]
                                                          : ''
                                                      : '',
                                                )),
                                          ),
                                          if (index ==
                                              provider.fieldList.length)
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              flex: 1,
                                            )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : StatusDetail(
                                effectiveHour: '${provider.effectiveHour!}',
                                isWorkDone: provider.isWorkDone,
                                reamingTime: '${provider.reamingTime}',
                                totalHour: '${provider.totalHour}',
                              )
                        : !provider.isCalculate
                            ? Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xff6C6B70),
                                    ),
                                    child: TextFormField(
                                      controller: provider.autoTextController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              )
                            : StatusDetail(
                                effectiveHour: '${provider.effectiveHour!}',
                                isWorkDone: provider.isWorkDone,
                                reamingTime: '${provider.reamingTime}',
                                totalHour: '${provider.totalHour}',
                              ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<LogProvider>(
            builder: (context, provider, child) => GestureDetector(
              onTap: !provider.isCalculate
                  ? () {
                      provider.tabValue == 0
                          ? provider.calculateTime()
                          : provider.autoCalculateTime();
                    }
                  : () {
                      provider.recheck();
                    },
              child: Container(
                width: width,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xff6C6B70),
                ),
                child: !provider.isCalculate
                    ? const Text(
                        'Calculate',
                        textAlign: TextAlign.center,
                      )
                    : const Text(
                        'Re-check',
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ),
        ));
  }
}
