# Hello Opengl

> https://learnopengl.com/

## Getting Started

### Opengl introduction

1. OpenGL by itself is **not an API, but merely a specification**, developed and maintained by the Khronos Group.

2. **Core-profile** vs Immediate mode: core profile is the morden way to use opengl without backward compatibility.

3. Extensions: vendor specific features which can be used by developers.

4. state and context: opengl is a state machine, and the state is referred to as opengl context. Through setting options and manipulating some buffers, developers can change the state and then render using  the corrent context.

   > Whenever we tell OpenGL that we now want to draw lines instead of triangles for example, we change the state of OpenGL by **changing some context variable** that sets how OpenGL should draw. As soon as we change the context by telling OpenGL it should draw lines, the next drawing commands will now draw lines instead of triangles.

5. objects

### Configuring

- [GLFW](https://www.glfw.org/): GLFW gives us the bare necessities required for rendering goodies to the screen. It allows us to create an OpenGL context, define window parameters, and handle user input.

  >  It provides a simple API for creating windows, contexts and surfaces, receiving input and events.

- [GLAD](https://glad.dav1d.de/):  Helps to retrieve the locations of opengl funcions and store them in funcions pointers.

  > Because OpenGL is only really a standard/specification it is up to the driver manufacturer to implement the specification to a driver that the specific graphics card supports. Since there are many different versions of OpenGL drivers, the location of most of its functions is not known at compile-time and needs to be queried at run-time. 

### Create a window step by step

1. Initialization

   ```c++
   glfwInit();
   // opengl version 3.3
   glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
   glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
   // core profile: smaller subset of opengl, no backwards-compatible
   glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
   ```

2. create a window object

   ```c++
   GLFWwindow* window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
   if (window == NULL)
   {
       std::cout << "Failed to create GLFW window" << std::endl;
       glfwTerminate();
       return -1;
   }
   // !!!
   glfwMakeContextCurrent(window);
   ```

3. retrieve the location

   ```cpp
   // GLAD manages function pointers of opengl
   // load the address of os-specfic opengl pointers
   if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
   	std::cout << "gladLoadGLLoader failed." << std::endl;
   	return EXIT_FAILURE;
   }
   ```

4. create opengl viewport using callback

   ```cpp
   void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
   	glViewport(0,0,width,height);
   }
   
   // lower left corner
   // GLFW's window size and opengl viewport
   //glViewport(0, 0, 800, 600);
   glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
   ```

5. render loop

   ```cpp
   void processInput(GLFWwindow* window) {
   	if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
   		glfwSetWindowShouldClose(window, true);
   	}
   }
   
   while (!glfwWindowShouldClose(window)) {
   	// get input
   	processInput(window);
   	// rendering commands
   	glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
   	glClear(GL_COLOR_BUFFER_BIT);
       // double buffer
   	glfwSwapBuffers(window);
   	glfwPollEvents();
   }
   ```

   double buffer:

   > When an application draws in a single buffer the resulting image may display flickering issues. This is because the resulting output image is not drawn in an instant, but drawn pixel by pixel and usually from left to right and top to bottom. Because this image is not displayed at an instant to the user while still being rendered to, the result may contain artifacts. To circumvent these issues, windowing applications apply a double buffer for rendering. The front buffer contains the final output image that is shown at the screen, while all the rendering commands draw to the back buffer. As soon as all the rendering commands are finished we swap the back buffer to the front buffer so the image can be displayed without still being rendered to, removing all the aforementioned artifacts.

   about `glClear`:  `glClear` sets the bitplane area of the window to values previously selected by `glClearColor`, `glClearDepth`, and `glClearStencil`. 

   > [Why do we have to clear depth buffer in OpenGL during rendering?](https://stackoverflow.com/questions/19469194/why-do-we-have-to-clear-depth-buffer-in-opengl-during-rendering)

