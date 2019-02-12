<!DOCTYPE html>
<html lang="en">
<head>
  <title>zPlanner</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="bootstrap.min.css">
  <script src="jquery.min.js"></script>
  <script src="popper.min.js"></script>
  <script src="bootstrap.min.js"></script>
  <style>
  .fakeimg {
      height: 200px;
      background: #aaa;
  }
  </style>
</head>
<body>

<div class="jumbotron text-center" style="margin-bottom:0">
  <h1 class="text-danger">zPlanner</h1>
  <p>VM Storage analytics monitoring for public cloud and WAN connectivity sizing</p> 
</div>

<nav class="navbar justify-content-center navbar-expand-sm bg-dark navbar-dark">
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="collapsibleNavbar">
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link" href="/">Home</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" title="Graphical View of Stat Data" href="grafana.php">Grafana</a>
      </li>
    <!-- Dropdown -->
    <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
        VM Monitoring
      </a>
      <div class="dropdown-menu">
        <a class="dropdown-item" title="Select VMs to monitor" href="monitor.php">Add VMs</a>
        <a class="dropdown-item" title="Remove VMs from monitoring" href="unmonitor.php">Remove VMs</a>
      </div>
    </li>
 <li class="nav-item">
      <a class="nav-link disabled" title="Future Functionality" href="#">VPG Planning</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" title="PHPMyAdmin Control Panel for Exporting SQL data" href="/phpmyadmin/">DB Administration</a>
    </li>
      <li class="nav-item">
        <a class="nav-link" href="#">Documentation</a>
      </li>
        <li class="nav-item">
          <a class="nav-link" href="about.php">About</a>
        </li>
    </ul>
  </div>  
</nav>

<div class="container" style="margin-top:30px">
  <div class="row">
    <div class="col-sm-4">
      <h2>Project Info</h2>
      <h5>GitHub Repository</h5>
      <img src="img/github.png" class="rounded" alt="GitHub">
      <p>All zPlanner code is available on <a href="https://github.com/recklessop/zplanner">Github</a>. Updates are downloaded from Github nightly and on demand from the console.</p>
      <h3>Open Source Components</h3>
      <p>Besides the custom code developed specifically for zPlanner, there are other open source components used. Below are links to those projects.</p>
      <ul class="nav nav-pills flex-column">
        <li class="nav-item">
        </li>
        <li class="nav-item">
          <a class="nav-link" href="http://ubuntu.com">Ubuntu</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="https://docs.microsoft.com/en-us/powershell/">PowerShell Core</a>
        </li>
        <li class="nav-item">
          <a class="nav-link disabled" href="https://www.powershellgallery.com/packages/VMware.PowerCLI/10.2.0.9372002">VMware PowerCLI</a>
        </li>
        <li class="nav-item">
          <a class="nav-link disabled" href="https://www.grafana.com">Grafana</a>
        </li>
      </ul>
      <hr class="d-sm-none">
    </div>
    <div class="col-sm-8">
      <h2>GETTING STARTED</h2>
      <h5>Initial Configuration of zPlanner</h5>
      <p>From the zPlanner console, please run option 1 to update this zPlanner appliance before doing any other configuration.</p>
      <p>Once updates have been applied configuring zPlanner is as easy as walking through the steps on the console. Note: If DHCP is not available you will need to use menu option 2 in order to configure
	a static IP address, then run option 1 to update the appliance.</p>
      <p>From there run menu option 3, 4, 5, 6, and 7. Once those proceedures are completed you can select VMs to monitor from the "VM Monitoring" drop down menu in the ribbon above. 
	Once you have selected all of the VMs you would like to monitor, return to the Homepage and select "Grafana" from the menu ribbon."
      <p>The login credentials for Grafana are "admin" and "admin". After 5 minutes you should start to see data populate in the graphs and tables.
      <br>
    </div>
  </div>
</div>

<div class="jumbotron text-center" style="margin-bottom:0">
  <p>See the documentation for all support related questions <a href="https://jpaul.me/zplanner-docs/>https://jpaul.me/zplanner-docs/</a>.</p>
</div>

</body>
</html>
