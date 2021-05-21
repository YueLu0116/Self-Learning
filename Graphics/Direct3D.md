# Direct3D

> [Programming guide for Direct3D 11](https://docs.microsoft.com/en-us/windows/win32/direct3d11/dx-graphics-overviews)
>
> quick notes for urgent use in my project

## Devices

### Overview

- A Direct3D device allocates and destroys objects, renders primitives, and communicates with a graphics driver and the hardware. (Resource creation)
- Create at least one **device** for an application:  [**D3D11CreateDevice**](https://docs.microsoft.com/en-us/windows/desktop/api/D3D11/nf-d3d11-d3d11createdevice) or [**D3D11CreateDeviceAndSwapChain**](https://docs.microsoft.com/en-us/windows/desktop/api/D3D11/nf-d3d11-d3d11createdeviceandswapchain)
- **Device context**: set pipeline state and generate rendering commands using the resources owned by a device. Two types, one for immediate rendering and one for deferred rendering. ([**ID3D11Device::GetImmediateContext**](https://docs.microsoft.com/en-us/windows/desktop/api/D3D11/nf-d3d11-id3d11device-getimmediatecontext) and [**ID3D11Device::CreateDeferredContext**](https://docs.microsoft.com/en-us/windows/desktop/api/D3D11/nf-d3d11-id3d11device-createdeferredcontext))

### Layers

- What are layers in d3d11?

  > The Direct3D 11 runtime is constructed with layers, starting with the basic **functionality** at the core and building optional and developer-assist functionality in outer layers.

- Core layer: providing a very thin mapping between the API and the device driver.

- Debug layer: provides extensive additional parameter and consistency validation.

  More info: [Using the debug layer to debug apps](https://docs.microsoft.com/en-us/windows/win32/direct3d11/using-the-debug-layer-to-test-apps)

## Resources

### Overview

- Resources including texture data, vertex data, and shader data provide data to the pipeline and define what is rendered during your scene.
- The lifecycle:
  - Create using one of the create methods of the [**ID3D11Device**](https://docs.microsoft.com/en-us/windows/desktop/api/D3D11/nn-d3d11-id3d11device) interface.
  - Bind a resource to the pipeline.
  - Deallocate a resource.
- fully typed resources: the format is restricted and enables runtime optimization; typeless resources: can be reused in another format.
- Resources view: used by a pipeline to interpret data.

### **Buffers**

-  ([**ID3D11Buffer**](https://docs.microsoft.com/en-us/windows/desktop/api/D3D11/nn-d3d11-id3d11buffer) interface)
- Vertex buffer: contains the vertex data used to define your geometry.
  1. define its layout: calling the [**ID3D11Device::CreateInputLayout**](https://docs.microsoft.com/en-us/windows/desktop/api/D3D11/nf-d3d11-id3d11device-createinputlayout) to create an ID3D11InputLayput interface.
  2. bind the input layout to the input-assembler stage by calling the [**ID3D11DeviceContext::IASetInputLayout**](https://docs.microsoft.com/en-us/windows/desktop/api/D3D11/nf-d3d11-id3d11devicecontext-iasetinputlayout).
  3. create a vertex buffer, call [**ID3D11Device::CreateBuffer**](https://docs.microsoft.com/en-us/windows/desktop/api/D3D11/nf-d3d11-id3d11device-createbuffer).
- Index buffer: index buffers contain integer offsets into **vertex buffers** and are used to render primitives more efficiently.
- constant buffer: supply shader constants data to the pipeline.

### **Textures**

- A texture resource is a structured collection of data designed to store texels. (**what is the difference between texture and buffer?) 1D, 2D, and 3D.

- block compression.

### **Tiled**

- large logical resources that use small amounts of physical memory.

- More info: [Why are tiled resources needed?](https://docs.microsoft.com/en-us/windows/win32/direct3d11/why-are-tiled-resources-needed-)

## Pipeline

### Overview

![](C:\Users\Admin\Desktop\notes\self-learning\Graphics\images\d3d11-pipeline-stages.jpg)

- stages mean different functional areas.

### Input-Assembler Stage

- read primitive data (points, lines and/or triangles) from user-filled buffers and assemble the data into primitives that will be used by the other pipeline stages. The IA stage can **assemble vertices into several different [primitive types](https://docs.microsoft.com/en-us/windows/win32/direct3d11/d3d10-graphics-programming-guide-primitive-topologies) (such as line lists, triangle strips, or primitives with adjacency). 
- Basic steps:
  1. [Create Input Buffers](https://docs.microsoft.com/en-us/windows/win32/direct3d11/d3d10-graphics-programming-guide-input-assembler-stage-getting-started#create-input-buffers);
  2. [Create the Input-Layout Object](https://docs.microsoft.com/en-us/windows/win32/direct3d11/d3d10-graphics-programming-guide-input-assembler-stage-getting-started#create-the-input-layout-object);
  3. [Bind Objects to the Input-Assembler Stage](https://docs.microsoft.com/en-us/windows/win32/direct3d11/d3d10-graphics-programming-guide-input-assembler-stage-getting-started#bind-objects-to-the-input-assembler-stage);
  4. [Specify the Primitive Type](https://docs.microsoft.com/en-us/windows/win32/direct3d11/d3d10-graphics-programming-guide-input-assembler-stage-getting-started#specify-the-primitive-type);
  5. [Call draw methods](https://docs.microsoft.com/en-us/windows/win32/direct3d11/d3d10-graphics-programming-guide-input-assembler-stage-getting-started#call-draw-methods).

### Vertex Shader Stage

- Performing per-vertex operations such as transformations, skinning, morphing, and per-vertex lighting. Vertex shaders always operate on a single input vertex and produce a single output vertex. 

### Tessellation Stage

- converts low-detail subdivision surfaces into higher-detail primitives on the GPU.

### Geometry Shader Stage

The geometry-shader (GS) stage runs application-specified shader code with vertices as input and the ability to generate vertices on output.

### Stream-Output Stage

Continuously output (or stream) vertex data from the geometry-shader stage (or the vertex-shader stage if the geometry-shader stage is inactive) to one or more buffers in memory.

### Rasterizer Stage

The rasterization stage converts vector information (composed of shapes or primitives) into a raster image (composed of pixels) for the purpose of displaying real-time 3D graphics.

### Pixel Shader Stage

enables rich shading techniques such as per-pixel lighting and post-processing. 

### Output-Merge Stage

The output-merger (OM) stage generates the final rendered pixel color using a combination of pipeline state, the pixel data generated by the pixel shaders, the contents of the render targets, and the contents of the depth/stencil buffers. 

## Compute Shader

todo

## Rendering

todo

## References

https://github.com/Microsoft/DirectXTK/wiki/Getting-Started

https://github.com/walbourn/directx-sdk-samples/wiki