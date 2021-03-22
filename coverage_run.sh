#!/bin/bash
# expects that "tox" has been run
COVERAGE=.tox/py37-dj22/bin/coverage
$COVERAGE run --source salesforce manage.py check >/dev/null
for x in py35-dj20 py36-dj21 py38-dj30 py39-dj31; do
    .tox/${x}/bin/coverage run -a --source salesforce manage.py inspectdb --database=salesforce >/dev/null
    .tox/${x}/bin/coverage run -a --source salesforce manage.py test salesforce
done
for x in $(ls -d tests/test_* | sed "s%/%.%"); do
    $COVERAGE run -a --source salesforce manage.py test --settings=$x.settings $x
done
$COVERAGE html
$COVERAGE report
