import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:journal/bloc/authentication_bloc.dart';
import 'package:journal/bloc/authentication_bloc_provider.dart';
import 'package:journal/bloc/home_bloc.dart';
import 'package:journal/bloc/home_bloc_provider.dart';
import 'package:journal/bloc/journal_edit_bloc.dart';
import 'package:journal/bloc/journal_edit_bloc_provider.dart';
import 'package:journal/classes/formate_dates.dart';
import 'package:journal/classes/mood_icons.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/pages/edit_entry.dart';
import 'package:journal/services/db_firestore.dart';
import 'package:journal/utils/ads_state.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AuthenticationBloc _authenticationBloc;
  late HomeBloc _homeBloc;
  late String _uid;
  final MoodIcons _moodIcons = const MoodIcons();
  final FormatDates _formatDates = FormatDates();
  late BannerAd bannerAd;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        bannerAd = BannerAd(
            size: AdSize.banner,
            adUnitId: adState.bannerId,
            listener: adState.adListener,
            request: const AdRequest())
          ..load();
      });
    });
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

// Add or Edit Journal Entry and call the Show Entry Dialog
  void _addOrEditJournal({required bool add, required Journal journal}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => JournalEditBlocProvider(
                journalEditBloc:
                    JournalEditBloc(add, journal, DbFirestoreService()),
                child: const EditEntry(),
              ),
          fullscreenDialog: true),
    );
  }

  // Confirm Deleting a Journal Entry
  Future<bool> _confirmDeleteJournal() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Journal",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: 16, color: Colors.black),
          ),
          content: Text(
            "Are you sure you would like to Delete?",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: 16, color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text(
                'DELETE',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF24133A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: <Widget>[
          _logOutWidget(context),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _homeBloc.listJournal,
          builder: ((BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildListViewSeparated(snapshot);
            } else {
              return const Center(
                child: SizedBox(
                  child: Text(
                    'Add Journals.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: bannerAd == null ? Container() : AdWidget(ad: bannerAd),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5D5682),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          _addOrEditJournal(add: true, journal: Journal(uid: _uid));
        },
      ),
    );
  }

  Widget _logOutWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: SizedBox(
        height: 20,
        width: 20,
        child: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.white54,
          ),
          onPressed: () {
            setState(() {
              _authenticationBloc.logoutUser.add(true);
            });
          },
        ),
      ),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          String _titleDate = _formatDates
              .dateFormatShortMonthDayYear(snapshot.data[index].date);
          String _subtitle = snapshot.data[index].note;
          return Dismissible(
            key: Key(snapshot.data[index].documentID),
            background: Container(
              color: const Color(0xFF396293),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: const Color(0xFF396293),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              color: Colors.transparent.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  leading: Transform(
                    transform: Matrix4.identity()
                      ..rotateZ(_moodIcons
                          .getMoodRotation(snapshot.data[index].mood)),
                    alignment: Alignment.center,
                    child: Icon(
                      _moodIcons.getMoodIcon(snapshot.data[index].mood),
                      color: _moodIcons.getMoodColor(snapshot.data[index].mood),
                      size: 42.0,
                    ),
                  ),
                  subtitle: Text(
                    _titleDate,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 16),
                  ),
                  title: Text(
                    _subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 18, color: Colors.white),
                  ),
                  // subtitle: ,
                  onTap: () {
                    _addOrEditJournal(
                      add: false,
                      journal: snapshot.data[index],
                    );
                  },
                ),
              ),
            ),
            confirmDismiss: (direction) async {
              bool confirmDelete = await _confirmDeleteJournal();
              if (confirmDelete) {
                _homeBloc.deleteJournal.add(snapshot.data[index]);
              }
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox();
        },
      ),
    );
  }
}
