import 'package:action_tracking/src/action_tracking/action_tracking_configuration.dart';
import 'package:action_tracking/src/action_tracking/action_tracking_data.dart';
import 'package:action_tracking/src/action_tracking/action_tracking_computation_engine.dart';
import 'dart:math';

/// A wrapper class for all user sessions recorded from the workflow.
class ActionTrackingReport {
  final List<SessionReport> sessions = [];
  Set<String> elements = new Set();
  Map<String, double> totalElementValueScore = {};
  Map<String, double> averageElementValueScore = {};
  Map<String, double> maxElementValueScore = {};
  Map<String, double> minElementValueScore = {};
  Map<String, double> totalElementDurationScore = {};
  Map<String, double> averageElementDurationScore = {};
  Map<String, double> totalPercentTimeSpentInElement = {};
  Map<String, double> averagePercentTimeSpentInElement = {};

  List<String> elementsSortedByIntrinsicValue = [];
  double averageElementIntrinsicValue = 0.0;

  List<String> elementsSortedByDurationScore = [];

  //TODO(allyons): Render action-level reports.
//  Map<String, Set<String>> actions = {};
//  Map<String, Map<String, double>> totalActionValueScore = {};
//  Map<String, Map<String, double>> averageActionValueScore = {};
//  Map<String, Map<String, double>> maxActionValueScore = {};
//  Map<String, Map<String, double>> minActionValueScore = {};
//  Map<String, Map<String, double>> totalActionDurationScore = {};
//  Map<String, Map<String, double>> averageActionDurationScore = {};
//  Map<String, Map<String, double>> totalPercentTimeSpentInAction = {};
//  Map<String, Map<String, double>> averagePercentTimeSpentInAction = {};

  Map<Deviation, int> elementOrderingDeviations = {};
  List<Deviation> rankedElementOrderingDeviations = [];
  Map<String, Map<Deviation, int>> actionOrderingDeviations = {};

  void addSessionReport(SessionReport sessionReport) {

    sessions.add(sessionReport);
    for (ElementReport elementReport in sessionReport.elements) {
      var elementId = elementReport.elementId;
      if (elements.contains(elementId)) {
        totalElementValueScore[elementId] += elementReport.intrinsicValueScore;
        maxElementValueScore[elementId] =
            max(elementReport.intrinsicValueScore,
                maxElementValueScore[elementId]);
        minElementValueScore[elementId] =
            min(elementReport.intrinsicValueScore,
                minElementValueScore[elementId]);
        totalElementDurationScore[elementId] +=
            elementReport.actionDurationScore;
        totalPercentTimeSpentInElement[elementId] +=
            elementReport.duration / sessionReport.duration;

      } else {
        elements.add(elementId);
        totalElementValueScore[elementId] = elementReport.intrinsicValueScore;
        maxElementValueScore[elementId] = elementReport.intrinsicValueScore;
        minElementValueScore[elementId] = elementReport.intrinsicValueScore;
        totalElementDurationScore[elementId] =
            elementReport.actionDurationScore;
        totalPercentTimeSpentInElement[elementId] =
            elementReport.duration / sessionReport.duration;
      }
      averageElementValueScore[elementId] =
          totalElementValueScore[elementId] / sessions.length;
      averageElementDurationScore[elementId] =
          totalElementDurationScore[elementId] / sessions.length;
      averagePercentTimeSpentInElement[elementId] =
          totalPercentTimeSpentInElement[elementId] / sessions.length;

      for (var deviation in elementReport.actionOrderingDeviations.keys) {
        var numDeviations = elementReport.actionOrderingDeviations[deviation];
        if (actionOrderingDeviations[elementId] == null) {
          actionOrderingDeviations[elementId] = {};
        }
        if (actionOrderingDeviations[elementId].containsKey(deviation)) {
          actionOrderingDeviations[elementId][deviation] += numDeviations;
        } else {
          actionOrderingDeviations[elementId][deviation] = numDeviations;
        }
      }
    }

    for (var deviation in sessionReport.elementOrderingDeviations.keys) {
      var numDeviations = sessionReport.elementOrderingDeviations[deviation];
      if (elementOrderingDeviations.containsKey(deviation)) {
        elementOrderingDeviations[deviation] += numDeviations;
      } else {
        elementOrderingDeviations[deviation] = numDeviations;
      }
    }

    // Once the session report is updated, re-sort the highest priority elements
    elementsSortedByIntrinsicValue =
      elements.toList()..sort((String a, String b) {
      final aScore = averageElementValueScore[a];
      final bScore = averageElementValueScore[b];
      if (aScore > bScore) return -1;
      if (aScore < bScore) return 1;
      return 0;
    });
    averageElementIntrinsicValue = 0.0;
    elements.forEach((String e) =>
    averageElementIntrinsicValue += averageElementValueScore[e]);
    averageElementIntrinsicValue /= elements.length;

    // Rank elements by duration scores.
    elementsSortedByDurationScore =
    elements.toList()..sort((String a, String b) {
      final aScore = averageElementDurationScore[a];
      final bScore = averageElementDurationScore[b];
      if (aScore > bScore) return -1;
      if (aScore < bScore) return 1;
      return 0;
    });

    // Sort element workflow deviations by frequency.
    rankedElementOrderingDeviations = elementOrderingDeviations.keys.toList()
      ..sort((Deviation a, Deviation b) {
      final aScore = elementOrderingDeviations[a];
      final bScore = elementOrderingDeviations[b];
      if (aScore > bScore) return -1;
      if (aScore < bScore) return 1;
      return 0;
    });
  }
}

class SessionReport {
  final List<ElementReport> elements = [];
  final Map<Deviation, int> elementOrderingDeviations = {};
  double intrinsicValueScore = 0.0;
  double actionDurationScore = 0.0;
  double workflowOrderingScore = 0.0;
  double duration = 0.0;

  SessionReport(List<ActionTrackingData> appData, AppConfiguration appConfig) {

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
    var elementSequence = appData.map((e) => e.elementId).toList();

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

    appData.forEach((e) => duration += e.duration);
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
  double duration = 0.0;

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
    var actionSequence = elementData.map((e) => e.actionId).toList();

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

    elementData.forEach((e) => duration += e.duration);
  }
}

class ActionReport {
  final String actionId;
  final ActionConfiguration actionConfiguration;
  final double intrinsicValueScore;
  final double actionDurationScore;
  double duration = 0.0;

  ActionReport(this.actionId, List<ActionTrackingData> actionData,
      this.actionConfiguration) :
        intrinsicValueScore = ComputationEngine.intrinsicValueScore(
            actionData, actionConfiguration),
        actionDurationScore = ComputationEngine.actionDurationScore(
            actionData, actionConfiguration) {
    actionData.forEach((e) => duration += e.duration);
  }
}
