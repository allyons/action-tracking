import 'package:action_tracking/src/action_tracking/action_tracking_configuration.dart';
import 'package:action_tracking/src/action_tracking/action_tracking_model.dart';
import 'package:action_tracking/src/action_tracking/action_tracking_report.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

const maxPrioritizedElements = 4;

@Component(
  selector: 'action-tracking-scorecards',
  styleUrls: const ['action_tracking_scorecards.css'],
  templateUrl: 'action_tracking_scorecards.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
)

/// Data visualization tool for Action Tracking.
///
/// Extracts and renders ranked scores for actions and elements.
class ActionTrackingScorecardsComponent {
  final ActionTrackingModel actionTrackingModel;
  final radioType = ScoreboardType.radio;

  ActionTrackingScorecardsComponent(this.actionTrackingModel);

  ActionTrackingReport get report => actionTrackingModel.actionTrackingReport;

  List<String> get elementsSortedByIntrinsicValue =>
      report.elementsSortedByIntrinsicValue;

  double get averageElementIntrinsicValue =>
      report.averageElementIntrinsicValue;

  List<String> get elementsSortedByDurationScore =>
      report.elementsSortedByDurationScore;

  List<Deviation> get rankedElementOrderingDeviations =>
      report.rankedElementOrderingDeviations;

  /// Average element value score
  String getValueForElement(String id) =>
      report.averageElementValueScore[id].toStringAsFixed(2);

  /// Difference from average element score
  String getDescriptionForElement(String id) =>
      (report.averageElementValueScore[id] - averageElementIntrinsicValue)
          .toStringAsFixed(2);

  /// Average element duration score
  String getDurationValueForElement(String id) =>
      report.averageElementDurationScore[id].toStringAsFixed(2);

  /// Percent time spend in element
  String getDurationDescriptionForElement(String id) =>
      report.averagePercentTimeSpentInElement[id].toStringAsFixed(2);

  /// Deviation former action
  String getLabelForDeviation(Deviation deviation) => deviation.id1;

  /// Deviation frequency
  String getValueForDeviation(Deviation deviation) =>
      report.elementOrderingDeviations[deviation].toString();

  /// Deviation latter action
  String getDescriptionForDeviation(Deviation deviation) => deviation.id2;
}
