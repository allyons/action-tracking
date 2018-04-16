/// App-level configuration that maps each user action to its action data.
class ActionTrackingAppConfiguration {
  final elementConfigurations = <String, ElementConfiguration>{};

  ActionTrackingAppConfiguration(List<ElementConfiguration> data) {
    data.forEach((e) => elementConfigurations[e.elementId] = e);
  }
}

/// Scoring configuration for a single Material component element.
class ElementConfiguration {
  final String elementId;
  final double weight;
  final List<ActionConfiguration> actions;

  ElementConfiguration(this.elementId, this.weight, this.actions);
}

/// Scoring configuration for a single user action.
abstract class ActionConfiguration {
  final double score;
  final double scoreSubsequenceMultiplier;
  final double penalty;
  final double penaltySubsequenceMultiplier;
  final double maxScore;
  final double minScore;
  final ActionScoringType scoringType;

  ActionConfiguration(this.score, this.scoreSubsequenceMultiplier, this.penalty,
      this.penaltySubsequenceMultiplier, this.maxScore, this.minScore,
      this.scoringType);
}

/// Scoring configuration for an action expanding a Material Expansion Panel.
class ExpansionPanelExpandActionConfiguration extends ActionConfiguration {
  ExpansionPanelExpandActionConfiguration(double score, double
    scoreSubsequenceMultiplier, double penalty, double
    penaltySubsequenceMultiplier, double maxScore, double minScore,
      ActionScoringType scoringType) : super(score, scoreSubsequenceMultiplier,
      penalty, penaltySubsequenceMultiplier, maxScore, minScore, scoringType);
}

/// Scoring configuration for an action collapsing a Material Expansion Panel.
class ExpansionPanelCollapseActionConfiguration extends ActionConfiguration {
  ExpansionPanelCollapseActionConfiguration(double score, double
  scoreSubsequenceMultiplier, double penalty, double
  penaltySubsequenceMultiplier, double maxScore, double minScore,
      ActionScoringType scoringType) : super(score, scoreSubsequenceMultiplier,
      penalty, penaltySubsequenceMultiplier, maxScore, minScore, scoringType);
}

/// Enum list of supported positivity scoring types.
enum ActionScoringType {

  /// Apply the score each time the action occurs.
  static,

  /// Apply the score the first time the action occurs, then apply the penalty
  /// upon subsequent occurrences.
  single,
}
