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