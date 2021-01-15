[CmdletBinding()]
param (
    [Switch]
    $SkipBuild,

    [string]
    $BuildConfiguration = "Release"
)

. .\common.ps1

if(!$SkipBuild) {
    BuildApkAndUiTest
}

& $adb uninstall $appPackageName
& $adb uninstall "$appPackageName.test"

$nunitConsole = ChooseCmd(@(
    "nunit3-console",
    "C:\Program Files (x86)\NUnit.org\nunit-console\nunit3-console.exe"))
# you'll need a connected local Android device or Android emulator running
& $nunitConsole `
    ../$uiTestProjName/bin/$BuildConfiguration/$appName.UITest.dll `
    --output=uitest.log

