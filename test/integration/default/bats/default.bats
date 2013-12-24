@test "binary exists: marathon.jar" {
  local file=/opt/marathon/marathon.jar
  [ -e $file ]
}

@test "service is registered: marathon" {
  sudo service marathon status
}

@test "service is registered: marathon" {
  sudo service marathon status
}

@test "service is running: marathon" {
  sudo initctl list | grep "marathon start/running"
}
