import 'dart:async';

import 'package:action_tracking/src/action_tracking/action_tracking_model.dart';
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
  final ActionTrackingModel actionTrackingModel;
  final String materialExpansionPanelId =
      'PreexistingConditionsComponent_MaterialExpansionPanel';
  final String knownConditionCheckboxId =
      'PreexistingConditionsComponent_MaterialCheckbox_KnownCondition';
  final String otherConditionCheckboxId =
      'PreexistingConditionsComponent_MaterialCheckbox_OtherCondition';
  final String otherConditionInputId =
      'PreexistingConditionsComponent_MaterialInput_OtherCondition';
  final PreexistingConditionsService preexistingConditionsService;
  Map<String, bool> conditions = {};
  bool otherChecked = false;
  String otherCondition = '';

  PreexistingConditionsComponent(this.preexistingConditionsService,
      this.actionTrackingModel);

  @override
  Future<Null> ngOnInit() async {
    var knownConditions =
      await preexistingConditionsService.getConditionsList();
    knownConditions.forEach((c) => conditions[c] = false);
  }

  void handleExpandedChange(bool isExpanded) {
    actionTrackingModel.markExpansionPanelExpansion(isExpanded,
        materialExpansionPanelId);
  }

  void handleKnownConditionCheckedChange(bool isChecked, String condition) {
    conditions[condition] = isChecked;
    actionTrackingModel.markExpansionPanelExpansion(isChecked,
        knownConditionCheckboxId);
  }

  void handleOtherConditionCheckedChange(bool isChecked) {
    otherChecked = isChecked;
    actionTrackingModel.markExpansionPanelExpansion(isChecked,
        otherConditionCheckboxId);
  }

  void otherConditionTextChange(String text) {
    actionTrackingModel.markInputTextChange(text.length, otherConditionInputId);
  }
}
