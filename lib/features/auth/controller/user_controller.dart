import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/helpers/db_helpers.dart';
import 'package:management/common/models/user_model.dart';

final userProvider = StateNotifierProvider<UserState, List<UserModel>>((ref) {
    return UserState()..refresh();
  },
);

class UserState extends StateNotifier<List<UserModel>> {
  UserState() : super([]);

  void refresh() async {
    final data = await DBHelper.getUsers();
    state = data.map((e) => UserModel.fromJson(e)).toList();
  }

  void addUser(UserModel user) {
    state = [...state, user];
  }

  void removeUser(UserModel user) {
    state = state.where((element) => element.id != user.id).toList();
  }
}
