# Simple clone all script for our repos (windows users only)
# Declare string variables we'll be reusing
# Declare Common string
# Declare the repos
# Org github Page
# UI project
# API
# Front-End
# Deployment info
# Planning
# Functions and their functions below
# git pull all repos in hashtable above
# git clone all repos in hashtable above
# Make Project directory if you haven't already to hold all repos for project
# Output complete messages
# Ouput here message
# Output nothere message
# Main function 
# Check if current location is "Luncher"
# If we are in Luncher, check for children
# If there are children
# Hardcode initial array of directory names
# deep copy initial array for later use
# Declare empty array of the repos missing from the system.
# Get the children directories of the project folder with helper function
# Resolve the relative paths for easy manipulation
# Add the list of folders that are present to the present array
# Populate the missing array with any unique repo names
# Call remaining functions as needed
# Call main function
# Call wrapper function

function cloneAll {  
  $all = [ordered]@{
    M     = "Luncher";
    repos = [ordered]@{
      GP  = "lambdaluncher.github.io"; 
      UI  = "luncher_ui"; 
      API = "luncher_back_end"; 
      FE  = "luncher_front_end"; 
      DY  = "Deployment"; 
      PG  = "luncher_planning"
    };
    Paths = @{
      L  = "..\Luncher";
      LR = "..\Luncher\*"
    };
    msgs  = @{
      nothere = "No repos present, will start building project folder.";
      here    = "All the repos are here, I'll just pull everything.";
      done    = "All done, check what changed!";
    }
  }
  function pull { Get-ChildItem -recurse -filter ".git" -hidden | ForEach-Object {split-path $_.fullname} | ForEach-Object {Push-Location $_; git pull; Pop-Location}}
  function clone { $all.repos.ForEach( {git clone "https://github.com/$_.git"}); git clone 'https://github.com/fireinjun/LuncherSecrets.git'}
  function mkmain { mkdir $all.M; Push-Location $all.M}
  function done {Write-Output $all.msgs.done}
  function here {Write-Output $all.msgs.here}
  function nothere {Write-Output $all.msgs.nothere}
  function main {
    if (Test-Path -Path $all.Paths.L) {
      if (Test-Path -Path $all.Paths.LR) { 
        $initial = @(
          "Deployment",
          "lambdaluncher.github.io",
          "LuncherSecrets",
          "luncher_back_end",
          "luncher_front_end",
          "luncher_planning",
          "luncher_ui",
          "nginx",
          "assets"  
        );
        $present = $initial | ForEach-Object { $_ }
        $missing = @();
        function childDir {
          $all.Paths.LR |
            Resolve-Path -Relative | 
            ForEach-Object {$present += ($_).trimstart('.\')}
        }
        function popMissing {
          $missing += $present | Sort-Object -Unique
        }
        childDir
        popMissing
        here; pull; done
      }
      else {
        clone; done
      }
    }
    else {
      nothere; mkmain; clone; done
    };
  }
  main
}
cloneAll