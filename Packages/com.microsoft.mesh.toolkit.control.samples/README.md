# What is the Control Samples package?

The goal of the Control Samples package is to provide a sample library of user interface controls built using the Mesh Toolkit. Controls are authored using Mesh scripting and Graphics Tools.

For these types of features, we want the community to get a chance to see them early. Because they are early in the cycle, we label them as a sample to indicate that they are still evolving, and subject to change over time.

## Getting started

There are a couple of ways to add the Control Samples package to your project.

1. Copy and paste the com.microsoft.mesh.toolkit.control.samples folder located in this repository's Packages folder into your project's Packages folder.
2. Reference the Control Samples package from GitHub.

> [!IMPORTANT]
> To reference the Control Samples package from GitHub you must have [Git](https://gitforwindows.org/) installed on your computer.

To import the Control Samples package into your Unity project using GitHub:

1. In your project, on the menu bar, select Window > Package Manager.

1. In the Package Manager, click the '+' drop-down and then select "Add package from git URL..."

    ![Package Manager Add](README~/PackageManagerAdd.png)

1. Paste <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.control.samples> into the text field and then click Add.

    ![Package Manager Paste](README~/PackageManagerPaste.png)

The Control Samples package will now be installed in your Unity project as a package in the project's Packages folder with the name Microsoft Mesh Toolkit Control Samples. You can now start using prefabs and visual scripts within the Control Samples runtime folder.

> [!TIP]
> It is advised you use a specific release of the Control Samples package to ensure your project is locked to a release.

You can reference a specific release version, branch, or git commit hash by altering the URL in step 3 as demonstrated below:

| Syntax           | URL example                                                                                                                                              |
|------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| Specific version | <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.control.samples#vX.Y.Z>                                   |
| Specific branch  | <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.control.samples#my_branch>                                |
| Git commit hash  | <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.control.samples#badc0ffee0ddf00ddead10cc8badf00d1badb002> |

## List of controls

In the Runtime folder you will find the following prefab controls:

- **BackplateBase.prefab** - Use this prefab to plate all of your controls on a backplate with rounded corners and an iridescent surface.
- **ButtonBase.prefab** - This prefab is the base prefab used for all button variants. The button animates, produces audio feedback when pressed and contains a label. Use `Visual Scripting` to hook application logic to button presses.
- **InformationButton.prefab** - This is the prefab for a floating world space coin button. The button features proximity detection via the `Avatar Trigger` behavior: When player enters button range, coin stops spinning and is billboarded instead and player is able to click coin. If player is out of range, they are no longer able to click on the button and button returns to spinning. The button interactable behavior is driven by OCL's `Mesh Interactable Properties` and `Visual Scripting`.
- **Earth.prefab** - This prefab for an Earth globe that can be spun and selected. When selected the globe generates a latitude and longitude position and adds a marker. This functionality can be extended and modified with `Visual Scripting`. All actions are shared by all clients by default.
