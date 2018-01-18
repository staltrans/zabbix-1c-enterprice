
#
# Получения UUID'ов кластеров 1С
#

# Для 32х битной платформы 1С на 64х битном windows сервере
# $prefix = "${env:ProgramFiles(x86)}\1cv8\"
$prefix = "$env:ProgramFiles\1cv8\"
$suffix = "\bin\rac.exe"
$ver = "8.*.*"

$instances = Get-Item $prefix$ver | Sort-Object -Descending

# Получаем последнюю установленную версию rac
foreach ($inst in $instances) {
    $rac = $inst.FullName + $suffix
    if (Test-Path($rac)) {
        $last_rac = $rac
        break
    }
}

$session_cnt = 0
$clusters = & $last_rac cluster list

foreach ($cl in $clusters) {
    $data = $cl.Split(":",2)
    if ($data[0].Length -ne 0) {
        $key = $data[0].Trim()
        if ($key -eq "cluster") {
            $cluuid = $data[1].Trim()
            $sessions = & $last_rac session --cluster=$cluuid list
            foreach ($s in $sessions) {
                $data = $s.Split(":",2)
                if ($data[0].Length -ne 0) {
                    $key = $data[0].Trim()
                    if ($key -eq "session") {
                        $session_cnt = $session_cnt + 1
                    }
                }
            }
        }
    }
}

$session_cnt