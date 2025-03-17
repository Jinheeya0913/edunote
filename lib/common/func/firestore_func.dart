import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String? formatTimestampToDate (Timestamp? timeStamp) {
  if(timeStamp!=null) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  } else {
    return null;
  }
}

Timestamp? formatDateToTimestamp (DateTime? dateTime){
  if(dateTime!=null) {
    return Timestamp.fromDate(dateTime);
  } else {
    return null;
  }
}