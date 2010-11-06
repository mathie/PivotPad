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
