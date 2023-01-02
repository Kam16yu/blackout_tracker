abstract class ListEvent {}

class ListInitEvent extends ListEvent {}

class GetEvent extends ListEvent {
  GetEvent();
}

class UpdateEvent extends ListEvent {
  UpdateEvent();
}

class DeleteElementEvent extends ListEvent {
  final int index;

  DeleteElementEvent(this.index);
}

class WorkManagerAddEvent extends ListEvent {
  WorkManagerAddEvent();
}

class ReloadWorkManager extends ListEvent {
  ReloadWorkManager();
}

class ReadCloud extends ListEvent {
  ReadCloud();
}
