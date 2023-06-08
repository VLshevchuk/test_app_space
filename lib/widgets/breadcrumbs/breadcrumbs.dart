import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:space_chat/bloc/breadcromps/breadcromps_bloc.dart';
import 'package:space_chat/bloc/breadcromps/breadcromps_event.dart';
import 'package:space_chat/bloc/breadcromps/breadcromps_state.dart';

class BreadCrumbs extends StatelessWidget {
  BreadCrumbs({super.key, required this.navigation});

  final Map<String, String> navigation;
  late String activeCromp;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BreadcrompsBloc, BreadcrompsState>(
        builder: (context, state) {
      final Bloc bloc = BlocProvider.of<BreadcrompsBloc>(context);
      activeCromp = state.activeBreadcromps;
      return Row(
        children: [
          ...createBreadcromps(bloc),
        ],
      );
    });
  }

  List<Widget> createBreadcromps(bloc) {
    List<Widget> buttons = navigation.entries.map((entry) {
      String text = entry.key;

      return Container(
        margin: const EdgeInsets.only(right: 10),
        child: ElevatedButton(
          onPressed: () {
            bloc.add(BreadCropmsChangeEvent(activeBreadromps: text));
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            foregroundColor: MaterialStateProperty.all<Color>(
                activeCromp == text ? Colors.blueAccent : Colors.black),
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            elevation: MaterialStateProperty.all<double>(0),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(text),
            const SizedBox(
              width: 5,
            ),
            const Text(
              '/',
              style: TextStyle(fontSize: 10),
            ),
          ]),
        ),
      );
    }).toList();
    return buttons;
  }
}
