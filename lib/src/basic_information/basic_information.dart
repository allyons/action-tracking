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
  String clientFirstName;
  String clientLastName;
  String petName;
  String petBreed;
  String phoneNumber;
  String emailAddress;
}
