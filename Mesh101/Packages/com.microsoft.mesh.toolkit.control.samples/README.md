# What is the Control Samples package?

The goal of the Control Samples package is to provide a sample library of user interface controls built using the Mesh Toolkit. Controls are authored using Mesh scripting and Graphics Tools.

For these types of features, we want the community to get a chance to see them early. Because they are early in the cycle, we label them as a sample to indicate that they are still evolving, and subject to change over time.

## Getting started

There are a few ways to add the Control Samples package to your project. You an copy and paste the com.microsoft.mesh.toolkit.control.samples folder located in Mesh101\Packages\ into your project's Packages folder. Or, you can reference the Control Samples package from GitHub. To import the Control Samples package into your Unity project via GitHub follow the below steps:

1. In Unity select `Window > Package Manager` from the file menu bar

1. Click the `'+'` icon within the Package Manager and select `"Add package from git URL..."`

    ![Package Manager Add](README~/PackageManagerAdd.png)

1. Paste *https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Mesh101/Packages/com.microsoft.mesh.toolkit.control.samples* into the text field and click `"Add"`

    ![Package Manager Paste](README~/PackageManagerPaste.png)

The Control Samples will now be installed within your Unity project as package within the project's `Packages` folder named `Microsoft Mesh Toolkit Control Samples`. You can now start using prefabs and visual scripts within the Control Samples' runtime folder.

## Adding a button to your scene

Below are steps for adding a button to your scene.

1. Drag and drop `ButtonBase.prefab` into your Unity scene.
1. Give the button a unique name so you can find it later. Let's call our button "SampleButton".

Now you can add any logic to customize the button's behavior.

## List of controls

In the Runtime folder you will find the follow prefab controls:

- **BackplateBase.prefab** - Use this prefab to plate all of your controls on a backplate with rounded corners and an iridescent surface.
- **ButtonBase.prefab** - This prefab is the base prefab used for all button variants. The button animates, produces audio feedback when pressed and contains a label. Uses `Visual Scripting` to hook application logic to button presses.
- **Information_Button.prefab** - This is the prefab for a floating world space coin button. The button features proximity detection via the `Avatar Trigger` behavior: When player enters button range, coin stops spinning and is billboarded instead and player is able to click coin. If player is out of range, they are no longer able to click on the button and button returns to spinning. The button interactable behavior is driven by OCL's `Mesh Interactable Properties` and visual scripting.
