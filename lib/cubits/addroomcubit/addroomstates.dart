abstract class AddRoomState{}

class AddRoomInitial extends AddRoomState{}
class AddRoomLoading extends AddRoomState{}
class AddRoomSuccess extends AddRoomState{
  final String message;
  AddRoomSuccess({required this.message});
}
class AddRoomFailed extends AddRoomState{
  final String message;
  AddRoomFailed({required this.message});
}