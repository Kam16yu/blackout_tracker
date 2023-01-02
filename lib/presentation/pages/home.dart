import 'package:blackout_tracker/domain/entities/data_model.dart';
import 'package:blackout_tracker/presentation/bloc/bloc.dart';
import 'package:blackout_tracker/presentation/bloc/events.dart';
import 'package:blackout_tracker/presentation/bloc/states.dart';
import 'package:blackout_tracker/presentation/pages/cloud_archive_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<DataModel> dataList = [];
  final DateFormat formatter = DateFormat('yyyy-MM-dd H:mm:ss');

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainBloc>(context).add(GetEvent());
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc mainBloc = BlocProvider.of<MainBloc>(context);

    return Column(
      children: [
        BlocConsumer<MainBloc, ListState>(
          listener: (context, state) {
            if (state is UpdateUiState) {
              dataList = state.data;
            }
          },
          builder: (context, state) {
            return Expanded(
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final DataModel data = dataList[index];

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ' Data & Time: ${formatter.format(data.time ?? DateTime.now())}',
                            ),
                            Text(
                              ' You battery: ${data.chargeState}, percentage: ${data.chargeLevel}',
                            ),
                            Text(' WiFi connect: ${data.wifiConnect}, '
                                'Internet connect: ${data.internetConnect}'),
                            Text(' Cloud archive: ${data.cloudArchive}'),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<MainBloc>(context)
                                .add(DeleteElementEvent(data.id ?? -1));
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        BottomAppBar(
          color: Colors.white38,
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(" Background:", style: TextStyle(fontSize: 25)),
                  IconButton(
                    padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                    icon: const Icon(Icons.restart_alt_sharp),
                    iconSize: 40.0,
                    onPressed: () {
                      BlocProvider.of<MainBloc>(context)
                          .add(ReloadWorkManager());
                    },
                    tooltip: 'Restart background process',
                  ),
                  IconButton(
                    padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                    icon: const Icon(Icons.stop),
                    iconSize: 40.0,
                    onPressed: () => Workmanager().cancelAll(),
                    tooltip: 'Stop background process',
                  ),
                ],
              ),
              IconButton(
                padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                icon: const Icon(Icons.cloud),
                iconSize: 40.0,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider.value(
                        value: mainBloc,
                        child: const CloudArchive(),
                      ),
                    ),
                  );
                },
                tooltip: 'Cloud Archive',
              ),
              IconButton(
                padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                icon: const Icon(Icons.add_box_rounded),
                iconSize: 40.0,
                onPressed: () {
                  BlocProvider.of<MainBloc>(context).add(UpdateEvent());
                },
                tooltip: 'Check State',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
