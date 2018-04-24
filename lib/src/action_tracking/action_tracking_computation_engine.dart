import 'package:action_tracking/src/action_tracking/action_tracking_configuration.dart';
import 'package:action_tracking/src/action_tracking/action_tracking_data.dart';
import 'package:quiver/core.dart';

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

class AppReport {
  final List<ElementReport> elements = [];
  final Map<Deviation, int> elementOrderingDeviations = {};
  double intrinsicValueScore = 0.0;
  double actionDurationScore = 0.0;
  double workflowOrderingScore = 0.0;

  AppReport(List<ActionTrackingData> appData, AppConfiguration appConfig) {

    // Map from element ID to its corresponding tracking data.
    final elementMap = new Map<String, List<ActionTrackingData>>();

    // Differentiate elements based on element ID.
    for (ActionTrackingData elementData in appData) {
      final elementId = elementData.elementId;
      if (elementMap.containsKey(elementData.elementId)) {
        elementMap[elementId]..add(elementData);
      } else {
        elementMap[elementId] = [elementData];
      }
    }

    // Generate element reports and aggregate metrics.
    for (String elementId in elementMap.keys) {
      final elementReport = new ElementReport(elementId, elementMap[elementId],
          appConfig.elements[elementId]);
      intrinsicValueScore += elementReport.intrinsicValueScore;
      actionDurationScore += elementReport.actionDurationScore;
      elements.add(elementReport);
    }

    // Derive element sequence
    var elementSequence = appData.map((e) => e.elementId);

    // Get deviation list
    var deviations = ComputationEngine.workflowOrdering(
        elementSequence,
        appConfig.validElementOrderings);

    // Compute workflow ordering deviations.
    for (var deviation in deviations) {
      if (elementOrderingDeviations.containsKey(deviation)) {
        elementOrderingDeviations[deviation] += 1;
      } else {
        elementOrderingDeviations[deviation] = 1;
      }
    }

    // Compute workflow ordering score.
    workflowOrderingScore =
        deviations.length * (appConfig.workflowOrderingPenalty);
  }
}

class ElementReport {
  final String elementId;
  final ElementConfiguration elementConfiguration;
  final List<ActionReport> actions = [];
  final Map<Deviation, int> actionOrderingDeviations = {};
  double intrinsicValueScore = 0.0;
  double actionDurationScore = 0.0;
  double workflowOrderingScore = 0.0;

  ElementReport(this.elementId, List<ActionTrackingData> elementData,
      this.elementConfiguration) {

    // Map from action ID to its corresponding tracking data.
    final actionMap = new Map<String, List<ActionTrackingData>>();

    // Differentiate actions based on action ID.
    for (ActionTrackingData actionData in elementData) {
      final actionId = actionData.actionId;
      if (actionMap.containsKey(actionId)) {
        actionMap[actionId]..add(actionData);
      } else {
        actionMap[actionId] = [actionData];
      }
    }

    // Generate individual action reports and aggregate metrics.
    for (String actionId in actionMap.keys) {
      final actionReport = new ActionReport(actionId, actionMap[actionId],
          elementConfiguration.actions[actionId]);
      intrinsicValueScore += actionReport.intrinsicValueScore;
      actionDurationScore += actionReport.actionDurationScore;
      actions.add(actionReport);
    }

    // Derive action sequence
    var actionSequence = elementData.map((e) => e.actionId);

    // Get deviation list
    var deviations = ComputationEngine.workflowOrdering(
        actionSequence,
        elementConfiguration.validActionOrderings);

    // Compute workflow ordering deviations.
    for (var deviation in deviations) {
      if (actionOrderingDeviations.containsKey(deviation)) {
        actionOrderingDeviations[deviation] += 1;
      } else {
        actionOrderingDeviations[deviation] = 1;
      }
    }

    // Compute workflow ordering score.
    workflowOrderingScore =
        deviations.length * (elementConfiguration.workflowOrderingPenalty);

    if (intrinsicValueScore > elementConfiguration.maxIntrinsicValueScore) {
      intrinsicValueScore = elementConfiguration.maxIntrinsicValueScore;
    }
    if (actionDurationScore > elementConfiguration.maxActionDurationScore) {
      actionDurationScore = elementConfiguration.maxActionDurationScore;
    }
    if (workflowOrderingScore > elementConfiguration.maxWorkflowOrderingScore) {
      workflowOrderingScore = elementConfiguration.maxWorkflowOrderingScore;
    }
  }
}

class ActionReport {
  final String actionId;
  final ActionConfiguration actionConfiguration;
  final double intrinsicValueScore;
  final double actionDurationScore;

  ActionReport(this.actionId, List<ActionTrackingData> actionData,
      this.actionConfiguration) :
    intrinsicValueScore = ComputationEngine.intrinsicValueScore(
        actionData, actionConfiguration),
    actionDurationScore = ComputationEngine.actionDurationScore(
        actionData, actionConfiguration);
}

class Deviation {
  final String id1;
  final String id2;

  Deviation(this.id1, this.id2);

  @override
  bool operator ==(other) =>
      other is Deviation && (other.id1 == this.id1) && (other.id2 == this.id2);

  @override
  int get hashCode => hash2(id1, id2);
}
