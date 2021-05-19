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

### Draw a triangle

#### Convet 3D coordinates to 2D points

- process (managed by the graphics **pipeline** of opengl):

  1. 3d coordinates to 2d coordinates;
  2. 2d coordinates to actual colored pixels; 

- what is **shader**?

  > All of these steps are highly specialized (they have one specific function) and can easily be executed in parallel. Because of their parallel nature, graphics cards of today have thousands of small processing cores to quickly process your data within the graphics pipeline. The processing cores run small programs on the GPU for each step of the pipeline. These small programs are called shaders.

  modern opengl requires user-defined **vertex** and **fragment** shader.

  > - The main purpose of the vertex shader is to transform 3D coordinates into different 3D coordinates and the vertex shader allows us to do some basic processing on the vertex attributes.
  > - The main purpose of the fragment shader is to calculate the final color of a pixel and this is usually the stage where all the advanced OpenGL effects occur. Usually the fragment shader contains data about the 3D scene that it can use to calculate the final pixel color (like lights, shadows, color of the light and so on).

- inputs: vertex datas represented by **vertex attributes**.

#### Vertex Shader

1. **Construct normalized device coordinates**: OpenGL only processes 3D coordinates when they're in a specific range between `-1.0` and `1.0` on all 3 axes (`x`, `y` and `z`). Example:

   ```cpp
   float vertices[] = {
       -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f,
        0.0f,  0.5f, 0.0f
   };  
   ```

2. **Create memory on GPU** : generate a **vertex buffer objects (VBO)** with **a unique ID** using `glGenBuffers`

   ```cpp
   unsigned int VBO;
   glGenBuffers(1, &VBO);  
   ```

3. **Bind the buffer to a buffer type**: and we know that the variable `VBO` is a vertex buffer objects because it was binded to GL_ARRAY_BUFFER.

   ```cpp
   glBindBuffer(GL_ARRAY_BUFFER, VBO);  
   ```

4. **Copy data to the buffer**: use `glBufferData` (a function specifically targeted to copy user-defined data into the currently bound buffer.)

5. **Write the vertex shader** using the opengl shading language (**GLSL**):

   ```cpp
   const char *vertexShaderSource = "#version 330 core\n"
       "layout (location = 0) in vec3 aPos;\n"
       "void main()\n"
       "{\n"
       "   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
       "}\0";
   ```

6. Create a shader object and **attach the source code to it**:

   ```cpp
   unsigned int vertexShader;
   vertexShader = glCreateShader(GL_VERTEX_SHADER);
   glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
   glCompileShader(vertexShader);
   
   // check if success
   int  success;
   char infoLog[512];
   glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
   if(!success)
   {
       glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
       std::cout << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << std::endl;
   }
   ```

   

