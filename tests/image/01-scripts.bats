@test "script 'docker-entrypoint.sh' should be present" {
  run which docker-entrypoint.sh
  [ $status -eq 0 ]
}

@test "script 'init-solr-home' should be present" {
  run which init-solr-home
  [ $status -eq 0 ]
}


@test "script 'run-initdb' should be present" {
  run which run-initdb
  [ $status -eq 0 ]
}


@test "script 'solr-create' should be present" {
  run which solr-create
  [ $status -eq 0 ]
}


@test "script 'solr-demo' should be present" {
  run which solr-demo
  [ $status -eq 0 ]
}


@test "script 'solr-foreground' should be present" {
  run which solr-foreground
  [ $status -eq 0 ]
}


@test "script 'solr-precreate' should be present" {
  run which solr-precreate
  [ $status -eq 0 ]
}


@test "script 'start-local-solr' should be present" {
  run which start-local-solr
  [ $status -eq 0 ]
}


@test "script 'stop-local-solr' should be present" {
  run which stop-local-solr
  [ $status -eq 0 ]
}

@test "script 'wait-for-solr.sh' should be present" {
  run which wait-for-solr.sh
  [ $status -eq 0 ]
}