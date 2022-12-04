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
    text: "https://dl2.soft98.ir/soft/a/AnyDesk.7.1.6.zip"
  );
  double _currentSliderValue = 0;
  int splits = 1;
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
                        splits = [1, 2, 4, 8, 16, 24, 32][_currentSliderValue.round()];
                      });
                    },
                  ),
                  Text("$splits")
                ],
              ),
              TextButton(onPressed: () {
                var uri= Uri.parse(txte.text);
                context.read<DashboardCubit>().download(uri, splits);
              }, child: Text("Download")),
              TextButton(onPressed: () {
                var uri= Uri.parse(txte.text);
                context.read<DashboardCubit>().createFile(splits);
              }, child: Text("Create File"))
            ],
          ),
        );
      },
    );
  }
}
