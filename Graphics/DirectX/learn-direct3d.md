# Direct3d learning

> reference:
>
> - [DirectX 11 - Braynzar Soft Tutorials](https://www.braynzarsoft.net/viewtutorial/q16390-braynzar-soft-directx-11-tutorials)

## 初始化

> 本节介绍的是d3d初始化最基础的内容

首先是**四个接口对象**

`IDXGISwapChain`: back buffer交换至front buffer；

和硬件相关的分为两个（负责不同的任务，多线程性能提升考虑）

`ID3D11Device`: 资源加载到内存等功能；

`ID3D11DeviceContext`: 渲染相关的方法。

`ID3D11RenderTargetView`: 画面渲染到这里，代表back buffer。

**最小的d3dapp框架**：

初始化对象-》初始化场景-》在消息循环中更新画面-》释放资源

初始化对象首先要根据实际构建“描述符”，然后调用相关的构造方法。

详细地说，首先描述backbuffer，根据backbuffer描述swapchain，根据描述的交换链创建设备和交换链，通过swapchain的`GetBuffer`方法创建backbuffer（是个`ID3D11Texture2D`对象），然后创建和设置RTV（**will send to the output merger stage of the pipeline**）:

```cpp
bool InitializeDirect3dApp(HINSTANCE hInstance)
{
    HRESULT hr;

    //Describe our Buffer
    DXGI_MODE_DESC bufferDesc;

    ZeroMemory(&bufferDesc, sizeof(DXGI_MODE_DESC));

    bufferDesc.Width = Width;
    bufferDesc.Height = Height;
    bufferDesc.RefreshRate.Numerator = 60;
    bufferDesc.RefreshRate.Denominator = 1;
    bufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    bufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED;
    bufferDesc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;

    //Describe our SwapChain
    DXGI_SWAP_CHAIN_DESC swapChainDesc; 

    ZeroMemory(&swapChainDesc, sizeof(DXGI_SWAP_CHAIN_DESC));

    swapChainDesc.BufferDesc = bufferDesc;
    swapChainDesc.SampleDesc.Count = 1;
    swapChainDesc.SampleDesc.Quality = 0;
    swapChainDesc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    swapChainDesc.BufferCount = 1;
    swapChainDesc.OutputWindow = hwnd; 
    swapChainDesc.Windowed = TRUE; 
    swapChainDesc.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;


    //Create our SwapChain
    hr = D3D11CreateDeviceAndSwapChain(NULL, D3D_DRIVER_TYPE_HARDWARE, NULL, NULL, NULL, NULL,
        D3D11_SDK_VERSION, &swapChainDesc, &SwapChain, &d3d11Device, NULL, &d3d11DevCon);

    //Create our BackBuffer
    ID3D11Texture2D* BackBuffer;
    hr = SwapChain->GetBuffer( 0, __uuidof( ID3D11Texture2D ), (void**)&BackBuffer );

    //Create our Render Target
    hr = d3d11Device->CreateRenderTargetView( BackBuffer, NULL, &renderTargetView );
    BackBuffer->Release();

    //Set our Render Target
    d3d11DevCon->OMSetRenderTargets( 1, &renderTargetView, NULL );

    return true;
}
```

**渲染方法**

deviceContext的`ClearRenderTargetView`方法进行渲染，将颜色绘制到RTV上；

swapchain的present方法将backbuffer呈现到屏幕上。

## 绘制

渲染流水线：

**Input Assembler Stage:** 接收几何输入。初始化阶段需要做的事情：

> create a buffer and set the Primitive Topology, Input Layout, and active buffers.

首先创建buffer，IA需要的buffer包括vertex buffer和index buffer。通过填写`D3D11_BUFFER_DESC`来完成。对于绘制简单的几何图形，只需要vertex buffer，还需要通过`D3D11_SUBRESOURCE_DATA`来填入vertex数据。然后调用`ID3D11Device::CreateBuffer()`来创建buffer。

buffer创建好之后，通过填写`D3D11_INPUT_ELEMENT_DESC`来描述input layout对象。如下例：

```c++
struct Vertex    //Overloaded Vertex Structure
{
    Vertex(){}
    Vertex(float x, float y, float z)
        : pos(x,y,z){}

    XMFLOAT3 pos;
};
D3D11_INPUT_ELEMENT_DESC layout[] =
{
    { "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D11_INPUT_PER_VERTEX_DATA, 0 }, 
};
```

调用`ID3D11Device::CreateInputLayout()`函数来创建IA对象。

之后需要将buffer和IA对象绑定到IA，注意，这里使用的是DeviceContext。此外还要设置图元拓扑：

```c++
ID3D11DeviceContext::IASetVertexBuffers();
ID3D11DeviceContext::IASetInputLayout();
ID3D11DeviceContext::IASetPrimitiveTopology();
```

最后，调用`ID3D11DeviceContext::IASetPrimitiveTopology()`方法将图元绘制(装载)到IA。

**Vertex Shader Stage**: vs可以实现诸如平移、scaling、光线等变换。即使不需要这些变换，也要在流水线中实现这一步。shaders通过hlsl编写，下面简单的例子是直接返回输入的vertex：

```c++
float4 VS(float4 inPos : POSITION) : SV_POSITION
{
    return inPos;
}
```

**栅格化阶段**：包括Hull Shader Stage, Tessellator Stage, Domain shader Stage。栅格化使得图形更为精细，添加细节。新增的图元都在GPU上实现，不涉及CPU，十分高效。

Hull Shader Stage: (programmable) calculate how and where to add new vertices to a primitive to make it more detailed. 

Tessellator Stage: take the input from the Hull Shader, and actually do the dividing of the primitive. 

Domain shader stage: (programmable) take the Positions of the new vertices from the Hull Shader Stage, and transform the vertices recieved from the tessallator stage to create the more detail.

**Geometry Shader Stage:**  以图元作为输入，可以进一步的创造或销毁图元。

**Stream Output Stage：**接受vertex data，并送到不同的buffer中。过滤掉不完整的图元。

**Rasterization Stage Stage:** 将输入的几何信息转为像素，同时将视口外的图元裁剪掉。

**Pixel Shader Stage:** 输入和输出都是pixel fragment。计算最终的颜色，例如下例：

```c++
float4 PS() : SV_TARGET
{
    return float4(0.0f, 0.0f, 1.0f, 1.0f);
}
```

**Output Merger Stage:** 通过深度测试，决定哪些pixel被渲染到RTV上。

pipeline的最后，通过调用`IDXGISwapChain::Present();`方法将back buffer中的内容渲染到屏幕上。