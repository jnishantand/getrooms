import 'package:bloc/bloc.dart';
import 'package:getroom/cubits/addroomcubit/addroomstates.dart';
import 'package:getroom/firebaserepo/firebaserepo.dart';

class AddRoomCubit extends Cubit<AddRoomState> {
  AddRoomCubit() : super(AddRoomInitial());

  Future<void> addRoom({required Map<String, dynamic> roomData}) async {
    print('njj add form called');
    emit(AddRoomLoading());
    print('njj add form loading');
    try {
      await FirebaseRepo.addRoom(
              title: roomData['title'],
              price: roomData['price'],
              isBooked: roomData['isBooked'],
              location: roomData['location'],
              category: roomData['category'],
              imageUrls: roomData['imageUrls'] == null
                  ? []
                  : roomData['imageUrls'] ?? [])
          .then((messgae) {
        if (messgae != null) {
          if (messgae.contains('Error')) {
            emit(AddRoomFailed(message: messgae.toString()));
          } else if (messgae.contains('Room added successfully!')) {
            emit(AddRoomSuccess(message: messgae.toString()));
          }
        }
      });
    } catch (e) {
      emit(AddRoomFailed(message: e.toString()));
      print('njj add form error ${e.toString()}}');
    }
  }

  queryRooms({String? location, String? category}) {
    return FirebaseRepo.filterRooms(location: location, category: category);
  }

  deleteRoom(String roomId) {
    return FirebaseRepo.deleteRoom(roomId);
  }

  updateRoom({required String roomId, required Map<String, dynamic> roomData}) {
    return FirebaseRepo.updateRoom(
        roomId: roomId,
        title: 'title',
        price: 0,
        isBooked: false,
        location: 'location',
        category: 'category',
        imageUrls: ['imageUrls']);
  }
}
