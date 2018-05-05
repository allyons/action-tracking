import 'package:action_tracking/src/action_tracking/action_tracking_configuration.dart';

/// Base data model for in-app action tracking.
///
/// An instance of this class is created each time a user action is observed.
abstract class ActionTrackingData {
  final String elementId;
  final String actionId;
  final int duration;
  final int timestamp;
  final ActionType actionType;
  final ComponentType componentType;

  ActionTrackingData(
      this.elementId,
      this.actionId,
      this.componentType,
      this.actionType,
      this.timestamp,
      int mostRecentTimestamp) : duration = timestamp - mostRecentTimestamp;

  /// toString() override for debugging.
  @override
  String toString() {
    return
      '\nComponent: ' + componentType.toString() +
      '\nAction: ' + actionType.toString() +
      '\nElementId: ' + elementId +
      '\nActionId: ' + actionId +
      '\nTimestamp: ' + timestamp.toString() +
      '\nDuration: ' + duration.toString() +
      '\n';
  }
}

/// A user action indicating that expansion panel expansion was changed.
class ExpansionPanelData extends ActionTrackingData {
  final bool isExpanded;

  ExpansionPanelData(this.isExpanded, String elementId, String actionId,
      int timestamp, int mostRecentTimestamp):
        super(
          elementId,
          actionId,
          ComponentType.expansionPanel,
          isExpanded ? ActionType.expansionPanelExpand :
            ActionType.expansionPanelCollapse,
          timestamp,
          mostRecentTimestamp);
}

/// A user action indicating that input text was changed.
class InputData extends ActionTrackingData {
  final int inputTextLength;

  InputData(this.inputTextLength, String elementId, String actionId,
      int timestamp, int mostRecentTimestamp):
        super(
          elementId,
          actionId,
          ComponentType.input,
          ActionType.inputTextChange,
          timestamp,
          mostRecentTimestamp);
}

/// A user action indicating that a checkbox checked status was changed.
class CheckboxData extends ActionTrackingData {
  final bool isChecked;

  CheckboxData(this.isChecked, String elementId, String actionId,
      int timestamp, int mostRecentTimestamp):
        super(
          elementId,
          actionId,
          ComponentType.checkbox,
          isChecked ? ActionType.checkboxCheck :
          ActionType.checkboxUncheck,
          timestamp,
          mostRecentTimestamp);
}


/// A user action indicating that a radio selection status was changed.
class RadioData extends ActionTrackingData {
  final String selection;

  RadioData(this.selection, String elementId, String actionId,
      int timestamp, int mostRecentTimestamp):
        super(
          elementId,
          actionId,
          ComponentType.radio,
          ActionType.radioSelection,
          timestamp,
          mostRecentTimestamp);
}

/// A user action indicating that a button was clicked.
class ButtonData extends ActionTrackingData {

  ButtonData(String elementId, String actionId, int timestamp,
      int mostRecentTimestamp):
    super(
      elementId,
      actionId,
      ComponentType.button,
      ActionType.buttonClick,
      timestamp,
      mostRecentTimestamp);
}
