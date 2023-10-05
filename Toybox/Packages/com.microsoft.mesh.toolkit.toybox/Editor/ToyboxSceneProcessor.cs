using System;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Microsoft.MeshApps.Toybox.Editor
{
    public class ToyboxSceneProcessor : IProcessSceneWithReport
    {
        const string packagePrefix = "Packages/com.microsoft.mesh.toolkit.toybox";
        const string beanBagGraph = packagePrefix + "/Runtime/BeanBag/Scripts/BeanBagGraph.asset";
        const string beanBagGraphQuest = packagePrefix + "/Runtime/BeanBag/Scripts/BeanBagGraphQuest.asset";

        public int callbackOrder => 1;

        public void OnProcessScene(Scene scene, BuildReport report)
        {
            if (report == null)
                return;

            try {
                var assetToUse = AssetDatabase.LoadAssetAtPath<ScriptGraphAsset>((report.summary.platform == BuildTarget.Android) ? beanBagGraphQuest : beanBagGraph);
                var assetToReplace = AssetDatabase.LoadAssetAtPath<ScriptGraphAsset>((report.summary.platform == BuildTarget.Android) ? beanBagGraph : beanBagGraphQuest);

                foreach (var go in scene.GetRootGameObjects())
                {
                    foreach (var sm in go.GetComponentsInChildren<ScriptMachine>())
                    {
                        if (sm.nest.macro == assetToReplace)
                        {
                            Debug.Log($"Switching from {assetToReplace.name} to {assetToUse.name} in scene {scene.name}");
                            sm.nest.SwitchToMacro(assetToUse);
                        }
                    }
                }
            }
            catch (Exception e) {
                Debug.LogError($"Error when attempting to swap graphs for quest assets: {e}");
            }
        }
    }
}