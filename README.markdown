# PivotPad

Some details to get started:

* GitHub repository: <git@github.com:rubaidh/PivotPad.git>, web UI at <https://github.com/rubaidh/PivotPad>.

* Pivotal Tracker project: <https://www.pivotaltracker.com/projects/137702> -
  project members should have been invited already! This is the PT project for
  planning the app itself, not for testing it!

And for a spot of testing, there's another Pivotal Tracker project:

* Project URL: <https://www.pivotaltracker.com/projects/137703>
* Test Login: <mathie+pivotpad@woss.name>
* Test Password: `iev7Quah`

The test login and password should get you access to the Demo project so we
can test with hardcoded credentials without sharing mine. ;-) See, for
example:

    curl -u mathie+pivotpad@woss.name:iev7Quah -X GET https://www.pivotaltracker.com/services/v3/tokens/active

which is the first thing we'll need to do with the API to get a working token
to get the rest of the information!

## Workflow for retrieving from PT

* Make initial request with username and password to retrieve valid API token.
  If this fails, prompt the user for their username and password.

* When it succeeds, record the active API token for the remainder of the
  session.

* Request a list of projects.

* When the list of projects come back, parse and display the list of projects
  in the UI.

* Then, in the background, potentially in parallel, grab a list of all the
  stories for each project.
