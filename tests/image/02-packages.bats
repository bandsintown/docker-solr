@test "package 'java' should be present" {
  run which java
  [ $status -eq 0 ]
}

@test "package 'lsof' should be present" {
  run which lsof
  [ $status -eq 0 ]
}

@test "package 'bash' should be present" {
  run which bash
  [ $status -eq 0 ]
}

@test "package 'tar' should be present" {
  run which tar
  [ $status -eq 0 ]
}

@test "package 'su-exec' should be present" {
  run which su-exec
  [ $status -eq 0 ]
}

@test "package 'su-exec' should have proper permissions" {
  result=$(stat -c "%a" $(which su-exec))
  [ $result -eq 4755 ]
}