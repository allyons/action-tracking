import 'package:action_tracking/src/action_tracking/action_tracking_configuration.dart';

// Primary Component Identifiers.

final String basicInformationExpansionPanelId =
    'BasicInformationComponent_MaterialExpansionPanel';
final String currentTreatmentsExpansionPanelId =
    'CurrentTreatmentsComponent_MaterialExpansionPanel';
final String doctorSelectionExpansionPanelId =
    'DoctorSelectionComponent_MaterialExpansionPanel';
final String preexistingConditionsExpansionPanelId =
    'PreexistingConditionsComponent_MaterialExpansionPanel';

// Common Material Expansion Panel Component Actions.

final expansionPanelExpandActionId = 'MaterialExpansionPanel_Expand';
final _expansionPanelExpand =
  new ActionConfiguration(
      expansionPanelExpandActionId,
      intrinsicValue: 1.0,
      valueSubsequenceMultiplier: 0.5,
      maxValueScore: 5.0,
      lowerTimeBound: 0.0,
      upperTimeBound: 0.0,
      timeScoreRate: 0.0,
      maxTimeScore: 0.0,
      actionType: ActionType.expansionPanelExpand,
      scoringType: ActionScoringType.second);

final expansionPanelCollapseActionId = 'MaterialExpansionPanel_Collapse';
final _expansionPanelCollapse =
  new ActionConfiguration(
      expansionPanelCollapseActionId,
      intrinsicValue: 0.5,
      valueSubsequenceMultiplier: 0.5,
      maxValueScore: 1.0,
      lowerTimeBound: 0.0,
      upperTimeBound: 0.0,
      timeScoreRate: 0.0,
      maxTimeScore: 0.0,
      actionType: ActionType.expansionPanelCollapse,
      scoringType: ActionScoringType.second);

// Common Material Input Component Actions.

final inputTextChangeActionId = 'MaterialInput_TextChange';
final _inputTextChange =
  new ActionConfiguration(
      inputTextChangeActionId,
      intrinsicValue: 0.0,
      valueSubsequenceMultiplier: 0.0,
      maxValueScore: 0.0,
      lowerTimeBound: 0.0,
      upperTimeBound: 20.0,
      timeScoreRate: 1.0,
      maxTimeScore: 10.0,
      actionType: ActionType.inputTextChange,
      scoringType: ActionScoringType.static);

// Common Material Checkbox Component Actions.

final checkboxCheckActionId = 'MaterialCheckbox_Check';
final _checkboxCheck =
  new ActionConfiguration(
      checkboxCheckActionId,
      intrinsicValue: 1.0,
      valueSubsequenceMultiplier: 0.5,
      maxValueScore: 5.0,
      lowerTimeBound: 0.0,
      upperTimeBound: 10.0,
      timeScoreRate: 1.0,
      maxTimeScore: 5.0,
      actionType: ActionType.checkboxCheck,
      scoringType: ActionScoringType.second);

final checkboxUncheckActionId = 'MaterialCheckbox_Uncheck';
final _checkboxUncheck =
  new ActionConfiguration(
      checkboxUncheckActionId,
      intrinsicValue: 1.0,
      valueSubsequenceMultiplier: 0.5,
      maxValueScore: 5.0,
      lowerTimeBound: 0.0,
      upperTimeBound: 10.0,
      timeScoreRate: 1.0,
      maxTimeScore: 5.0,
      actionType: ActionType.checkboxUncheck,
      scoringType: ActionScoringType.static);


// Current Treatments Component Actions.

final currentTreatmentsAddActionId =
    'CurrentTreatmentsComponent_MaterialButton_Add_Click';
final _currentTreatmentsAddClick =
  new ActionConfiguration(
      currentTreatmentsAddActionId,
      intrinsicValue: 0.0,
      valueSubsequenceMultiplier: 0.0,
      maxValueScore: 0.0,
      lowerTimeBound: 0.0,
      upperTimeBound: 10.0,
      timeScoreRate: 1.0,
      maxTimeScore: 5.0,
      actionType: ActionType.buttonClick,
      scoringType: ActionScoringType.static);

final currentTreatmentsRemoveActionId =
    'CurrentTreatmentsComponent_MaterialButton_Remove_Click';
final _currentTreatmentsRemoveClick =
  new ActionConfiguration(
      currentTreatmentsRemoveActionId,
      intrinsicValue: 1.0,
      valueSubsequenceMultiplier: 0.0,
      maxValueScore: 10.0,
      lowerTimeBound: 0.0,
      upperTimeBound: 10.0,
      timeScoreRate: 1.0,
      maxTimeScore: 5.0,
      actionType: ActionType.buttonClick,
      scoringType: ActionScoringType.static);

// Doctor Selection Component Actions.

final doctorSelectionRadioSelectionActionId =
    'DoctorSelectionComponent_MaterialRadio_Selection';
final _doctorSelectionRadioSelection =
new ActionConfiguration(
    doctorSelectionRadioSelectionActionId,
    intrinsicValue: 1.0,
    valueSubsequenceMultiplier: 0.5,
    maxValueScore: 5.0,
    lowerTimeBound: 0.0,
    upperTimeBound: 20.0,
    timeScoreRate: 1.0,
    maxTimeScore: 5.0,
    actionType: ActionType.radioSelection,
    scoringType: ActionScoringType.second);

// Basic Information Panel Element Configuration.

final Map<String, Set<String>> _basicInformationActionOrderings = {
  expansionPanelExpandActionId : new Set.from([
    inputTextChangeActionId, expansionPanelCollapseActionId
  ]),
  expansionPanelCollapseActionId : new Set.from([]),
  inputTextChangeActionId : new Set.from([expansionPanelCollapseActionId]),
};

final _basicInformationExpansionPanelConfig =
  new ElementConfiguration(basicInformationExpansionPanelId,
      [_expansionPanelExpand,
      _expansionPanelCollapse,
      _inputTextChange],
      weight: 1.0,
      workflowOrderingPenalty: 1.0,
      maxIntrinsicValueScore: 100.0,
      maxActionDurationScore: 100.0,
      maxWorkflowOrderingScore: 100.0,
      validActionOrderings: _basicInformationActionOrderings);

// Current Treatments Expansion Panel Element Configuration.

final Map<String, Set<String>> _currentTreatmentsActionOrderings = {
  expansionPanelExpandActionId : new Set.from([
    inputTextChangeActionId,
    expansionPanelCollapseActionId
  ]),
  expansionPanelCollapseActionId : new Set.from([]),
  inputTextChangeActionId : new Set.from([
    currentTreatmentsAddActionId
  ]),
  currentTreatmentsAddActionId : new Set.from([
    inputTextChangeActionId,
    currentTreatmentsRemoveActionId,
    expansionPanelCollapseActionId
  ]),
  currentTreatmentsRemoveActionId : new Set.from([
    inputTextChangeActionId,
    expansionPanelCollapseActionId
  ]),
};

final _currentTreatmentsExpansionPanelConfig =
  new ElementConfiguration(currentTreatmentsExpansionPanelId,
      [_expansionPanelExpand,
      _expansionPanelCollapse,
      _inputTextChange,
      _currentTreatmentsAddClick,
      _currentTreatmentsRemoveClick],
      weight: 1.0,
      workflowOrderingPenalty: 1.0,
      maxIntrinsicValueScore: 100.0,
      maxActionDurationScore: 100.0,
      maxWorkflowOrderingScore: 100.0,
      validActionOrderings: _currentTreatmentsActionOrderings);

// Doctor Selection Expansion Panel Element Configuration.

final Map<String, Set<String>> _doctorSelectionActionOrderings = {
  expansionPanelExpandActionId : new Set.from([
    doctorSelectionRadioSelectionActionId,
    expansionPanelCollapseActionId
  ]),
  expansionPanelCollapseActionId : new Set.from([]),
  doctorSelectionRadioSelectionActionId : new Set.from([
    expansionPanelCollapseActionId
  ]),
};

final _doctorSelectionExpansionPanelConfig =
  new ElementConfiguration(doctorSelectionExpansionPanelId,
      [_expansionPanelExpand,
      _expansionPanelCollapse,
      _doctorSelectionRadioSelection],
      weight: 1.0,
      workflowOrderingPenalty: 1.0,
      maxIntrinsicValueScore: 100.0,
      maxActionDurationScore: 100.0,
      maxWorkflowOrderingScore: 100.0,
      validActionOrderings: _doctorSelectionActionOrderings);

// Preexisting Conditions Expansion Panel Element Configuration.

final Map<String, Set<String>> _preexistingConditionsActionOrderings = {
  expansionPanelExpandActionId : new Set.from([
    checkboxCheckActionId,
    checkboxUncheckActionId,
    expansionPanelCollapseActionId
  ]),
  expansionPanelCollapseActionId : new Set.from([]),
  checkboxCheckActionId : new Set.from([
    checkboxUncheckActionId,
    expansionPanelCollapseActionId
  ]),
  checkboxUncheckActionId : new Set.from([
    checkboxCheckActionId,
    expansionPanelCollapseActionId
  ]),
};

final _preexistingConditionsExpansionPanelConfig =
  new ElementConfiguration(preexistingConditionsExpansionPanelId,
      [_expansionPanelExpand,
      _expansionPanelCollapse,
      _checkboxCheck,
      _checkboxUncheck],
      weight: 1.0,
      workflowOrderingPenalty: 1.0,
      maxIntrinsicValueScore: 100.0,
      maxActionDurationScore: 100.0,
      maxWorkflowOrderingScore: 100.0,
      validActionOrderings: _preexistingConditionsActionOrderings);

// Full Application Configuration

final Map<String, Set<String>> _elementOrderings = {
  basicInformationExpansionPanelId :
    new Set.from([currentTreatmentsExpansionPanelId,
    preexistingConditionsExpansionPanelId,
    doctorSelectionExpansionPanelId]),
  currentTreatmentsExpansionPanelId :
    new Set.from([preexistingConditionsExpansionPanelId,
    doctorSelectionExpansionPanelId]),
  preexistingConditionsExpansionPanelId :
    new Set.from([doctorSelectionExpansionPanelId]),
  doctorSelectionExpansionPanelId : new Set(),
};

final doctorAppConfig = new AppConfiguration(<ElementConfiguration>[
  _basicInformationExpansionPanelConfig,
  _currentTreatmentsExpansionPanelConfig,
  _doctorSelectionExpansionPanelConfig,
  _preexistingConditionsExpansionPanelConfig,
], validElementOrderings: _elementOrderings, workflowOrderingPenalty: 1.0);
