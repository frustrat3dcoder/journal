import 'package:flutter/material.dart';
import 'package:journal/bloc/journal_edit_bloc.dart';

class JournalEditBlocProvider extends InheritedWidget {
  final JournalEditBloc journalEditBloc;

  const JournalEditBlocProvider(
      {Key? key, required Widget child, required this.journalEditBloc})
      : super(key: key, child: child);

  static JournalEditBlocProvider of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<JournalEditBlocProvider>()
        as JournalEditBlocProvider);
  }

  @override
  bool updateShouldNotify(JournalEditBlocProvider oldWidget) => false;
}
