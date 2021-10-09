import 'dart:ui';

import 'package:cascade/cascade.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: TextButton(
        child: const Text('data'),
        onPressed: () {
          Navigator.push(
            context,
            RawDialogRoute(
              pageBuilder: (context, a, b) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Material(
                    elevation: 0,
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {},
                      child: Flex(
                        direction: Axis.vertical,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).padding.top +
                                kToolbarHeight,
                          ),
                          CascadeView(
                            List.generate(3, (a) {
                              return CascadeItem(
                                title: "One$a",
                                children: List.generate(10, (b) {
                                  return CascadeItem(
                                    title: "$a-Two$b",
                                    children: a == 1
                                        ? []
                                        : List.generate(7, (c) {
                                            return CascadeItem(
                                                title: "$a-$b-Three$c");
                                          }),
                                  );
                                }),
                              );
                            }),
                            level: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              barrierColor: const Color(0x10000000),
            ),
          );
        },
      ),
    );
  }
}
