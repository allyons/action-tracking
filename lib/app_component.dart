import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'src/action_tracking/action_tracking_model.dart';
import 'src/basic_information/basic_information.dart';
import 'src/current_treatments/current_treatments.dart';
import 'src/doctor_selection/doctor_selection.dart';
import 'src/preexisting_conditions/preexisting_conditions.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [
    materialDirectives,
    BasicInformationComponent,
    CurrentTreatmentsComponent,
    DoctorSelectionComponent,
    PreexistingConditionsComponent],
  providers: const [
    ActionTrackingModel,
    materialProviders
  ],
)

/// Main AppComponent.
class AppComponent implements OnInit {
  ActionTrackingModel actionTrackingModel;

  AppComponent(this.actionTrackingModel);

  @override
  void ngOnInit() {
    actionTrackingModel.startSession();
  }

  void onSubmit() {
    actionTrackingModel.stopSession();
  }
}
