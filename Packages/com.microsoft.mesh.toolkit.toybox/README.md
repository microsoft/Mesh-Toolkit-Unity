# What is the Toybox package?

Toybox is a Unity Engine package that empowers creators to build interactive experiences and games for Microsoft Mesh. This package provides visual scripts, assets, and shaders to help jumpstart creating activities for Mesh environments while staying within performance budgets.

## Getting started

There are a couple of ways to add the Toybox package to your project.

1. Copy and paste the com.microsoft.mesh.toolkit.toybox folder located in this repository's Packages folder into your project's Packages folder.
2. Reference the Toybox package from GitHub.

> [!IMPORTANT]
> To reference the Toybox package from GitHub you must have [Git](https://gitforwindows.org/) installed on your computer.

To import the Toybox package into your Unity project using GitHub:

1. In your project, on the menu bar, select Window > Package Manager.

1. In the Package Manager, click the '+' drop-down and then select "Add package from git URL..."

    ![Package Manager Add](README~/PackageManagerAdd.png)

1. Paste <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.toybox> into the text field and then click Add.

    ![Package Manager Paste](README~/PackageManagerPaste.png)

The Toybox package will now be installed in your Unity project as a package in the project's Packages folder with the name Microsoft Mesh Toolkit Toybox. You can now start using prefabs and visual scripts within the Toybox runtime folder.

> [!TIP]
> It is advised you use a specific release of the Toybox package to ensure your project is locked to a release.

You can reference a specific release version, branch, or git commit hash by altering the URL in step 3 as demonstrated below:

| Syntax           | URL example                                                                                                                                     |
|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| Specific version | <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.toybox#vX.Y.Z>                                   |
| Specific branch  | <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.toybox#my_branch>                                |
| Git commit hash  | <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.toybox#badc0ffee0ddf00ddead10cc8badf00d1badb002> |

## List of activities

In the Runtime folder you will find the following activities:

- Bean Bag Toss - two versions :trophy:
- Fire Pit & Roasting Marshmallows :fire:
- Ice Breaker :interrobang:
- Sound Orbs :notes:
- Radio & Boombox :musical_note:
- *Bonus: Astronaut :rocket:*
