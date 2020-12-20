using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Xamarin.UITest;
using Xamarin.UITest.Configuration;
using Xamarin.UITest.Utils;

[assembly: System.Reflection.AssemblyVersionAttribute("0.0.0.0")]
namespace XamarinPipelineDemo.UITest
{
    public static class AppInitializer
    {
        public static IApp StartApp(Platform platform)
        {
            if (platform == Platform.Android)
            {
                return ConfigureApp.Android
                    .Debug()
                    .EnableLocalScreenshots()
                    .ApkFileFromEnvironmentOrPreinstalledApp("com.demo.XamarinPipelineDemo")
                    .StartApp();
            }

            return ConfigureApp.iOS
                .EnableLocalScreenshots()
                .StartApp();
        }

        private static AndroidAppConfigurator ApkFileFromEnvironmentOrPreinstalledApp(
            this AndroidAppConfigurator app,
            string preinstalledAppName)
        {
            var envApkPath = "UITEST_APK_PATH";
            var envKeystorePath = "UITEST_KEYSTORE_PATH";
            var envKeystorePassword = "UITEST_KEYSTORE_PASSWORD";
            var envKeyAlias = "UITEST_KEY_ALIAS";
            var envKeyPassword = "UITEST_KEY_PASSWORD";
            var allKeystoreEnvs = new[] { envKeystorePath, envKeystorePassword, envKeyAlias, envKeyPassword };
            var allEnvs = allKeystoreEnvs.Concat(new[] { envApkPath }).ToArray();

            var envDict = allEnvs.ToDictionary(envName => envName, envName => Environment.GetEnvironmentVariable(envName));

            foreach(var entry in envDict)
            {
                Console.WriteLine($"DEMO_NOTE: envDict key='{entry.Key}' value='{entry.Value}'");
            }

            if(!string.IsNullOrWhiteSpace(envDict[envApkPath]))
            {
                Console.WriteLine($"DEMO_NOTE: using apk file");
                app = app.ApkFile(envDict[envApkPath]);
            }
            else
            {
                Console.WriteLine($"DEMO_NOTE: using preinstalled app name");
                app = app.InstalledApp(preinstalledAppName);

                if(allKeystoreEnvs.All(envName => !string.IsNullOrWhiteSpace(envDict[envName])))
                {
                    Console.WriteLine($"DEMO_NOTE: using keystore");
                    app = app.KeyStore(
                        envDict[envKeystorePath],
                        envDict[envKeystorePassword],
                        envDict[envKeyPassword],
                        envDict[envKeyAlias]);
                }
            }

            return app;
        }

    }
}
