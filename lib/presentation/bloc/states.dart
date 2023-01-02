import 'package:blackout_tracker/domain/entities/data_model.dart';

abstract class ListState {}

class ListInitState extends ListState {}

class UpdateUiState implements ListState {
  final List<DataModel> data;

  UpdateUiState(this.data);
}

class ReadCloudState implements ListState {
  final List<DataModel> data;

  ReadCloudState(this.data);
}
