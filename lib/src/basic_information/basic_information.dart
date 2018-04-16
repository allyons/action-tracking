import 'package:action_tracking/src/action_tracking/action_tracking_model.dart';
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
  final String materialExpansionPanelId =
      'BasicInformationComponent_MaterialExpansionPanel';
  final String lastNameInputId =
      'BasicInformationComponent_MaterialInput_LastName';
  final String firstNameInputId =
      'BasicInformationComponent_MaterialInput_FirstName';
  final String petNameInputId =
      'BasicInformationComponent_MaterialInput_PetName';
  final String petBreedInputId =
      'BasicInformationComponent_MaterialInput_PetBreed';
  final String phoneNumberInputId =
      'BasicInformationComponent_MaterialInput_PhoneNumber';
  final String emailAddressInputId =
      'BasicInformationComponent_MaterialInput_EmailAddress';

  String clientFirstName;
  String clientLastName;
  String petName;
  String petBreed;
  String phoneNumber;
  String emailAddress;

  BasicInformationComponent(this.actionTrackingModel);

  void handleExpandedChange(bool isExpanded) {
    actionTrackingModel.markExpansionPanelExpansion(isExpanded,
        materialExpansionPanelId);
  }

  void lastNameTextChange(String text) {
    actionTrackingModel.markInputTextChange(text.length, lastNameInputId);
  }

  void firstNameTextChange(String text) {
    actionTrackingModel.markInputTextChange(text.length, firstNameInputId);
  }

  void petNameTextChange(String text) {
    actionTrackingModel.markInputTextChange(text.length, petNameInputId);
  }

  void petBreedTextChange(String text) {
    actionTrackingModel.markInputTextChange(text.length, petBreedInputId);
  }

  void phoneNumberTextChange(String text) {
    actionTrackingModel.markInputTextChange(text.length, phoneNumberInputId);
  }

  void emailAddressTextChange(String text) {
    actionTrackingModel.markInputTextChange(text.length, emailAddressInputId);
  }
}
