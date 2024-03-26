import 'package:bloc/bloc.dart';
// ignore_for_file: avoid_print

class SimpleBlocOberver extends BlocObserver {

  const SimpleBlocOberver();

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // TODO: implement onTransition
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}