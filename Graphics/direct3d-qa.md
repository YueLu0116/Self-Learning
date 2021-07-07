# Q&A on Direct3d

## References

### Where can I learn directx?

1. Three online tutorials:
   - [rastertek-tutorials](https://www.rastertek.com/tutdx11.html)
   - [directx-tutorials](http://www.directxtutorial.com/Lesson.aspx?lessonid=111-1-1)
   - [3dgep-tutorials](https://www.3dgep.com/introduction-to-directx-11/#DirectX_Project)
2. official docs and guides:
   - [direct3d11 programming guide](https://docs.microsoft.com/en-us/windows/win32/direct3d11/dx-graphics-overviews)
   - [microsoft directx samples](https://github.com/microsoft/DirectX-Graphics-Samples)
   - [unofficial directx tutorials](https://github.com/walbourn/directx-sdk-samples)

## Baiscs

### Mipmap is frequently mentioned so what is it?

> [Texture Filtering with Mipmaps](https://docs.microsoft.com/en-us/windows/win32/direct3d9/texture-filtering-with-mipmaps#:~:text=A%20mipmap%20is%20a%20sequence,smaller%20than%20the%20previous%20level.&text=Direct3D%20represents%20mipmaps%20as%20a%20chain%20of%20attached%20surfaces)

A mipmap is a sequence of textures, each of which is a progressively lower resolution representation of the same image. The height and width of each image, or level, in the mipmap is a power of two smaller than the previous level. A high-resolution mipmap image is used for objects that are close to the user. Lower-resolution images are used as the object appears farther away. Mipmapping improves the quality of rendered textures at the expense of using more memory.

### What is Windows GDI?

> [official docs](https://docs.microsoft.com/en-us/windows/win32/gdi/windows-gdi)
>
> [How does windows gdi work in compare to directX/openGL?](https://stackoverflow.com/questions/42395064/how-does-windows-gdi-work-in-compare-to-directx-opengl)

The Microsoft Windows graphics device interface (GDI) enables applications to use graphics and formatted text on both the video display and the printer. It is primary for drawing 'presentation' graphics and text for GUIs. Direct2D is a vector graphics library that does these old "GDI-style" operations on top of Direct3D with a mix of software and hardware-accelerated paths, and is what is used by the modern Windows GUI in combination with DirectWrite which implements high-quality text rendering.

### What is the resource view?

> [Tutorial 1: Direct3D 11 Basics](https://docs.microsoft.com/en-us/previous-versions//ff729718(v=vs.85)?redirectedfrom=MSDN)

A resource view **allows a resource to be bound to the graphics pipeline at a specific stage**. Think of resource views as **typecast in C**. A chunk of raw memory in C can be cast to any data type. We can cast that chunk of memory to an array of integers, an array of floats, a structure, an array of structures, and so on. The raw memory itself is not very useful to us if we don't know its type. Direct3D 11 resource views act in a similar way. For instance, a 2D texture, analogous to the raw memory chunk, is the raw underlying resource. Once we have that resource we can create **different resource views to bind that texture to different stages** in the graphics pipeline with different formats: as a render target to which to render, as a depth stencil buffer that will receive depth information, or as a texture resource. Where C typecasts allow a memory chunk to be used in a different manner, so do Direct3D 11 resource views.

### What is the viewport?

The viewport maps clip space coordinates, where X and Y range from -1 to 1 and Z ranges from 0 to 1, to render target space, sometimes known as pixel space.

### [What is the purpose of using the QueryInterface method? (Direct3D)](https://stackoverflow.com/questions/31821754/what-is-the-purpose-of-using-the-queryinterface-method-direct3d)

TODO: COM related stuff

### What is DXGI?

> [official docs](https://docs.microsoft.com/en-us/windows/win32/direct3ddxgi/dx-graphics-dxgi)

Microsoft DirectX Graphics Infrastructure (DXGI) handles enumerating graphics adapters, enumerating display modes, selecting buffer formats, sharing resources **between processes (such as, between applications and the Desktop Window Manager (DWM))**, and presenting rendered frames to a window or monitor for display.

> [DXGI overview](https://docs.microsoft.com/en-us/windows/win32/direct3ddxgi/d3d10-graphics-programming-guide-dxgi)

The primary goal of DXGI is to manage **low-level tasks** that can be independent of the DirectX graphics runtime. 

What are low level tasks? 

Low-level tasks like enumeration of hardware devices, presenting rendered frames to an output, controlling gamma, and managing a full-screen transition.

What are adapters?

An adapter is **an abstraction of the hardware and the software capability of your computer**. There are generally many adapters on your machine. Some devices are implemented in hardware (like your video card) and some are implemented in software (like the Direct3D reference rasterizer). 

![dxgi-interface](.\images\dxgi-interface.gif)

### Why triangles?

> [lesson 1: understanding graphics concepts](http://www.directxtutorial.com/Lesson.aspx?lessonid=111-4-1)

If a point in a 3D coordinate system represents a position in space, then we can form an array of exact positions which will eventually become a 3D model. Of course, setting so many points would take up a lot of space in memory, so an easier and faster way has been employed. This method is set up using triangles. **Direct3D is designed solely around triangles and combining triangles to make shapes**. Instead of defining each and every corner of every triangle in the game, all you need to do is create a list of vertices, which contain the coordinates and information of each vertex, as well as **what order they go in**.

