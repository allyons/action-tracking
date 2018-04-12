import 'dart:async';

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
  List<String> doctorList;
  String selectedDoctor;

  DoctorSelectionComponent(this.doctorSelectionService);

  @override
  Future<Null> ngOnInit() async {
    doctorList = await doctorSelectionService.getDoctorList();
  }
}
