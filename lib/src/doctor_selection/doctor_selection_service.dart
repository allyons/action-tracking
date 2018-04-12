import 'dart:async';

import 'package:angular/core.dart';

/// Service that provides a list of available physicians.
@Injectable()
class DoctorSelectionService {
  final doctorList = [
    'Dr. Kaiser',
    'Dr. Seuss',
    'Dr. Dre',
    'Dr. Who'];

  Future<List<String>> getDoctorList() async => doctorList;
}