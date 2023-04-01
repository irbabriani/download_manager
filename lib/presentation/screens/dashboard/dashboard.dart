import 'package:download_manager/presentation/screens/needed_packages.dart';
import 'package:download_manager/presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var txte = TextEditingController(
      text: "https://dl3.ssd8ergssdg15dsfdga6bv8aj.xyz/film/1399/08/Shutter.Island.2010/Shutter.Island.2010.720p.BluRay.x264.YTS.SoftSub.AvaMovie.mkv");
  double _currentSliderValue = 0;
  int splits = 1;
  final List<Widget> rowList = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate("dashboard.app_bar.title")),
          ),
          body: Column(
            children: [
              TextField(
                controller: txte,
              ),
              Row(
                children: [
                  Slider(
                    value: _currentSliderValue,
                    min: 0,
                    max: 6,
                    divisions: 6,
                    label: [1, 2, 4, 8, 16, 24, 32][_currentSliderValue.round()]
                        .toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                        splits = [
                          1,
                          2,
                          4,
                          8,
                          16,
                          24,
                          32
                        ][_currentSliderValue.round()];
                        calculateListOfStars(splits);
                      });
                    },
                  ),
                  Text("$splits")
                ],
              ),
              Column(
                children: rowList,
              ),
              TextButton(
                  onPressed: () {
                    var uri = Uri.parse(txte.text);
                    context.read<DashboardCubit>().download(uri, splits);
                  },
                  child: Text("Download")),
              TextButton(
                  onPressed: () {
                    var uri = Uri.parse(txte.text);
                    context.read<DashboardCubit>().createFile(splits);
                  },
                  child: Text("Create File"))
            ],
          ),
        );
      },
    );
  }

  calculateListOfStars(int length) {
    rowList.clear();
    for(int i=0; i<=length;i++){
      rowList.add(
        LinearProgressIndicator(
          color: Colors.primaries[math.Random().nextInt(Colors.primaries.length)],
        )
      );
    }
  }
}
