import 'package:drumm_app/home/bloc/midibloc_bloc.dart';
import 'package:drumm_app/home/cubit/devices_cubit.dart';
import 'package:drumm_app/home/cubit/home_cubit.dart';
import 'package:drumm_app/home/widgets/appbar_action_widget.dart';
import 'package:drumm_app/home/widgets/instrument_view.dart';
import 'package:drumm_app/home/widgets/midi_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  //Wrap the homepage with the homecubit
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => DevicesCubit(),
        ),
        BlocProvider(
          create: (context) => MidiblocBloc(),
        ),
      ],
      child: const HomeView(),
    );
  }
}

//Homeview, initial screen is rendered here
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = context.select((DevicesCubit cubit) => cubit.selectedDevice);
    final allDevices = context.select((DevicesCubit cubit) => cubit.state);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drumm App'),
        elevation: 0,
        actions: [
          //Open dropdown with available devices
          AppbarActionWidget(allDevices: allDevices),
        ],
      ),
      body: SizedBox.expand(
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        //Will show the name of the device once connected
                        device,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    //draw the midiData if a device is connected
                    MidiDataWidget(allDevices: allDevices),
                  ],
                ),
              ),
            ),
            //Draw all of the instruments
            const InstrumentView()
          ],
        ),
      ),
    );
  }
}
