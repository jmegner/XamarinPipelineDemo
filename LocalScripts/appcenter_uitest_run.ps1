[CmdletBinding()]
param (
    [Switch]
    $SkipBuild,

    [string]
    $BuildConfiguration = "Release"
)

. .\common.ps1

echo $appName

if(!$SkipBuild) {
    BuildApkAndUiTest
}

[string] $testOutputDir = ".\artifacts"
[string] $testResultDir = "$testOutputDir\xmls"
[string] $orgName = "JacobEgnerDemos"

appcenter test run uitest `
    --app "$orgName/$appName" `
    --app-path "$env:UITEST_APK_PATH" `
    --devices "$orgName/demo_device_set" `
    --test-series "master" `
    --locale "en_US" `
    --build-dir "..\$uiTestProjName\bin\$BuildConfiguration" `
    --uitest-tools-dir "..\$uiTestProjName\bin\$BuildConfiguration" `
    --test-output-dir $testOutputDir

# I'd love to add a `--merge-nunit-xml "AppCenterUiTestResult.xml"` to the
# command, but that gives an error and I have filed an issue:
# https://github.com/microsoft/appcenter-cli/issues/1208

Expand-Archive "$testOutputDir\nunit_xml_zip.zip" -DestinationPath "$testResultDir"
Get-ChildItem "$testResultDir"
