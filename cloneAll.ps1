# Simple clone all script for our repos (windows users only)
function cloneAll {
  # Declare string variables we'll be reusing here
  $all = [ordered]@{
    # Declare the repos
    repos = @{
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
    vars  = @{
      M = "Luncher";
      
    };
    msgs  = @{
      dir     = "This isn't the project directory. Check your location!";
      present = "All the repos are here, I'll just pull everything.";
      done    = "All done, check what changed!"
    }
  }
  function Pull {
    Get-ChildItem -recurse -filter ".git" -hidden | ForEach-Object {split-path $_.fullname} | % {pushd $_; git pull; popd}
  }
  function Clone {
    git clone "https://github.com/fireinjun/LuncherSecrets.git"
    $repos.ForEach( {git clone "https://github.com/lambdaluncher/$_.git"})
  }
  # Make Project directory if you haven't already to hold all repos for project
  function Maker {
    mkdir $all.vars.M; Push-Location $all.vars.M
  }
  
  function CheckDir {
    function get {Convert-Path .}
    function BackOne {set-location (Convert-Path . | split-path  -Parent)};
    
  }
  if (Test-Path -Path "..\Luncher") {
    if ("..\Luncher\*" | Resolve-Path -Relative -eq % {".\$all.repos.($_)"}) {
      Write-Output $all.msgs.present; Pull; Write-Output $all.msgs.done
    }
    else {
      Clone
    }
  }
  if ( Resolve-Path . -Relative -eq % {"..\$all.repos.($_)"}) {
    Test-Path -Path "../Luncher"
  }

}