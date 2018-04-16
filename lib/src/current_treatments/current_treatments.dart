import 'package:action_tracking/src/action_tracking/action_tracking_model.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'current-treatments',
  styleUrls: const ['current_treatments.css'],
  templateUrl: 'current_treatments.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
)
class CurrentTreatmentsComponent {
  final ActionTrackingModel actionTrackingModel;
  final String materialExpansionPanelId =
      'CurrentTreatmentsComponent_MaterialExpansionPanel';
  final String treatmentInputId =
      'CurrentTreatmentsComponent_MaterialInput_Treatment';
  final String addTreatmentButtonId =
      'CurrentTreatmentsComponent_MaterialButton_AddTreatment';
  final String removeTreatmentButtonId =
      'CurrentTreatmentsComponent_MaterialButton_RemoveTreatment';

  List<String> items = [];
  String newTreatment = '';

  CurrentTreatmentsComponent(this.actionTrackingModel);

  void addNewTreatment() {
    actionTrackingModel.markButtonClicked(addTreatmentButtonId);
    items.add(newTreatment);
    newTreatment = '';
  }

  void handleExpandedChange(bool isExpanded) {
    actionTrackingModel.markExpansionPanelExpansion(isExpanded,
        materialExpansionPanelId);
  }

  void treatmentTextChange(String text) {
    actionTrackingModel.markInputTextChange(text.length, treatmentInputId);
  }

  String remove(int index) {
    actionTrackingModel.markButtonClicked(removeTreatmentButtonId);
    return items.removeAt(index);
  }
}
