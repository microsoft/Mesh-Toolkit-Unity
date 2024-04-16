# What is the Control Samples package?

The goal of the Control Samples package is to provide a sample library of user interface controls built using the Mesh Toolkit. Controls are authored using Mesh scripting and Graphics Tools.

For these types of features, we want the community to get a chance to see them early. Because they are early in the cycle, we label them as a sample to indicate that they are still evolving, and subject to change over time.

## Getting started

There are a few ways to add the Control Samples package to your project: a) copy and paste the *com.microsoft.mesh.toolkit.control.samples* folder located in this repository's `Packages` folder into your project's `Packages` folder, or b) reference the Control Samples package from GitHub. To use this second method, follow these steps:

1. In Unity select `Window > Package Manager` from the file menu bar

1. Click the `'+'` icon within the Package Manager and select `"Add package from git URL..."`

    ![Package Manager Add](README~/PackageManagerAdd.png)

1. Paste *https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.control.samples* into the text field and click `"Add"`

    ![Package Manager Paste](README~/PackageManagerPaste.png)

The Control Samples will now be installed within your Unity project as package within the project's `Packages` folder named `Microsoft Mesh Toolkit Control Samples`. You can now start using prefabs and visual scripts within the Control Samples' runtime folder.

## List of controls

In the Runtime folder you will find the following prefab controls:

- **BackplateBase.prefab** - Use this prefab to plate all of your controls on a backplate with rounded corners and an iridescent surface.
- **ButtonBase.prefab** - This prefab is the base prefab used for all button variants. The button animates, produces audio feedback when pressed and contains a label. Use `Visual Scripting` to hook application logic to button presses.
- **InformationButton.prefab** - This is the prefab for a floating world space coin button. The button features proximity detection via the `Avatar Trigger` behavior: When player enters button range, coin stops spinning and is billboarded instead and player is able to click coin. If player is out of range, they are no longer able to click on the button and button returns to spinning. The button interactable behavior is driven by OCL's `Mesh Interactable Properties` and `Visual Scripting`.
- **Earth.prefab** - This prefab for an Earth globe that can be spun and selected. When selected the globe generates a latitude and longitude position and adds a marker. This functionality can be extended and modified with `Visual Scripting`. All actions are shared by all clients by default.
