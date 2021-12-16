import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:journal/bloc/journal_edit_bloc.dart';
import 'package:journal/bloc/journal_edit_bloc_provider.dart';
import 'package:journal/classes/formate_dates.dart';
import 'package:journal/classes/journal_edit.dart';
import 'package:journal/classes/mood_icons.dart';
import 'package:journal/utils/pallete.dart'; // Random() numbers

class EditEntry extends StatefulWidget {
  final bool? add;
  final int? index;
  final JournalEdit? journalEdit;
  const EditEntry({Key? key, this.add, this.index, this.journalEdit})
      : super(key: key);
  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  late JournalEditBloc _journalEditBloc;
  late FormatDates _formatDates;
  late MoodIcons _moodIcons;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _formatDates = FormatDates();
    _moodIcons = const MoodIcons();
    _noteController = TextEditingController();
    _noteController.text = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _journalEditBloc = JournalEditBlocProvider.of(context).journalEditBloc;
  }

  @override
  dispose() {
    _noteController.dispose();
    _journalEditBloc.dispose();
    super.dispose();
  }

  Future<String> _selectDate(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);
    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (_pickedDate != null) {
      selectedDate = DateTime(
              _pickedDate.year,
              _pickedDate.month,
              _pickedDate.day,
              _initialDate.hour,
              _initialDate.minute,
              _initialDate.second,
              _initialDate.millisecond,
              _initialDate.microsecond)
          .toString();
    }
    return selectedDate;
  }

  void _addOrUpdateJournal() {
    _journalEditBloc.saveJournalChanged.add('Save');
    Navigator.pop(context);
  }

  // ignore: prefer_typing_uninitialized_variables
  var selectedIcon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C78AB),
      appBar: appBar(context),
      body: SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: _journalEditBloc.noteEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _noteController.value =
                      _noteController.value.copyWith(text: snapshot.data);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0),
                    child: Column(
                      children: [
                        Text(
                          "Your free thoughts",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 400,
                          child: TextField(
                              controller: _noteController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: 'Type here...',
                                hintStyle:
                                    Theme.of(context).textTheme.headline6,
                                border: InputBorder.none,
                                // hintStyle: ,
                              ),
                              maxLines: null,
                              onChanged: (note) => setState(() {
                                    _journalEditBloc.noteEditChanged.add(note);
                                  })),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Visibility(
                visible: _noteController.value.text.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Palette.kToDark),
                      ),
                      onPressed: () {
                        _addOrUpdateJournal();
                      },
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: _journalEditBloc.dateEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  selectedIcon ??= 'Satisfied';
                  return TextButton(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "How are you feeling today?",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 24),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              _formatDates
                                  .dateFormatShortMonthDayYear(snapshot.data),
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontSize: 16,
                                      ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white54,
                            ),
                            SizedBox(
                              child: Chip(
                                label: Icon(
                                  _moodIcons.getMoodIcon(selectedIcon!),
                                  color: _moodIcons.getMoodColor(selectedIcon!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      String _pickerDate = await _selectDate(snapshot.data);
                      _journalEditBloc.dateEditChanged.add(_pickerDate);
                    },
                  );
                },
              ),
              StreamBuilder(
                  stream: _journalEditBloc.moodEdit,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    selectedIcon = snapshot.data;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: _moodIcons
                              .getMoodIconsList()
                              .map(
                                (e) => Transform(
                                  transform: Matrix4.identity()
                                    ..rotateZ(
                                        _moodIcons.getMoodRotation(e.title!)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          selectedIcon = e.title!;
                                          _journalEditBloc.moodEditChanged
                                              .add(e.title!);
                                          setState(() {});
                                        },
                                        icon: Icon(
                                            _moodIcons.getMoodIcon(e.title!)),
                                        color:
                                            _moodIcons.getMoodColor(e.title!),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.keyboard_arrow_left_outlined,
          color: Colors.white54,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Entry',
        style: TextStyle(
          color: Colors.white54,
        ),
      ),
      automaticallyImplyLeading: false,
      elevation: 0.0,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
    );
  }
}
