if(!$env:ANDROID_HOME) {
    $env:ANDROID_HOME = "C:\Program Files (x86)\Android\android-sdk"
}

if(!$env:JAVA_HOME) {
    $env:JAVA_HOME = (Get-ChildItem 'C:\Program Files\Android\jdk\*jdk*')[0].FullName
}


appcenter test run uitest `
    --app "JacobEgnerDemos/XamarinPipelineDemo" `
    --app-path (Get-ChildItem -Recurse "..\*Signed.apk")[0].FullName `
    --devices "JacobEgnerDemos/two_devices" `
    --test-series "master" `
    --locale "en_US" `
    --build-dir "..\XamarinPipelineDemo.UITest\bin\Release" `
    --uitest-tools-dir "..\XamarinPipelineDemo.UITest\bin\Release" `
    --test-output-dir ".\artifacts"

# I'd love to add a `--merge-nunit-xml "AppCenterUiTestResult.xml"` to the
# command, but that gives an error and I have filed an issue:
# https://github.com/microsoft/appcenter-cli/issues/1208

Expand-Archive "artifacts\nunit_xml_zip.zip"
