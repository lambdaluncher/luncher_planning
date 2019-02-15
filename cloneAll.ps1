# Simple clone all script for our repos (windows users only)
function cloneAll {
  # Declare string variables we'll be reusing here
  $all = [ordered]@{
    # Declare Common string
    M     = "Luncher";
    # Declare the repos
    repos = [ordered]@{
      # Org github Page
      GP  = "lambdaluncher.github.io"; 
      # UI project
      UI  = "luncher_ui"; 
      # API
      API = "luncher_back_end"; 
      # Front-End
      FE  = "luncher_front_end"; 
      # Deployment info
      DY  = "Deployment"; 
      # Planning
      PG  = "luncher_planning"
    };
    Paths = @{
      L  = "..\Luncher";
      LR = "..\Luncher\*"
    };
    msgs  = @{
      dir     = "This isn't the project directory. Check your location!";
      present = "All the repos are here, I'll just pull everything.";
      done    = "All done, check what changed!";
    }
  }
  # git pull all repos in hashtable above
  function pull { Get-ChildItem -recurse -filter ".git" -hidden | ForEach-Object {split-path $_.fullname} | ForEach-Object {Push-Location $_; git pull; Pop-Location}}
  # git clone all repos in hashtable above
  function clone { $all.repos.ForEach( {git clone "https://github.com/$_.git"}); git clone 'https://github.com/fireinjun/LuncherSecrets.git'}
  # Make Project directory if you haven't already to hold all repos for project
  function mkmain { mkdir $all.M; Push-Location $all.M}

  # Main function 
  function main {
    # Check if current location is "Luncher"
    # If we are in Luncher, check for children
    if (Test-Path -Path $all.Paths.L) {
      # If there are children
      if (Test-Path -Path $all.Paths.LR) { 
        # Hardcode initial array of directory names
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
        # deep copy initial array for 
        $present = $initial | ForEach-Object { $_ }
        # Declare empty array of the repos missing from the system.
        $missing = @();
        # Get the children directories of the project folder
        function childDir {
          $all.Paths.LR |
            # Resolve the relative paths for easy manipulation
          Resolve-Path -Relative | 
            # Add the list of folders that are present to the present array
          ForEach-Object {$present += ($_).trimstart('.\')}
        }
        # Populate the missing array with any unique repo names
        function popMissing {
          $missing += $present | Sort-Object -Unique
        }
        childDir
        popMissing
        Write-Output $all.msgs.present; pull; Write-Output $all.msgs.done
      }
      else {
        clone; 
      }
    }
    else {
      mkmain; clone
    };
  }
  main
}
cloneAll