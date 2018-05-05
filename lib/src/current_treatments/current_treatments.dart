import 'package:action_tracking/src/action_tracking/action_tracking_model.dart';
import 'package:action_tracking/src/action_tracking/doctor_app_configuration.dart';
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

  List<String> items = [];
  String newTreatment = '';

  CurrentTreatmentsComponent(this.actionTrackingModel);

  String get elementId => currentTreatmentsExpansionPanelId;

  void addNewTreatment() {
    actionTrackingModel.markButtonClicked(elementId,
        currentTreatmentsAddActionId);
    items.add(newTreatment);
    newTreatment = '';
  }

  void handleExpandedChange(bool isExpanded) {
    actionTrackingModel.markExpansionPanelExpansion(isExpanded, elementId,
        isExpanded ?
        expansionPanelExpandActionId : expansionPanelCollapseActionId);
  }

  void treatmentTextChange(String text) {
    actionTrackingModel.markInputTextChange(text.length, elementId,
        inputTextChangeActionId);
  }

  String remove(int index) {
    actionTrackingModel.markButtonClicked(elementId,
        currentTreatmentsRemoveActionId);
    return items.removeAt(index);
  }
}
