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

### 渲染流水线

**Input Assembler Stage:** 接收几何输入。初始化阶段需要做的事情：

> create a buffer and set the Primitive Topology, Input Layout, and active buffers.

首先创建buffer，IA需要的buffer包括vertex buffer和index buffer。通过填写`D3D11_BUFFER_DESC`来完成。对于绘制简单的几何图形，只需要vertex buffer，还需要通过`D3D11_SUBRESOURCE_DATA`来填入vertex**数据**。然后调用`ID3D11Device::CreateBuffer()`来创建buffer。

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

### 实现

**接口**

```c++
ID3D11Buffer* triangleVertBuffer;    // 描述顶点数据
ID3D11VertexShader* VS;              // 存储着色器
ID3D11PixelShader* PS;
ID3D10Blob* VS_Buffer;               // 内存中的着色器信息
ID3D10Blob* PS_Buffer;
ID3D11InputLayout* vertLayout;       // IA对象
```

**修改后的InitScene**

1. **着色器**相关：编译-》创建-》设置着色器

   运行时编译调用：`D3DX11CompileFromFile`函数

   创建：`ID3D11Device::CreateVertexShader()`

   设置：调用`ID3D11DeviceContext::VSSetShader()`和`ID3D11DeviceContext::PSSetShader()`

2. **缓冲(顶点)**相关：描述、创建和设置缓冲到IA：

   填写`D3D11_BUFFER_DESC`描述缓冲，填写`D3D11_SUBRESOURCE_DATA`来描述数据;

   调用`ID3D11Device::CreateBuffer()`创建缓冲；

   调用`ID3D11Devicecontext::IASetVertexBuffers()`设置缓冲到IA；

3. **IA对象**相关：创建和设置

   调用`ID3D11Device::CreateInputLayout() `来创建IA对象；

   调用`ID3D11DeviceContext::IASetInputLayout()`来设置（绑定）IA对象到IA;

4. **其他**：设置图元拓扑、视口相关、渲染

## 着色

基本结构与上节相同，只需要增加RGBA输入。

## 深度测试

TODO

## 空间与矩阵

### 各种空间的概念

**local space**：物体的自身坐标系；

**world space**: 描述各物体间的位置关系，主要用来实现每个物体的转换(transformation)

> World Space is defined by individual transformations on each object, Translations, Rotations, and Scaling. 

**view space**：视角（相机）的位置：

> The camera is positioned at point (0, 0, 0) where the camera is looking down the z-axis, the up direction of the camera is the y-axis, and the world is translated into the cameras space. So when we do transformations, it will look like the camera is moving around the world, when in fact, the world is moving, and the camera is still.

**projection space**: 透视，物体离camera的远近。遮挡的部分被丢弃，未遮挡的部分保留渲染。有如下几个变量：

> FOV (Field of view in radians), aspect ratio, near z-plane, and far z-plane.

**screen space**：略。

实际渲染过程是将物体从world space转到projection space。流程如下：

> The objects vertices in Local Space will be sent to the Vertex Shader. The VS will use the WVP passed into it right before we called the draw function, and multiply the vertices position with the **WVP matrix**.

### 代码实现

**WVP矩阵**要保存到constant buffers中。描述+创建buffer，示例：

```c++
struct cbPerObject
{
    XMMATRIX  WVP;
};
cbPerObject cbPerObj;

D3D11_BUFFER_DESC cbbd;    
ZeroMemory(&cbbd, sizeof(D3D11_BUFFER_DESC));
cbbd.Usage = D3D11_USAGE_DEFAULT;
cbbd.ByteWidth = sizeof(cbPerObject);
cbbd.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
cbbd.CPUAccessFlags = 0;
cbbd.MiscFlags = 0;
hr = d3d11Device->CreateBuffer(&cbbd, NULL, &cbPerObjectBuffer);
```

设置ViewMatrix (**camera**)。由三个向量组成。（==具体原理还要看看书==）

```c++
camPosition = XMVectorSet( 0.0f, 0.0f, -0.5f, 0.0f );
camTarget = XMVectorSet( 0.0f, 0.0f, 0.0f, 0.0f );
camUp = XMVectorSet( 0.0f, 1.0f, 0.0f, 0.0f );
camView = XMMatrixLookAtLH( camPosition, camTarget, camUp );
```

设置**投影矩阵**，填充几个相关的变量：

```c++
camProjection = XMMatrixPerspectiveFovLH( 0.4f*3.14f, (float)Width/Height, 1.0f, 1000.0f);

```

将三个矩阵按照顺序相乘得到WVP：

```c++
WVP = World * camView * camProjection;
```

传进着色器的WVP要求是转置的，还需要调用deviceContext的`UpdateSubresource()`和`VSSetConstantBuffers()`上传设置到vertex shader的constant buffer中：

```c++
cbPerObj.WVP = XMMatrixTranspose(WVP);
d3d11DevCon->UpdateSubresource( cbPerObjectBuffer, 0, NULL, &cbPerObj, 0, 0 );
d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbPerObjectBuffer );
```

着色器代码中定义常量buffer：

>  Remember to separate them and name them on the frequency in which they are updated. 

```c++
cbuffer cbPerObject
{
    float4x4 WVP;
};
VS_OUTPUT VS(float4 inPos : POSITION, float4 inColor : COLOR)
{
    VS_OUTPUT output;

    output.Pos = mul(inPos, WVP);
    output.Color = inColor;

    return output;
}
```

