import 'package:blackout_tracker/domain/entities/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addToCloud(Map<String, dynamic> data) async {
  // Add a new document with a generated ID
  await FirebaseFirestore.instance.collection('mobileStates').add(data);
}

Future<List<DataModel>> readFromCloud() async {
  final List<DataModel> dataList = [];
  await FirebaseFirestore.instance
      .collection('mobileStates')
      .orderBy('time')
      .limitToLast(10)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.size > 0) {
      for (final doc in querySnapshot.docs) {
        if (doc.exists) {
          final Map<String, dynamic> mapData =
              doc.data()! as Map<String, dynamic>;
          mapData['time'] = (mapData['time'] as Timestamp).toDate();
          dataList.add(DataModel.fromMap(mapData));
        }
      }
    }
  });

  return dataList;
}
