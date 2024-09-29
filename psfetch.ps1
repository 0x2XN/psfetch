function getTimeStamp{
    return Get-Date;
}

$t1 = getTimeStamp;
$asciiLine= @(
'⠀⠀⠀⠀⠀⠀⣰⣾⠁⠀⢦⣾⣤⠆⠀⠻⣧⠀⠀⠀⠀⠀⠀'
'⠀⠀⠀⠀⢠⣼⠏⠀⠀⠀⠀⣿⡇⠀⠀⠀⠈⢷⣄⠀⠀⠀⠀'
'⠀⠀⢀⣸⣿⠃⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⢿⣧⡀⠀⠀'
'⠀⢰⣾⣿⡁⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⢀⣿⣿⠖⠀'
'⠀⠀⠈⠻⣿⣦⣄⠀⠀⠀⠀⣿⡇⠀⠀⠀⢀⣴⣿⠟⠁⠀⠀'
'⠀⠀⠀⠀⠈⠻⢿⣷⣄⡀⠀⣿⡇⠀⣠⣾⣿⠟⠁⠀⠀⠀⠀'
'⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣦⣿⣧⣾⣿⠟⠁⠀⠀⠀⠀⠀⠀'
'⠀⠀⠀⠀⠀⠀⠀⠀⠀⢙⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀'
'⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀'
'⠀⠀⠀⠀⠀⢀⣴⣿⣿⠟⠁⣻⣿⠈⠙⢿⣿⣦⡀⠀⠀⠀⠀'
'⠀⠀⠀⢀⣴⣿⡿⠋⠀⠀⠀⣽⣿⠀⠀⠀⠙⢿⣿⣦⣄⠀⠀'
'⠀⣠⣴⣿⡿⠋⠀⠀⠀⠀⠀⢼⣿⠀⠀⠀⠀⠀⠈⢻⣿⣷⣄'
'⠈⠙⢿⣿⣦⣄⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⣠⣾⣿⠟⠁'
'⠀⠀⠀⠙⢿⣿⣷⣄⠀⠀⠀⢸⣿⠀⠀⠀⣠⣾⣿⠟⠁⠀⠀'
'⠀⠀⠀⠀⠀⠙⢻⣿⣷⡄⠀⢸⣿⠀⠀⣼⣿⣿⠃⠀⠀⠀⠀'
'⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣦⣸⣿⣠⣾⣿⠟⠁⠀⠀⠀⠀⠀'
'⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀'
'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀'
);

#color
$esc = [char]0x1B;
$list = "${esc}[1;91m";
$ascii = "${esc}[1;91m";
$val = "${esc}[97m";
$reset = "${esc}[0m";

#dim
$listPad =  "⠀" * 12;
$topPad = 6;
$botPad = 6;
$leftPad = "⠀" * 10;
$block = "⠀" * 2;


#direct pwsh
function getDate {
    return Get-Date -Format " dd MMM yy HH:mm (UTCz)";
}

function getUptm {
    $upt = get-uptime
    return "$($upt.hours) hrs $($upt.minutes) mins $($upt.seconds) secs"
}

function getLang {
    #return (get-culture).name
    $lang = Get-WinUserLanguageList
    return $lang[0].autonym
}

#win32_operatingsystem
$cimses = new-cimsession;
$osw32 = get-CimInstance -classname win32_operatingsystem -property caption, csname, registereduser, freephysicalmemory, totalvisiblememorysize -cimsession $cimses;

#create function
function getUser {
    return $osw32.registereduser +"@"+$osw32.csname;
}

function getUserDivider {#bar below user to divide from list
    $usern = getUser;
    return  "-" * ([System.Text.Encoding]::UTF8.GetBytes($usern)).Length;
}

function getOs {
    return $osw32.caption;
}

function getRam{
    $fRam = [math]::floor($osw32.freephysicalmemory / 1kb);
    $tRam = [math]::floor($osw32.totalvisiblememorysize / 1kb);
    $usdRam =  ($tRam - $fRam);
    $prcRam = [math]::floor(($usdRam / $tRam) * 100);
    return $usdRam.toString() + " MiB / " + $tRam.toString() + " MiB (" + $prcRam.toString() + "%)";
}

#win32_videocontroller
$disp = get-CimInstance -class win32_videocontroller -property name, CurrentHorizontalResolution, CurrentVerticalResolution, currentrefreshrate;

function getGpu {
    return $disp[0].name;
}

function getRes {
    $resX = $disp.CurrentHorizontalResolution[0].toString();
    $resY = $disp.CurrentVerticalResolution[0].toString();
    $refr = $disp.currentrefreshrate[0].toString();
    return  $resX + "x" + $resY + " @" + $refr +"hz";
}

#win32_logicaldisk
$disk =  get-CimInstance -class win32_logicaldisk -property freespace, size -filter "drivetype=3";
function getStrg {
    $fStorg = [math]::floor(($disk | Measure-Object -Property freespace -Sum).sum /1gb);
    $tStorg = [math]::floor(($disk | Measure-Object -Property size -Sum).sum / 1gb);
    $usdStorg = ($tStorg - $fStorg);
    $prcStorg = [math]::floor(($usdStorg / $tStorg) * 100);
    return $usdStorg.toString() +" GiB / " + $tStorg.toString() + " GiB (" + $prcStorg.toString() + "%)";
}

#win32_processor
$cpu = get-CimInstance -class win32_processor -property name; #, numberofcores, threadcount, numberoflogicalprocessors

function getCpu {
    return $cpu.name; #+" " + $cpu.numberofcores + "Cores " + $cpu.threadcount + "Threads"
}

#win32_baseboard
$mobo = get-CimInstance -class win32_baseboard -property product;
function getMbd {
    return $mobo.product;
}

#colorbar
function getClrBar1 {
    $outp = @();
    $colors = @(
        "${esc}[100m", # Bright Black (Gray)
        "${esc}[101m", # Bright Red
        "${esc}[102m", # Bright Green
        "${esc}[103m", # Bright Yellow
        "${esc}[104m", # Bright Blue
        "${esc}[105m", # Bright Magenta
        "${esc}[106m", # Bright Cyan
        "${esc}[107m",  # Bright White
        "${esc}[0m"
    )
    foreach ($color in $colors) {
        $outp += "$color$block";
    }   
    return $outp;
}
function getClrBar2 {
    $outp = @();
    $colors = @(
        "${esc}[40m",  # Black
        "${esc}[41m",  # Red
        "${esc}[42m",  # Green
        "${esc}[43m",  # Yellow
        "${esc}[44m",  # Blue
        "${esc}[45m",  # Magenta
        "${esc}[46m",  # Cyan
        "${esc}[47m",  # White
        "${esc}[0m"
    )
    foreach ($color in $colors) {
        $outp += "$color$block";
    }
    return $outp;
}

$date = getDate;
$uptm = getUptm;
$lang = getLang;
$user = getUser;
$dvdr = getUserDivider;
$osys = getOs;

$mobo = getMbd;
$cpus = getCpu;
$gpus = getGpu;
$sres = getRes;

$rams = getRam;
$strg = getStrg;

$cbr1 = getClrBar1;
$cbr2 = getClrBar2;
Remove-CimSession -CimSession $cimses;

$text = @(
    "⠀"
    "${list}$user"
    "${val}$dvdr"
    "${list}OS: ${val}$osys"
    "${list}Date: ${val}$date"
    "${list}UpTime: ${val}$uptm"
    "${list}Language: ${val}$lang"
    
    "${list}MoBo: ${val}$mobo"
    
    "${list}Res: ${val}$sres"
    "${list}Memory: ${val}$rams"
    "${list}Storage: ${val}$strg"

    
    "${list}CPU: ${val}$cpus"
    "${list}GPU: ${val}$gpus"
    
    "⠀"
    "⠀"
    "${cbr1}"
    "${cbr2}"
    "⠀"
)


$ascPad = "⠀" * $asciiLine[0].length;
$rText = $text.length;
$rAscc = $asciiLine.length;
$rTotl = 0;

$birb = $topPad + 5;


if ($rAscc -gt $rText){
    $rTotl = $asciiLine.length;
}else{
    $rTotl = $text.length;
}

$rTotl += $topPad

$j = 0;
$k = 0;
for($i = 0; $i -lt $rTotl; $i++){

    if($i -lt $topPad){
        write-host $ascPad;
    }else{
        
        if($i -lt ($rAscc + $topPad) ){
            write-host $leftPad -nonewline
            write-host "${ascii}$($asciiLine[$k])${reset}" -nonewline;
            
            $k++
        } else {
            write-host ($leftPad + $ascPad) -nonewline;
        }

        if($i -lt ($rText + $topPad)){
            write-host ($listPad) -nonewline;
            write-host $text[$j];
            $j++;
        } else {
            write-host $leftPad;
        }

    }

    
}

for($i = 0; $i -lt $botPad; $i++){ write-host $ascPad; }  


$t2= getTimeStamp
#write-host "$($t2 - $t1)"
#>
