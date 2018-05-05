import 'package:action_tracking/src/action_tracking/action_tracking_configuration.dart';
import 'package:action_tracking/src/action_tracking/action_tracking_data.dart';

class ComputationEngine {

  /// Compute an intrinsic value score for action data.
  ///
  /// The configuration's action ID must match the data's action ID.
  static double intrinsicValueScore(List<ActionTrackingData> actionData,
      ActionConfiguration actionConfig) {
    if (actionData.length == 0) return 0.0;
    var totalScore = 0.0;
    _validate(actionData, actionConfig);

    switch (actionConfig.scoringType) {
      case ActionScoringType.second:
        var nextActionScore = actionConfig.intrinsicValue;
        for (var i = 1; i < actionData.length; i++) {
          totalScore += nextActionScore;
          nextActionScore *= actionConfig.valueSubsequenceMultiplier;
        }
        break;
      case ActionScoringType.static:
        var nextActionScore = actionConfig.intrinsicValue;
        actionData.forEach((_) {
          totalScore += nextActionScore;
          nextActionScore *= actionConfig.valueSubsequenceMultiplier;
        });
        break;
      default:
        throw new Exception("Action scoring type was unknown.");
    }

    if (totalScore > actionConfig.maxValueScore) {
      return actionConfig.maxValueScore;
    }
    return totalScore;
  }

  /// Compute an action duration score for action data.
  ///
  /// The configuration's action ID must match the data's action ID.
  static double actionDurationScore(List<ActionTrackingData> actionData,
      ActionConfiguration actionConfig) {
    if (actionData.length == 0) return 0.0;
    _validate(actionData, actionConfig);

    var totalTimeSpent = 0.0;
    actionData.forEach((data) => totalTimeSpent += data.duration);

    var totalScore = 0.0;
    if (totalTimeSpent > actionConfig.upperTimeBound) {
      totalScore += (totalTimeSpent - actionConfig.upperTimeBound)
          * actionConfig.timeScoreRate;
    } else if (totalTimeSpent < actionConfig.lowerTimeBound) {
      totalScore += (actionConfig.lowerTimeBound - totalTimeSpent)
          * actionConfig.timeScoreRate;
    }

    if (totalScore > actionConfig.maxTimeScore) {
      return actionConfig.maxTimeScore;
    }
    return totalScore;
  }

  /// Extract a list of action or element ordering deviations by ID.
  ///
  /// A "step" represents an element or an action, depending on the level.
  /// If an action or element is not in the list of validOrderings keys, then no
  /// deviation is recorded.
  static List<Deviation> workflowOrdering(
      List<String> steps,
      Map<String, Set<String>> validOrderings) {
    if (steps.length < 2) return [];
    var deviations = [];
    var currentStep = steps[0];

    for (int i = 1; i < steps.length; i++) {
      var nextStep = steps[i];
      if (currentStep != nextStep &&
          validOrderings.containsKey(currentStep) &&
          !(validOrderings[currentStep].contains(nextStep))) {
        deviations.add(new Deviation(currentStep, nextStep));
      }
      currentStep = nextStep;
    }

    return deviations;
  }

  static void _validate(List<ActionTrackingData> actionData,
      ActionConfiguration actionConfig) {
    for (ActionTrackingData data in actionData) {
      if (data == null) {
        throw new Exception("Invalid ActionTrackingData.");
      }
      if (data.actionId != actionConfig.actionId) {
        throw new Exception("Action IDs do not match.");
      }
    }
  }
}
