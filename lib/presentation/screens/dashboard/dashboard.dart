import 'package:download_manager/presentation/screens/needed_packages.dart';
import 'package:download_manager/presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var fileUrl = TextEditingController(
      text: "https://dl2.soft98.ir/soft/j-k-l/LeoMoon.ParsiNegar.2.1.9.Win.rar?1684238532");
  double _currentSliderValue = 0;
  int splits = 1;
  final List<Widget> rowList = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DownloadState>(
      listener: (context, state) {
        if(state is DownloadInitial){
          print(state.progress[0].percent);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate("dashboard.app_bar.title")),
          ),
          body: Column(
            children: [
              TextField(
                controller: fileUrl,
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
                    var uri = Uri.parse(fileUrl.text);
                    context.read<DashboardCubit>().download(uri, splits);
                  },
                  child: Text("Download")),
              TextButton(
                  onPressed: () {
                    var uri = Uri.parse(fileUrl.text);
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
