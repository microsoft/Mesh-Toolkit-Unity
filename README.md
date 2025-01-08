# Mesh Toolkit for Unity

![A banner showing the words "Mesh Toolkit for Unity" and avatars roasting marshmallows near a campfire.](README/mesh-toolkit-banner.png)

The Mesh Toolkit enables creators and developers to build custom 3D environments and experiences to meet specific business needs: new employee onboarding, training, guided tours, social gatherings, and more.This repo contains tutorial and sample projects that you can use as a starting point for building your custom 3D experiences.  

## Getting started

For detailed instructions on getting started with development for Microsoft Mesh, [visit our documentation at learn.microsoft.com](https://aka.ms/MeshDeveloper).

You can begin creating a custom 3D environment from one of our [tutorials](#tutorials) or [samples](#samples). Or, [install the Mesh Toolkit](#installing-the-mesh-toolkit) in your own Unity project.

### Installing the Mesh Toolkit

To add the Mesh toolkit package to your Unity project:

1. Open your Unity project, and then on the menu bar, select **Edit** > **Project Settings** > **Package Manager**.

1. Add a scoped registry with the following details:

   - **Name:** Mesh Toolkit

   - **URL:** https://registry.npmjs.org

   - **Scopes(s):** com.microsoft

   ![A screenshot of the Project Settings window with the Package Manager Scope Registry Configuration displayed.](README/install-download-package.png)

1. Click the **Save** button.
1. Close the **Project Settings** window, and then, on the menu bar, go to **Window** > **Package Manager**.

1. In the toolbar, click the **Packages** dropdown and then select **My Registries**.

   ![A screenshot of the Package Manager with the Packages drop down highlighted.](README/install-packages-drop-down.png)

1. In the list, you'll see the current build of the **Microsoft Mesh Toolkit**.

    Select **Microsoft Mesh Toolkit** (the full package name should be **com.microsoft.mesh.toolkit**, as highlighted in the image below) and then click the **Install** button.

   ![A screenshot of the Unity package manager showing details of the preview Mesh toolkit.](README/install-mesh-toolkit-in-package-manager.png)

When the spinner animation next to the package list stops, the package has finished downloading.

### Tutorials

If you're new to Mesh and like the idea of learning through a step-by-step tutorial, we recommend that you try one of our tutorials.

| [![Mesh 101](README/tutorial-mesh-101.jpg)](https://aka.ms/Mesh101Tutorial) | [![Mesh 201](README/tutorial-mesh-201.jpg)](https://aka.ms/Mesh201Tutorial) |
|:--- | :--- |
| [**Mesh 101**](https://aka.ms/Mesh101Tutorial): Start here to learn about foundational features in the Mesh Toolkit. | [**Mesh 201**](https://aka.ms/Mesh201Tutorial): Explore more of the Mesh Toolkit. Learn how to pull external data sources into Mesh. |

### Samples

You can start with a sample project to quickly get inspired about what you can build with Mesh. These projects are already set up with the Mesh toolkit.

| [![Pavilion](README/sample-pavilion.jpg)](https://aka.ms/MeshPavilionSample) | [![Physics showcase projects](README/sample-physics.jpg)](https://aka.ms/MeshPhysicsEffectsSample) |
|:--- | :--- |
| [**Pavilion**](https://aka.ms/MeshPavilionSample): A minimalist, modular, and high-performance environment for Mesh creators to explore interactive activities and assets created with the Mesh Toolkit. | [**Physics showcase projects**](https://aka.ms/MeshPhysicsEffectsSample): Get things moving with physics in three example projects: a [physics effects gallery](https://aka.ms/MeshPhysicsEffectsSample), a [science building](https://aka.ms/MeshScienceBuildingSample), or a [dart room](https://aka.ms/MeshDartRoomSample). |

### Packages

Many of the tutorials and samples are built using reusable packages. You are encouraged to use these building blocks in your own projects to kickstart development.

| [![Toybox Package](README/package-toybox.jpg)](https://learn.microsoft.com/mesh/develop/getting-started/samples/toybox#add-the-toybox-package-to-an-existing-project) | [![Control Samples Package](README/package-control-samples.jpg)](https://learn.microsoft.com/mesh/develop/getting-started/samples/control-samples) |
|:--- | :--- |
| [**Toybox Package**](https://learn.microsoft.com/mesh/develop/enhance-your-environment/toybox): Add games and other engaging activities to your Mesh experiences. | [**Control Samples Package**](https://learn.microsoft.com/mesh/develop/build-your-basic-environment/control-samples): Provides common in-world user interface controls. |

**NOTICE**: The tutorials, samples, and packages in this project are governed by the MIT license as shown in the [LICENSE.txt file](https://github.com/microsoft/Mesh-Toolkit-Unity/blob/main/LICENSE). However, the samples functionality is dependent on the Mesh Toolkit, which is governed by a separate license.

## Contributing

Mesh is a new product from Microsoft, and at this time we are not accepting code contributions to our repo.  If you have any feedback or if you run into any issues with the samples or the Mesh Toolkit, you can let us know in the following two ways:

1. In a Unity project that has the Mesh Toolkit package installed, select **Mesh Toolkit** -> **Give feedback to Microsoft** and then use the feedback link in the Mesh Toolkit to let us know.

2. Connect with us and the community by joining the [Microsoft Mesh Creator discussion space!](https://techcommunity.microsoft.com/t5/mesh-creators/bd-p/MeshCreators)

## Trademarks

Trademarks This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft’s Trademark & Brand Guidelines](https://www.microsoft.com/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party’s policies.
