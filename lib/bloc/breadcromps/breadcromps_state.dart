import 'package:equatable/equatable.dart';

class BreadcrompsState extends Equatable {
  const BreadcrompsState({required this.activeBreadcromps});
  final String activeBreadcromps;
  @override
  List<Object?> get props => [activeBreadcromps];
}
