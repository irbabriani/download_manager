import 'package:download_manager/domain/entities/download/download_entity.dart';
import 'package:download_manager/presentation/screens/needed_packages.dart';
import 'package:download_manager/presentation/screens/download/cubit/download_cubit.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  var fileUrl = TextEditingController(
      text:
          'https://hajifirouz10.cdn.asset.aparat.com/aparat-video/2ebcec26668ab8216dcbf7844ed3a1c552018148-1080p.mp4?wmsAuthSign=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6ImJkY2U0NThmMDIzMTk1NzNiNDMxZTBkYzhhMDA2ZjNjIiwiZXhwIjoxNjg0MjY3NDkwLCJpc3MiOiJTYWJhIElkZWEgR1NJRyJ9.3thsyXUSaJod7XZ7bApFVL0AVpe4MKi6YJ9nnd34WsU');
  double _currentSliderValue = 0;
  int splits = 1;
  final List<Widget> rowList = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DownloadCubit, DownloadState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DownloadInitial) {
          rowList.clear();
          var progressBars = state.getProgress
              .map((progress) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      child: LinearProgressIndicator(
                        color: Colors.green,
                        value: progress.percent,
                      ),
                    ),
                  ))
              .toList();
          rowList.addAll(progressBars);
        }
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
                      });
                    },
                  ),
                  Text("$splits")
                ],
              ),
              Visibility(
                  visible: rowList.isNotEmpty,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: rowList,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    var uri = Uri.parse(fileUrl.text);
                    context.read<DownloadCubit>().download(uri, splits);
                  },
                  child: Text("Download")),
              TextButton(
                  onPressed: () {
                    var uri = Uri.parse(fileUrl.text);
                    context.read<DownloadCubit>().createFile(splits);
                  },
                  child: Text("Create File")),
              TextButton(
                  onPressed: () {
                    var download = DownloadEntity(name: 'Test',id: '1');
                    context.read<DownloadCubit>().addDownload(download);
                  },
                  child: Text("Put")),
              TextButton(
                  onPressed: () {
                    context.read<DownloadCubit>().createFile(splits);
                  },
                  child: Text("Get")),
            ],
          ),
        );
      },
    );
  }

// calculateListOfStars(int length) {
//   rowList.clear();
//   for(int i=0; i<=length;i++){
//     rowList.add(
//         LinearProgressIndicator(
//           color: Colors.primaries[math.Random().nextInt(Colors.primaries.length)],
//         )
//     );
//   }
// }
}
