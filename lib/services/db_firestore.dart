import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/services/db_firestore_api.dart';

class DbFirestoreService implements DbApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionJournals = 'journals';
  DbFirestoreService() {
    _firestore.settings;
  }

  @override
  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournals)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> _journalDocs =
          snapshot.docs.map((doc) => Journal.fromDoc(doc)).toList();
      _journalDocs.sort((comp1, comp2) => comp2.date!.compareTo(comp1.date!));
      return _journalDocs;
    });
  }

  @override
  Future<bool> addJournal(Journal journal) async {
    DocumentReference _documentReference =
        _firestore.collection(_collectionJournals).doc();
    await _documentReference.set({
      'documentID': _documentReference.id,
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
      'uid': journal.uid,
    });
    return _documentReference.id.isNotEmpty;
  }

  @override
  void updateJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .update({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
    }).catchError((error) => debugPrint('Error updating: $error'));
  }

  @override
  void deleteJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .delete()
        .catchError((error) => debugPrint('Error deleting: $error'));
  }

  @override
  Future<Journal> getJournal(String documentID) {
    throw UnimplementedError();
  }

  @override
  void updateJournalWithTransaction(Journal journal) {}
}
