import 'package:clocker/helper/pref_utils.dart';
import 'package:clocker/item/appbar.dart';
import 'package:clocker/item/clock.dart';
import 'package:clocker/provider/log_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../helper/message.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();

  checkValue() async {
    bool value = await PrefUtils.getIsFirst();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: const Color(0xff19171A),
        resizeToAvoidBottomInset: false,
        body: ListView(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: width >= 794 ? 200 : 25),
            alignment: Alignment.center,
            child: Consumer<LogProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    SizedBox(height: height * 0.05),
                    Appbars(),
                    SizedBox(height: height * 0.05),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ClockView(),
                        if (provider.isCalculate && width >= 950)
                          const SizedBox(
                            width: 50,
                          ),
                        if (provider.isCalculate && width >= 950)
                          Column(
                            children: [
                              Message(
                                mess: provider.isWorkDone
                                    ? "Your Time is Over, So Please Go ASAP...!"
                                    : "Ohh Sorry, Your time is not over",
                              ),
                              if (!provider.isWorkDone)
                                Message(
                                  mess:
                                      "Effective Hour : ${provider.effectiveHour.toString().split('.').first}",
                                ),
                              if (!provider.isWorkDone)
                                Message(
                                  mess:
                                      "Remaining Time: ${provider.reamingTime.toString().split('.').first}",
                                ),
                              if (!provider.isWorkDone)
                                Message(
                                  mess:
                                      "Total Time: ${provider.totalHour.toString().split('.').first}",
                                ),
                              if (!provider.isWorkDone)
                                Message(
                                  mess:
                                      "When Leave : ${provider.whenLeaveTime.toString().split('.').first}",
                                ),
                              provider.isWorkDone
                                  ? SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Lottie.asset('assets/run2.json'),
                                    )
                                  : SizedBox(
                                      height: 200,
                                      width: 200,
                                      child:
                                          Lottie.asset('assets/workdone.json'),
                                    ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    if (!provider.isCalculate)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Your Time Log',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: height * 0.03),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 20, right: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xff6C6B70),
                            ),
                            child: TextFormField(
                              controller: provider.autoTextController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      'Copy your Log from Keka and Paste Here... (Date Format Allowed : 9:48:49 AM MISSING / 9:48:49 MISSING) '),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Row(
                            children: [
                              Checkbox(
                                value: provider.isPartial,
                                onChanged: (value) {
                                  provider.changePartial(value);
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Partial Day')
                            ],
                          ),
                          if (provider.isPartial)
                            SizedBox(height: height * 0.02),
                          if (provider.isPartial)
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xff6C6B70),
                              ),
                              child: TextFormField(
                                controller: provider.partialTextController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Partial Hour'),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          if (provider.isPartial)
                            SizedBox(height: height * 0.02),
                          Row(
                            children: [
                              Checkbox(
                                value: provider.isHalfDay,
                                onChanged: (value) {
                                  provider.changeHalfDay(value);
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Half Day')
                            ],
                          ),
                        ],
                      ),
                    if (provider.isCalculate && width < 950)
                      Column(
                        children: [
                          Message(
                            mess: provider.isWorkDone
                                ? "Your Time is Over, So Please Go ASAP...!"
                                : "Ohh Sorry, Your time is not over",
                          ),
                          if (!provider.isWorkDone)
                            Message(
                              mess:
                                  "Effective Hour : ${provider.effectiveHour.toString().split('.').first}",
                            ),
                          if (!provider.isWorkDone)
                            Message(
                              mess:
                                  "Remaing Time: ${provider.reamingTime.toString().split('.').first}",
                            ),
                          if (!provider.isWorkDone)
                            Message(
                              mess:
                                  "Total Time: ${provider.totalHour.toString().split('.').first}",
                            ),
                          if (!provider.isWorkDone)
                            Message(
                              mess:
                                  "When Leave : ${provider.whenLeaveTime.toString().split('.').first}",
                            ),
                          provider.isWorkDone
                              ? SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Lottie.asset('assets/run2.json'),
                                )
                              : SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Lottie.asset('assets/workdone.json'),
                                ),
                          if (!provider.isWorkDone)
                            const Message(
                              mess:
                                  "Time calculation made easy by Flutter Team",
                            ),
                        ],
                      ),
                    provider.isWorkDone && width >= 950
                        ? const Message(
                            mess: "Your time is over !!!",
                            color: Colors.green,
                            fontSize: 32,
                          )
                        : Container(),
                    if (provider.isCalculate && width >= 950)
                      const SizedBox(
                        height: 20,
                      ),
                    provider.isCalculate && width >= 950
                        ? const Message(
                            mess: "Time calculation made easy by Flutter Team",
                            color: Colors.blueAccent,
                          )
                        : Container(),
                    SizedBox(
                      height: height * 0.04,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 500,
          )
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: (width >= 794) ? 200 : 25),
          child: Consumer<LogProvider>(
            builder: (context, provider, child) => GestureDetector(
              onTap: !provider.isCalculate
                  ? () {
                      PrefUtils.setIsFirst(false);
                      provider.autoCalculateTime(context);
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
