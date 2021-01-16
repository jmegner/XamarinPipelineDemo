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
Write-Output "test result files..."
Get-ChildItem "$testResultDir"
Write-Output "what pipeline task could print to publish the test results..."
Get-ChildItem .\artifacts\xmls\ | ForEach-Object { Write-Output `
    ( "##vso[results.publish " `
    + "runTitle=Android App Center UI Test Run $($_.BaseName);" `
    + "resultFiles=$($_.FullName);" `
    + "type=NUnit;" `
    + "mergeResults=false;" `
    + "publishRunAttachments=true;" `
    + "failTaskOnFailedTests=false;" `
    + "testRunSystem=VSTS - PTR;" `
    + "]" `
    )}
