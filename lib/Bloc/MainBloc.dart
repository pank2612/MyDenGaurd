
import 'package:flutter_bloc/flutter_bloc.dart';


import 'AuthBloc.dart';
import 'ConnectivityBloc.dart';

class MainBloc{
  static List<BlocProvider> allBlocs(){
    return [
      BlocProvider<ConnectivityBloc>(
        create:(_) => ConnectivityBloc(),
      ),
      BlocProvider<AuthBloc>(
        create:(_) => AuthBloc(),
      ),
    ];
  }
}