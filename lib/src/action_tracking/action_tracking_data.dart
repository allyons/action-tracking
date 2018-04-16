/// Base data model for runtime action tracking.
///
/// An instance of this class is created each time a user action is observed.
abstract class ActionTrackingData {
  final String elementId;
  final int mostRecentTimestamp;
  final int timestamp;

  ActionTrackingData(this.elementId, this.timestamp, this.mostRecentTimestamp);
}

/// A user action indicating that input text was changed.
class InputTextData extends ActionTrackingData {
  final bool textAdded;

  InputTextData(this.textAdded, String elementId, int timestamp,
      int mostRecentTimestamp):
        super(elementId, timestamp, mostRecentTimestamp);
}

/// A user action indicating that expansion panel expansion was changed.
class ExpansionPanelData extends ActionTrackingData {
  final bool isExpanded;

  ExpansionPanelData(this.isExpanded, String elementId,
      int timestamp, int mostRecentTimestamp):
        super(elementId, timestamp, mostRecentTimestamp);

  /// toString() override for debugging.
  @override
  String toString() {
    return
      '\nType: MaterialExpansionPanel'
      '\nElementId: ' + elementId +
      '\nTimestamp: ' + timestamp.toString() +
      '\nDuration: ' + (timestamp - mostRecentTimestamp).toString() +
      '\nAction: ' +
          MaterialComponentActionType.expansionPanelExpanded.toString() +
      '\nExpanded: ' + '$isExpanded\n';
  }
}

/// A user action indicating that input text was changed.
class InputData extends ActionTrackingData {
  final int inputTextLength;

  InputData(this.inputTextLength, String elementId,
      int timestamp, int mostRecentTimestamp):
        super(elementId, timestamp, mostRecentTimestamp);

  /// toString() override for debugging.
  @override
  String toString() {
    return
      '\nType: MaterialInput'
      '\nElementId: ' + elementId +
      '\nTimestamp: ' + timestamp.toString() +
      '\nDuration: ' + (timestamp - mostRecentTimestamp).toString() +
      '\nAction: ' +
      MaterialComponentActionType.inputTextChanged.toString() +
      '\nTextLength: ' + '$inputTextLength\n';
  }
}

/// A user action indicating that a checkbox checked status was changed.
class CheckboxData extends ActionTrackingData {
  final bool isChecked;

  CheckboxData(this.isChecked, String elementId,
      int timestamp, int mostRecentTimestamp):
        super(elementId, timestamp, mostRecentTimestamp);

  /// toString() override for debugging.
  @override
  String toString() {
    return
      '\nType: MaterialCheckbox'
          '\nElementId: ' + elementId +
          '\nTimestamp: ' + timestamp.toString() +
          '\nDuration: ' + (timestamp - mostRecentTimestamp).toString() +
          '\nAction: ' +
          MaterialComponentActionType.checkboxChecked.toString() +
          '\nChecked: ' + '$isChecked\n';
  }
}

/// A user action indicating that a radio selection status was changed.
class RadioData extends ActionTrackingData {
  final String selection;

  RadioData(this.selection, String elementId,
      int timestamp, int mostRecentTimestamp):
        super(elementId, timestamp, mostRecentTimestamp);

  /// toString() override for debugging.
  @override
  String toString() {
    return
      '\nType: MaterialRadio'
          '\nElementId: ' + elementId +
          '\nTimestamp: ' + timestamp.toString() +
          '\nDuration: ' + (timestamp - mostRecentTimestamp).toString() +
          '\nAction: ' +
          MaterialComponentActionType.radioSelected.toString() +
          '\nSelection: ' + '$selection\n';
  }
}

/// A user action indicating that a button was clicked.
class ButtonData extends ActionTrackingData {

  ButtonData(String elementId, int timestamp, int mostRecentTimestamp):
        super(elementId, timestamp, mostRecentTimestamp);

  /// toString() override for debugging.
  @override
  String toString() {
    return
      '\nType: MaterialButton'
          '\nElementId: ' + elementId +
          '\nTimestamp: ' + timestamp.toString() +
          '\nDuration: ' + (timestamp - mostRecentTimestamp).toString() +
          '\nAction: ' +
          MaterialComponentActionType.buttonClicked.toString() + '\n';
  }
}

/// Enum list of supported material component actions.
enum MaterialComponentActionType {
  expansionPanelExpanded,
  inputTextChanged,
  checkboxChecked,
  radioSelected,
  buttonClicked
}
