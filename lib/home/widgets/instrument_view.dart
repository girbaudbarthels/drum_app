import 'package:drumm_app/home/bloc/midibloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstrumentView extends StatelessWidget {
  const InstrumentView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  final instrument = index + 1;

                  return Column(
                    children: [
                      InkWell(
                        onTap: () => context.read<MidiblocBloc>().playSound(
                            context
                                .read<MidiblocBloc>()
                                .sounds['${59 + instrument}'] as String,
                            "127"),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => context.read<MidiblocBloc>().add(
                                      MidiblocAddSoundEvent(
                                        midiNote: '${59 + instrument}',
                                      ),
                                    ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.music_note,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Instrument $instrument',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${59 + instrument}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.white10,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
