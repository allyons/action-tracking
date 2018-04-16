import 'package:angular/angular.dart';
import 'package:action_tracking/src/action_tracking/action_tracking_data.dart';

/// Injectable model that handles user action event triggers.
///
/// This model should be provided at the app root level and shared between UI
/// components.
@Injectable()
class ActionTrackingModel {
  final stopwatch = new Stopwatch();

  List<ActionTrackingData> sessionData;
  int lastTime = 0;

  void startSession() {
    stopwatch.reset();
    stopwatch.start();
    sessionData = [];
  }

  void stopSession() {
    print(sessionData);
    // Log the session.
  }

  void markExpansionPanelExpansion(bool isExpanded, String elementId) {
    final currentTime = stopwatch.elapsedMilliseconds;
    sessionData.add(new ExpansionPanelData(isExpanded, elementId,
        currentTime, lastTime));
    lastTime = currentTime;
  }

  void markInputTextChange(int inputTextLength, String elementId) {
    final currentTime = stopwatch.elapsedMilliseconds;
    sessionData.add(new InputData(inputTextLength, elementId,
        currentTime, lastTime));
    lastTime = currentTime;
  }

  void markCheckboxChecked(bool isChecked, String elementId) {
    final currentTime = stopwatch.elapsedMilliseconds;
    sessionData.add(new CheckboxData(isChecked, elementId,
        currentTime, lastTime));
    lastTime = currentTime;
  }

  void markRadioSelectionChange(String selection, String elementId) {
    final currentTime = stopwatch.elapsedMilliseconds;
    sessionData.add(new RadioData(selection, elementId, currentTime, lastTime));
    lastTime = currentTime;
  }

  void markButtonClicked(String elementId) {
    final currentTime = stopwatch.elapsedMilliseconds;
    sessionData.add(new ButtonData(elementId, currentTime, lastTime));
    lastTime = currentTime;
  }
}
