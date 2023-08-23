import 'package:state_notifier/state_notifier.dart';

class LoadingStateNotifier extends StateNotifier<bool> {
  LoadingStateNotifier() : super(false);

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}
