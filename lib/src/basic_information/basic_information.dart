import 'package:action_tracking/src/action_tracking/action_tracking_model.dart';
import 'package:action_tracking/src/action_tracking/doctor_app_configuration.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'basic-information',
  styleUrls: const ['basic_information.css'],
  templateUrl: 'basic_information.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
)
class BasicInformationComponent  {
  final ActionTrackingModel actionTrackingModel;

  String clientFirstName;
  String clientLastName;
  String petName;
  String petBreed;
  String phoneNumber;
  String emailAddress;

  BasicInformationComponent(this.actionTrackingModel);

  String get elementId => basicInformationExpansionPanelId;

  void handleExpandedChange(bool isExpanded) {
    actionTrackingModel.markExpansionPanelExpansion(isExpanded, elementId,
        isExpanded ?
        expansionPanelExpandActionId : expansionPanelCollapseActionId);
  }

  void inputTextChange(String text) {
    actionTrackingModel.markInputTextChange(text.length, elementId,
        inputTextChangeActionId);
  }
}
