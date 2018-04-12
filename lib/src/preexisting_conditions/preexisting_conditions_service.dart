import 'dart:async';

import 'package:angular/core.dart';

/// Service that provides a list of preexisting medical conditions.
@Injectable()
class PreexistingConditionsService {
  final conditionsList = [
    'Degenerative myelopathy',
    'Hip dysplasia',
    'Kidney stone',
    'Respiratory Problem'];

  Future<List<String>> getConditionsList() async => conditionsList;
}