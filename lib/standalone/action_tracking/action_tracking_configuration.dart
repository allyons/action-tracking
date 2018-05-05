import 'package:quiver/core.dart';

/// App-level configuration that maps each user action to its action data.
class AppConfiguration {
  final elements = <String, ElementConfiguration>{};
  final double workflowOrderingPenalty;
  final Map<String, Set<String>> validElementOrderings;

  AppConfiguration(List<ElementConfiguration> data,
      {this.workflowOrderingPenalty = 0.0,
      this.validElementOrderings: const{}}) {
    data.forEach((e) => elements[e.elementId] = e);
  }
}

/// Scoring configuration for a single Material component element.
///
/// For components (such as expansion panels) that contain additional sub-
/// elements, those elements' actions can also be grouped into this
/// configuration.
class ElementConfiguration {
  final String elementId;
  final double weight;
  final double workflowOrderingPenalty;
  final double maxIntrinsicValueScore;
  final double maxActionDurationScore;
  final double maxWorkflowOrderingScore;
  final Map<String, Set<String>> validActionOrderings;

  final actions = <String, ActionConfiguration>{};


  ElementConfiguration(
      this.elementId,
      List<ActionConfiguration> data,
      {this.weight = 1.0,
      this.workflowOrderingPenalty = 0.0,
      this.maxIntrinsicValueScore = 0.0,
      this.maxActionDurationScore = 0.0,
      this.maxWorkflowOrderingScore = 0.0,
      this.validActionOrderings = const{}}) {
    data.forEach((e) => actions[e.actionId] = e);
    }
}

/// Scoring configuration for a single user action.
///
/// Examples of user actions include adding or removing text from a Material
/// Input, or expanding or collapsing a Material Expansion Panel.
class ActionConfiguration {
  final String actionId;
  final double intrinsicValue;
  final double valueSubsequenceMultiplier;
  final double maxValueScore;
  final double lowerTimeBound;
  final double upperTimeBound;
  final double timeScoreRate; // Penalty per second beyond the bounds.
  final double maxTimeScore;
  final ActionType actionType;
  final ActionScoringType scoringType;

  ActionConfiguration(
    this.actionId,
    {this.intrinsicValue = 0.0,
    this.valueSubsequenceMultiplier = 0.0,
    this.maxValueScore = 0.0,
    this.lowerTimeBound = 0.0,
    this.upperTimeBound = 0.0,
    this.timeScoreRate = 0.0,
    this.maxTimeScore = 0.0,
    this.actionType = ActionType.unknown,
    this.scoringType = ActionScoringType.unknown});
}

/// Represents a deviation from the developer's expectation of user actions.
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

/// Enum list of supported material components.
enum ComponentType {
  expansionPanel,
  input,
  checkbox,
  radio,
  button,
  unknown
}

/// Enum list of supported action types.
enum ActionType {

  /// Material Expansion Panel Action - expand panel.
  expansionPanelExpand,

  /// Material Expansion Panel Action - collapse panel.
  expansionPanelCollapse,

  /// Material Input Action - add or remove text.
  inputTextChange,

  /// Material Checkbox Action - check.
  checkboxCheck,

  /// Material Checkbox Action - uncheck.
  checkboxUncheck,

  /// Material Radio Action - radio selection.
  radioSelection,

  /// Material Button - click.
  buttonClick,

  /// Generic action type.
  unknown,
}

/// Enum list of supported positivity scoring types.
enum ActionScoringType {

  /// Apply the score each time the action occurs.
  static,

  /// Apply the score upon the second and subsequent times the action occurs.
  second,

  /// Generic action scoring type.
  unknown,
}
