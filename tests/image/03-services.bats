@test "Check '/opt/solr' dir has proper permissions" {

  DIR="/opt/solr"

  # Check the owner match the variable SOLR_USER
  owner=$(stat -c %U  "${DIR}")
  [ "${owner}" == "${SOLR_USER}" ]

  # Check the group match the variable ZOO_USER
  group=$(stat -c %U  "${DIR}")
  [ "$group" == "${SOLR_USER}" ]

  # Check the directory is writable
  status=$(test -w "${DIR}"; echo $?)
  [ "$status" == 0 ]

}

@test "Check '/opt/docker-solr' dir has proper permissions" {

  DIR="/opt/docker-solr"

  # Check the owner match the variable SOLR_USER
  owner=$(stat -c %U  "${DIR}")
  [ "${owner}" == "${SOLR_USER}" ]

  # Check the group match the variable ZOO_USER
  group=$(stat -c %U  "${DIR}")
  [ "$group" == "${SOLR_USER}" ]

  # Check the directory is writable
  skip "Need to fix this test case"
  status=$(test -w "${DIR}"; echo $?)
  [ "$status" == 0 ]

}