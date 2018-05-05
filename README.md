# Action Tracking (Columbia University SEAS)

Tracking tools for user actions in [AngularDart](https://webdev.dartlang.org/angular) web apps.
This library also includes an example app using [AngularDart Components](https://webdev.dartlang.org/components).

The standalone tools for ATSI are located in /action_tracking/lib/standalone/.
The example application is located in /action_tracking/lib/src/, which integrates the ATSI action tracking module and
data visualization tool.

# How to configure ATSI:

1. Follow the Dart SDK installation instructions at https://www.dartlang.org/tools/sdk#install. This installs pub, the
Dart package manager.

2. Clone or download the ATSI repository at https://github.com/allyons/action-tracking. The library also includes an
example AngularDart web application with simulated workflows that illustrate the functions of each of ATSI’s features.

3. Configure ATSI. A Sample Configuration is provided in:
/action_tracking/lib/src/action_tracking/doctor_app_configuration.dart

# How to run ATSI with the example application:

1. From the action_tracking directory, run “pub get” to update package dependencies.
2. Run “pub serve” to start the web server, then access the application from the port in your web browser.

# How to run ATSI with your own project:

1. Add a dependency from your application root to the ATSI tracking module.
2. Provide the ATSI tracking module in your app's configuration.
3. Inject the tracking module in any components that should track user actions.
4. Set up start and end triggers for a user workflow.
5. Mark user actions in the tracking module from each UI component.
6. Override the stopSession() method in the tracking module to save each user session report.
7. Add the data visualization component in your developer dashboards to see the results of aggregated workflow reports.

# How to develop ATSI further:

1. Add to any of ATSI's features located in /action_tracking/lib/standalone/. Contributions are always welcome!