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
  List<String> items = [];
  String newTreatment = '';

  void addNewTreatment() {
    items.add(newTreatment);
    newTreatment = '';
  }

  String remove(int index) => items.removeAt(index);
}
