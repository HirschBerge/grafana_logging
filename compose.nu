#!/root/.nix-profile/bin/nu
let filepath =  $"($env.FILE_PWD)"
def main [action: string] {
  cd $filepath
  if $action == "start" { 
    ls | where type == dir | each {|dir| cd $dir.name; docker compose up -d; sleep 1sec}
  } else if $action == "restart" { 
    ls | where type == dir | each {|dir| cd $dir.name; docker compose down; sleep 1sec; docker compose up -d; sleep 1sec}
  } else if $action == "stop" { 
    ls | where type == dir | each {|dir| cd $dir.name; docker compose down; sleep 1sec}
  } else {
    echo "Please enter either \"start,\" \"restart,\" or \"stop.\""
  }
}
