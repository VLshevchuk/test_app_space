import 'package:flutter_bloc/flutter_bloc.dart';
import "package:space_chat/bloc/breadcromps/breadcromps_event.dart";
import "package:space_chat/bloc/breadcromps/breadcromps_state.dart";

class BreadcrompsBloc extends Bloc<BreadCropmsChangeEvent, BreadcrompsState> {
  BreadcrompsBloc()
      : super(const BreadcrompsState(activeBreadcromps: 'login')) {
    on<BreadCropmsChangeEvent>(_breadcrompsChangeHandler);
  }

  _breadcrompsChangeHandler(BreadCropmsChangeEvent event, Emitter emitter) {
    emitter(BreadcrompsState(activeBreadcromps: event.activeBreadromps));
  }
}
