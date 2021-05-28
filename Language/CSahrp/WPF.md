# Quick Notes on WPF Learning

> From https://wpf-tutorial.com/

## XAML

- controls: content + attribute. Example:

  ```xaml
  <Button FontWeight="Bold">
      <WrapPanel>
          <TextBlock Foreground="Blue">Multi</TextBlock>
          <TextBlock Foreground="Red">Color</TextBlock>
          <TextBlock>Button</TextBlock>
      </WrapPanel>
  </Button>
  ```

  

- events driven:

  > All of the controls, including the Window (which also inherits the Control class) exposes a range of events that you may subscribe to. 

  link control events in XAML to a piece of code:

  ```xaml
  <Window x:Class="WpfTutorialSamples.XAML.EventsSample"
          xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
          xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
          Title="EventsSample" Height="300" Width="300">
  	<Grid Name="pnlMainGrid" MouseUp="pnlMainGrid_MouseUp" Background="LightBlue">        
  		
      </Grid>
  </Window>
  ```

  ```csharp
  private void pnlMainGrid_MouseUp(object sender, MouseButtonEventArgs e)
  {
  	MessageBox.Show("You clicked me at " + e.GetPosition(this).ToString());
  }
  ```


## A WPF Application

- a window class:

  > - What are in a window: **A WPF window** is a combination of a XAML (.xaml) file, where the <Window> element is the root, and a CodeBehind (.cs) file. 
  >
  > - Patital class and `InitializeComponent()`: The Window1 class is definied as **partial**, because it's being combined with your XAML file in runtime to give you the full window. This is actually what the call to `InitializeComponent()` does.
  > - What is the grid: The Grid is one of the WPF panels, and while it could be any panel or control, the Window can only have ONE child control, so a Panel, which in turn can contain multiple child controls

  window properities: Icon, ResizeMode , ...

- App.xaml: The declarative starting point of your application. Define global resources that may be used and accessed from all over an application.

  > .NET will go to this class for starting instructions and then start the desired Window or Page from there. This is also the place to subscribe to important application events, like application start, unhandled exceptions and so on.

  StartupUri: instructs which Window or Page to start up when the application is launched. We can use 	`event` to manipulate the startup window before showing it.

  ```xaml
  <Application x:Class="WpfTutorialSamples.App"
               xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
               xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  			 Startup="Application_Startup">
      <Application.Resources></Application.Resources>
  </Application>
  ```

  ```csharp
  using System;
  using System.Collections.Generic;
  using System.Windows;
  
  namespace WpfTutorialSamples
  {
  	public partial class App : Application
  	{
  
  		private void Application_Startup(object sender, StartupEventArgs e)
  		{
  			// Create the startup window
  			MainWindow wnd = new MainWindow();
  			// Do stuff here, e.g. to the window
  			wnd.Title = "Something else";
  			// Show the window
  			wnd.Show();
  		}
  	}
  }
  ```

- command line: using evetn

  ```xaml
  <Application x:Class="WpfTutorialSamples.App"
               xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
               xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  			 Startup="Application_Startup">
      <Application.Resources></Application.Resources>
  </Application>
  ```

  ```csharp
  using System;
  using System.Collections.Generic;
  using System.Windows;
  
  namespace WpfTutorialSamples
  {
  	public partial class App : Application
  	{
  
  		private void Application_Startup(object sender, StartupEventArgs e)
  		{
  			MainWindow wnd = new MainWindow();
  			if(e.Args.Length == 1)
  				MessageBox.Show("Now opening file: \n\n" + e.Args[0]);
  			wnd.Show();
  		}
  	}
  }
  ```

- Resources

  > https://wpf-tutorial.com/wpf-application/resources/

  1. what are resources? 
  2. resources scopes: application, window, and local
  3. static and dynamic resources.
  4. how to use resources? Resources are given a key, using the x:Key attribute, which allows you to reference it from other parts of the application by using this key.

- exceptions handling

  1. If you don't handle the exception, your application will crash and Windows will have to deal with the problem.

  2. handle methods:

     - local: try-catch
     - app: use `DispatcherUnhandledException`

     ```xaml
     <Application x:Class="WpfTutorialSamples.App"
                  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                 DispatcherUnhandledException="Application_DispatcherUnhandledException"
                  StartupUri="WPF Application/ExceptionHandlingSample.xaml">
         <Application.Resources>
         </Application.Resources>
     </Application>
     ```

     
