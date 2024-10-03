# What is the Microsoft Mesh Toolkit Environment package?

The goal of the Environment package is to provide a common package of assets (materials, models, prefabs, etc.) that help with Mesh environment production.

> [!IMPORTANT]
> The Environment package is still a work in progress and contains a limited set of assets. The current release does not contain common shaders required to render all assets appropriately (a future release will contain these shaders) in the meantime ensure your project also contains the Pavilion project's *Assets/_Shaders* folder  content to render all assets correctly.

## Getting started

There are a couple of ways to add the Environment package to your project.

1. Copy and paste the com.microsoft.mesh.toolkit.environment folder located in this repository's Packages folder into your project's Packages folder.
2. Reference the Environment package from GitHub.

> [!IMPORTANT]
> To reference the Environment package from GitHub you must have [Git](https://gitforwindows.org/) installed on your computer.

To import the Environment package into your Unity project using GitHub:

1. In your project, on the menu bar, select Window > Package Manager.

1. In the Package Manager, click the '+' drop-down and then select "Add package from git URL..."

    ![Package Manager Add](README~/PackageManagerAdd.png)

1. Paste <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.environment> into the text field and then click Add.

    ![Package Manager Paste](README~/PackageManagerPaste.png)

The Environment package will now be installed in your Unity project as a package in the project's Packages folder with the name Microsoft Mesh Toolkit Environment. You can now start using content within the runtime folder.

> [!TIP]
> It is advised you use a specific release of the Environment package to ensure your project is locked to a release.

You can reference a specific release version, branch, or git commit hash by altering the URL in step 3 as demonstrated below:

| Syntax           | URL example                                                                                                                                     |
|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| Specific version | <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.environment#vX.Y.Z>                                   |
| Specific branch  | <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.environment#my_branch>                                |
| Git commit hash  | <https://github.com/microsoft/Mesh-Toolkit-Unity.git?path=/Packages/com.microsoft.mesh.toolkit.environment#badc0ffee0ddf00ddead10cc8badf00d1badb002> |
