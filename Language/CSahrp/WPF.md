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


## Basic Controls

### TextBlock Control

It allows you to **put text on the screen**, much like a Label control does, but in a simpler and less resource demanding way. A common understanding is that a Label is for short, one-line texts (but may include e.g. an image), while the TextBlock works very well for multiline strings as well, but can only contain text (strings).

```xaml
    <StackPanel>
        <TextBlock Margin="10" Foreground="Red">
			This is a TextBlock control<LineBreak />
			with multiple lines of text.
        </TextBlock>
        <TextBlock Margin="10" TextTrimming="CharacterEllipsis" Foreground="Green">
			This is a TextBlock control with text that may not be rendered completely, which will be indicated with an ellipsis.
        </TextBlock>
        <TextBlock Margin="10" TextWrapping="Wrap" Foreground="Blue">
			This is a TextBlock control with automatically wrapped text, using the TextWrapping property.
        </TextBlock>
    </StackPanel>
```

### Label Control

1. A Label can host any kind of control directly inside of it.

2. The TextBlock only allows you to render a text string, while the Label also allows you to:

   - Specify a border
   - Render other controls, e.g. an image
   - Use templated content through the ContentTemplate property
   - **Use access keys to give focus to related controls**

   The last bullet point is actually one of the main reasons for using a Label over the TextBlock control. Whenever you just want to render simple text, you should use the TextBlock control, since it's lighter and performs better than the Label in most cases.

   ```xaml
   <Window x:Class="WpfTutorialSamples.Basic_controls.LabelControlAdvancedSample"
           xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
           xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
           Title="LabelControlAdvancedSample" Height="180" Width="250">
   	<StackPanel Margin="10">
   		<Label Target="{Binding ElementName=txtName}">
   			<StackPanel Orientation="Horizontal">
   				<Image Source="http://cdn1.iconfinder.com/data/icons/fatcow/16/bullet_green.png" />
   				<AccessText Text="_Name:" />
   			</StackPanel>
   		</Label>
   		<TextBox Name="txtName" />
   		<Label Target="{Binding ElementName=txtMail}">
   			<StackPanel Orientation="Horizontal">
   				<Image Source="http://cdn1.iconfinder.com/data/icons/fatcow/16/bullet_blue.png" />
   				<AccessText Text="_Mail:" />
   			</StackPanel>
   		</Label>
   		<TextBox Name="txtMail" />
   	</StackPanel>
   </Window>
   ```

### TextBox Control

1. The TextBox control allows the end-user to write plain text, either on a single line, for dialog input, or in multiple lines, like an editor.

2. Prefill the textbox:

   ```xaml
   <TextBox Text="Hello, world!" />
   ```

3. Multi-line TextBox

   ```xaml
   <Window x:Class="WpfTutorialSamples.Basic_controls.TextBoxSample"
           xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
           xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
           Title="TextBoxSample" Height="160" Width="280">
       <Grid Margin="10">
   		<TextBox AcceptsReturn="True" TextWrapping="Wrap" />
   	</Grid>
   </Window>
   ```

   The AcceptsReturn makes the TextBox into a multi-line control by allowing the use of the Enter/Return key to go to the next line, and the TextWrapping property, which will make the text wrap automatically when the end of a line is reached.

4. SelectionChanged event

   ```xaml
   <Window x:Class="WpfTutorialSamples.Basic_controls.TextBoxSelectionSample"
           xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
           xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
           Title="TextBoxSelectionSample" Height="150" Width="300">
   	<DockPanel Margin="10">
   		<TextBox SelectionChanged="TextBox_SelectionChanged" DockPanel.Dock="Top" />
   		<TextBox Name="txtStatus" AcceptsReturn="True" TextWrapping="Wrap" IsReadOnly="True" />
   
   	</DockPanel>
   </Window>
   
   
   ```

   ```csharp
   private void TextBox_SelectionChanged(object sender, RoutedEventArgs e)
   {
       TextBox textBox = sender as TextBox;
       txtStatus.Text = "Selection starts at character #" + textBox.SelectionStart + Environment.NewLine;
       txtStatus.Text += "Selection is " + textBox.SelectionLength + " character(s) long" + Environment.NewLine;
       txtStatus.Text += "Selected text: '" + textBox.SelectedText + "'";
   }
   ```


### Button Control

1. Add a button and write its "on-click" functions.
2. format and include advanced contents in one button.
3. Padding using `Windows.Resource` property.

