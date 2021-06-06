# Introduction to DirectX 11

> notes from: https://www.3dgep.com/introduction-to-directx-11/#DirectX_Demo

## Introduction

### What is DirectX?

**DirectX** is a collection of application programming interfaces (API). The components of the DirectX API provides low-level access to the hardware running on a Windows based Operating System.

### What is DXGI (briefly)?

DXGI helps to enumerate devices or control how data is presented to an output.

### The pipeline

![d3d11-pipeline](.\\images\\DirectX-11-Rendering-Pipeline.png)

## Demo

### Aims

Render a 3d geometory using a minimal vertex sharer and pixel shader.

### Organize my VS projects

1. Put cpp source files into a subdirectory named "src":

   Add item -> location -> new src

2. Set output directory to "bin":

   Select Configuration Properties > General and change the Output Directory to bin\\.

3. Change the targets name in Debug mode to xxd：

   In the Debug configuration only, change the Target Name to $(ProjectName)d (due to step 2, release and debug output files will be put into the same directory).

4. Express paths in programs relative to the exe:

   Select Configuration Properties > Debugging and change the Working Directory to $(OutDir) for both the Debug and Release configurations.

5. Set a directory for publicly included files.

6. Use precomplied header:

   in pch.cpp:

   ```cpp
   #include <pch.h>
   ```

   for the whole project:

   - Select Configuration Properties > C/C++ > Precompiled Headers and set the Precompiled Header option to Use (/Yu).
   - Set the **Precompiled Header File** option to the name of the created header file.

   for the pch.cpp header only:

   change the **Precompiled Header** option to **Create (/Yc)** 

7. for linking to some libraries:

   use `#pragma comment(lib, "xxx.lib")` instead of adding **Additional Dependencies** property in the **Linker** options

### Key points

1. device, device context, and swapchain;
2. resource views: an area of a buffer that can be used for rendering
3. depth buffer
4. states: 
5. viewport: the size of the viewport rectangle;
6. data:
   - input layout;
   - vertex and index buffer;
   - vertex and pixel shaders;
   - const buffers:
     - application:  An example of an application level shader variable is the camera’s projection matrix. Usually the projection matrix is initialized once when the render window is created and only needs to be updated if the dimensions of the render window are changed;
     - frame: An example of a frame level shader variable would be the camera’s view matrix which changes whenever the camera moves. 
     - object: An example of an object level shader variable is the object’s world matrix.
   - matrix:
     - world matrix: transform the object’s vertices into world space.
     - view matrix: store the camera’s view matrix that will transform the object’s vertices from world space into view space.
     - projection matrix: transform the object’s vertices from view space into clip space.

### Minimum WindowProc callback function

1. **Paint**: The window procedure must respond to the `WM_PAINT` window message. We don’t actually do any rendering with this message except erase the window’s background contents using the window class’s background brush.

2. **Destroy**: In order to close the window, respond to the `WM_DESTROY` window message which simply calls the `PostQuitMessage` function.

   ```cpp
   LRESULT CALLBACK WndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
   {
       PAINTSTRUCT paintStruct;
       HDC hDC;
   
       switch (message)
       {
       case WM_PAINT:
       {
           hDC = BeginPaint(hwnd, &paintStruct);
           EndPaint(hwnd, &paintStruct);
       }
       break;
       case WM_DESTROY:
       {
           PostQuitMessage(0);
       }
       break;
       default:
           return DefWindowProc(hwnd, message, wParam, lParam);
       }
   
       return 0;
   }
   ```

3. Message processing function:

   Basic procedure: Peek-Translate-Dispatch Message

### Initialize DirectX

**Steps**:

1. Create the device and swap chain,
2. Create a render target view of the swap chain’s back buffer,
3. Create a texture for the depth-stencil buffer,
4. Create a depth-stencil view from the depth-stencil buffer,
5. Create a depth-stencil state object that defines the behaviour of the output merger stage,
6. Create a rasterizer state object that defines the behaviour of the rasterizer stage.

### About shaders



