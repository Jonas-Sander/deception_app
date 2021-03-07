// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deception_app/email_customization/email_customization.dart';
import 'package:deception_app/l10n/l10n.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 65),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Deine E-Mail-Adressen',
                  style: GoogleFonts.raleway(
                    textStyle: Theme.of(context).textTheme.headline2!,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                )),
            const Divider(),
            const SizedBox(height: 100),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: AutoSizeTextField(
                        maxLength: 20,
                        // maxLengthEnforced: true,
                        minWidth: 50,
                        fullwidth: false,
                        textAlign: TextAlign.end,
                        controller: TextEditingController(),
                        inputFormatters: [
                          // TextInputFormatter.withFunction(
                          //     (oldValue, newValue) => EmailValidator.validate(
                          //             '$newValue@deception.team')
                          //         ? newValue
                          //         : oldValue),
                        ],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 20),
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: Text(
                          '@deception.team',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 20),
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: const Key('counterView_increment_floatingActionButton'),
            child: const Icon(Icons.add),
            onPressed: () => context.read<CounterCubit>().increment(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            key: const Key('counterView_decrement_floatingActionButton'),
            child: const Icon(Icons.remove),
            onPressed: () => context.read<CounterCubit>().decrement(),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.headline1);
  }
}
