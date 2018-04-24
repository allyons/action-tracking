import 'dart:async';

import 'package:action_tracking/src/action_tracking/action_tracking_model.dart';
import 'package:action_tracking/src/action_tracking/doctor_app_configuration.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'doctor_selection_service.dart';

@Component(
  selector: 'doctor-selection',
  styleUrls: const ['doctor_selection.css'],
  templateUrl: 'doctor_selection.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [DoctorSelectionService],
)
class DoctorSelectionComponent implements OnInit {
  final DoctorSelectionService doctorSelectionService;
  final ActionTrackingModel actionTrackingModel;

  List<String> doctorList;
  String _selectedDoctor;

  DoctorSelectionComponent(
      this.doctorSelectionService, this.actionTrackingModel);

  set selectedDoctor(String name) {
    actionTrackingModel.markRadioSelectionChange(name,
        doctorSelectionExpansionPanelId, doctorSelectionRadioSelectionActionId);
    _selectedDoctor = name;
  }

  String get selectedDoctor => _selectedDoctor;

  String get elementId => doctorSelectionExpansionPanelId;

  @override
  Future<Null> ngOnInit() async {
    doctorList = await doctorSelectionService.getDoctorList();
  }

  void handleExpandedChange(bool isExpanded) {
    actionTrackingModel.markExpansionPanelExpansion(isExpanded, elementId,
        isExpanded ?
        expansionPanelExpandActionId : expansionPanelCollapseActionId);
  }
}
