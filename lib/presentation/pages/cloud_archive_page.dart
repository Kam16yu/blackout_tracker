import 'package:blackout_tracker/domain/entities/data_model.dart';
import 'package:blackout_tracker/presentation/bloc/bloc.dart';
import 'package:blackout_tracker/presentation/bloc/events.dart';
import 'package:blackout_tracker/presentation/bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CloudArchive extends StatefulWidget {
  const CloudArchive({super.key});

  @override
  State<CloudArchive> createState() => _CloudArchiveState();
}

class _CloudArchiveState extends State<CloudArchive> {
  List dataList = [];
  final DateFormat formatter = DateFormat('yyyy-MM-dd H:mm:ss');

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainBloc>(context).add(ReadCloud());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last 10 records in the Cloud archive'),
      ),
      body: Column(
        children: [
          BlocConsumer<MainBloc, ListState>(
            listener: (context, state) {
              if (state is ReadCloudState) {
                dataList = state.data;
              }
            },
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final DataModel data = dataList[index] as DataModel;

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
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
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
