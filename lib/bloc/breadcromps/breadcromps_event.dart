import 'package:equatable/equatable.dart';

class BreadCropmsChangeEvent extends Equatable {
  const BreadCropmsChangeEvent({required this.activeBreadromps});

  final String activeBreadromps;

  @override
  List<Object?> get props => [activeBreadromps];
}
