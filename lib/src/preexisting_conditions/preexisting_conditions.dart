import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'preexisting_conditions_service.dart';

@Component(
  selector: 'preexisting-conditions',
  styleUrls: const ['preexisting_conditions.css'],
  templateUrl: 'preexisting_conditions.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [PreexistingConditionsService],
)
class PreexistingConditionsComponent implements OnInit {
  final PreexistingConditionsService preexistingConditionsService;
  Map<String, bool> conditions = {};
  bool otherChecked = false;
  String otherCondition = '';

  PreexistingConditionsComponent(this.preexistingConditionsService);

  @override
  Future<Null> ngOnInit() async {
    var knownConditions =
      await preexistingConditionsService.getConditionsList();
    knownConditions.forEach((c) => conditions[c] = false);
  }

  void handleCheckedChange(bool value, String condition) {
    conditions[condition] = value;
    print(conditions);
  }
}
