# Direct3D tutorials

> forked repo: https://github.com/YueLu0116/directx-sdk-samples

## Direct3D 11 Basics

### Target: draw a window

### Set up d3d device

1. Create a window using win32 apis;

2. Create a device, an immediate context, and a swap chain:

   - device: perform both rendering and resource creation. `D3D11CreateDevice()`

   - the immediate context:  perform rendering onto a buffer, and the device contains methods to create resources.

   - swap chain: taking the buffer to which the device renders, and displaying the content on the actual monitor screen. Swap chain contains two or more buffers: Obtain DXGI factory from device first.

     1. the front buffer: is what is being presented currently to the user. 
     2. the back buffer: is the render target to which the device will draw.

     - the swap chain will present the backbuffer by swapping the two buffers.

3. Create a render target view: A render target view is a type of resource view in Direct3D 11. A resource view allows a resource to be bound to the graphics pipeline at a specific stage.

4. Initialize the viewport: The viewport maps clip space coordinates, where X and Y range from -1 to 1 and Z ranges from 0 to 1, to render target space, sometimes known as pixel space.

### Modify the message loop

**GetMessage()** blocks and does not return until a message is available. Thus, instead of doing something like rendering, our application is waiting within **GetMessage()** when the message queue is empty. **PeekMessage()** can retrieve a message like **GetMessage()** does, but when there is no message waiting, **PeekMessage()** returns immediately instead of blocking. We can then take this time to do some rendering. 

### Use the immediate context to render

## Rendering a triangle

### Input layout

Defines how these attributes lie in memory. Each vertex attribute can be described with the D3D11_INPUT_ELEMENT_DESC structure.

1. Define the input layout: set a D3D11_INPUT_ELEMENT_DESC struct;
2. Create the input layout: ID3D11Device `CreateInputLayout()`;
3. Set the input layout: ID3D11DeviceContext `IASetInputLayout()`.

### Vertex layout

The vertex shaders are tightly coupled with this vertex layout. The reason is that creating a vertex layout object requires the vertex shader's input signature. We use the ID3DBlob object returned from D3DX11CompileFromFile to retrieve the binary data that represents the input signature of the vertex shader. Once we have this data, we can call **ID3D11Device::CreateInputLayout()** to create a vertex layout object, and **ID3D11DeviceContext::IASetInputLayout()** to set it as the active vertex layout.

### Create a vertex buffer

### Primitive Topology

We can make the vertex buffer smaller if we can tell the GPU that when rendering the second triangle, instead of fetching all three vertices from the vertex buffer, use 2 of the vertices from the previous triangle and fetch only 1 vertex from the vertex buffer.

### Rendering the Triangle

- The vertex shader is responsible for transforming the individual vertices of the triangles to their correct locations. 
- The pixel shader is responsible for calculating the final output color for each pixel of the triangle.

## Shaders and Effect System

- What is a shader: In Direct3D 11, shaders reside in different stages of the graphics pipeline. They are short programs that, executed by the GPU, take certain input data, process that data, and then output the result to the next stage of the pipeline.

- Three types of shaders: vertex shader, geometry shader, and pixel shader. When rendering with Direct3D 11, the GPU must have a valid vertex shader and pixel shader. Geometry shader is an advanced feature in Direct3D 11 and is optional
- A primitive is a point, a line, or a triangle.

### Vertex shaders

- The GPU iterates through the vertices in the **vertex buffer**, and executes the active vertex shader once for each vertex, passing the vertex's data to the vertex shader as input parameters.

- The most important job of a vertex shader is transformation. Transformation is the process of converting vectors from one coordinate system to another. 

- In the Direct3D 11 tutorials, we will write our shaders in **High-Level Shading Language (HLSL)**.

  ```
  float4 VS( float4 Pos : POSITION ) : SV_POSITION
  {
      return Pos;
  }
  ```

  POSITION as the semantics of the Pos input parameter because this parameter will contain the vertex position. The return value's semantics, SV_POSITION, is a pre-defined semantics with special meaning. This semantics tells the graphics pipeline that the data associated with the semantics defines the clip-space position.

### Pixel shaders

We light up the group of pixels that are covered by the triangle's area. The process of converting a triangle defined by three vertices to a bunch of pixels covered by the triangle is called **rasterization**. 

### Create the shaders

**D3DX11CompileFromFile()**





