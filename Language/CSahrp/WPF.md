# Quick Notes on WPF Learning

> From https://wpf-tutorial.com/
>
> From mentor:
>
> 1. xaml 结构熟悉， 常用界面控件熟悉，
> 2. 使用 visual blend 设计界面， 自定义控件，模板
>
> 3. 数据绑定   mvvm
> 4. C# 语言
> 5. C/C++ 动态库编写， C#调用C++库
> 6. C# 库编写

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

### Check Box

## Data binding

### What is data binding?

Bind data from source/codes to UI.

> With WPF, Microsoft has put data binding in the front seat and once you start learning WPF, you will realize that it's an important aspect of pretty much everything you do.

### Basics (hello world level)

Format 1:

{Binding} for data text (TODO)

Format 2:

{Binding Path = \<NameOfProperty\>, ElementName=\<txtValue\>}

example:

```xaml
<StackPanel Margin="10">
    <TextBox Name="txtValue" Text=""/>
    <WrapPanel Margin="0, 10">
        <TextBlock Text="Value: " FontWeight="Bold"/>
        <TextBlock Text="{Binding Path=Text, ElementName=txtValue}"/>
    </WrapPanel>
</StackPanel>
```

> - In the simplest case, the [Path](https://docs.microsoft.com/en-us/dotnet/api/system.windows.data.binding.path) property value is the name of the property of the source object to use for the binding, such as `Path=PropertyName`. [reference](https://docs.microsoft.com/en-us/dotnet/desktop/wpf/data/binding-declarations-overview?view=netdesktop-5.0#binding-path-syntax)

### Data context

DataContext property is the default source of binding. It is null from the start and can be inherited to the child controls. The window itself can be the DataContext property.

example:

```csharp
namespace DataBinding
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            this.DataContext = this;
        }
    }
}
```

```xaml
<Window x:Class="DataBinding.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:DataBinding"
        mc:Ignorable="d"
        Title="MainWindow" Height="130" Width="280">
    <StackPanel Margin="15">
        <WrapPanel>
            <TextBlock Text="Window title: "/>
            <TextBox Text="{Binding Title, UpdateSourceTrigger=PropertyChanged}" Width="150"/>
        </WrapPanel>
        <WrapPanel Margin="0,10,0,0">
            <TextBlock Text="Window size: "/>
            <TextBox Text="{Binding Width}" Width="50"/>
            <TextBlock Text="x"/>
            <TextBox Text="{Binding Height}" Width="50"/>
        </WrapPanel>
    </StackPanel>
</Window>
```

### Data binding using codes behind

```xaml
<StackPanel Margin="15">
    <TextBox Name="txtBox"/>
    <WrapPanel>
        <TextBlock Text="Value: "/>
        <TextBlock Name="lValue"/>
    </WrapPanel>
</StackPanel>
```

```csharp
namespace DataBinding
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            Binding _binding = new Binding("Text");
            _binding.Source = txtBox;
            lValue.SetBinding(TextBlock.TextProperty, _binding);
        }
    }
}
```

### UpdateSourceTrigger

Four ways to change resource data (sent data back to resource):

1. default: 

   > all properties except for the Text property, is updated as soon as the property changes (PropertyChanged), while the Text property is updated when focus on the destination element is lost (LostFocus).

2. PropertyChanged: as soon as the property changes;

3.  LostFocus: when focus on the destination element is lost;

4. Explicit: update has to be pushed manually through to occur.

### Response to changes

> ::dart:

以上数据绑定都是将UI控件与已经存在的数据类型进行绑定。如果将自定义的数据与UI绑定，则需要做两点更改。

1. 改变list items：`ObservableCollection`;
2. 改变绑定数据的属性：通过继承**INotifyPropertyChanged**接口的`OnPropertyChange`成员实现；

例子：

```xaml
<DockPanel Margin="10">
    <StackPanel DockPanel.Dock="Right" Margin="10,0,0,0">
        <Button Name="btnAddUser" Click="OnbtnAddUserClick">Add User</Button>
        <Button Name="btnChangeUser" Click="OnbtnChangeUserClick" Margin="0,5">Change User</Button>
        <Button x:Name="btnDeleteUser" Click="OnbtnDeleteUserClick" Content="Delete User"/>
    </StackPanel>
    <ListBox Name="lbUsers" DisplayMemberPath="Name"/>
</DockPanel>
```

```csharp
namespace DataBinding
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private ObservableCollection<User> mUsers = new ObservableCollection<User>();

        public MainWindow()
        {
            InitializeComponent();
            mUsers.Add(new User() { Name="Sun Xuyao"});
            mUsers.Add(new User() { Name = "Cui Shuyan" });
            lbUsers.ItemsSource = mUsers;
        }

        private void OnbtnDeleteUserClick(object sender, RoutedEventArgs e)
        {
            if(lbUsers.SelectedItem != null)
            {
                mUsers.Remove(lbUsers.SelectedItem as User);
            }
        }

        private void OnbtnChangeUserClick(object sender, RoutedEventArgs e)
        {
            if (lbUsers.SelectedItem != null)
            {
                (lbUsers.SelectedItem as User).Name = "Liu Dan";
            }
        }

        private void OnbtnAddUserClick(object sender, RoutedEventArgs e)
        {
            mUsers.Add(new User() { Name = "Liu Dan" });
        }

        public class User:INotifyPropertyChanged
        {
            private string _name;
            
            public string Name
            {
                get { return _name; }
                set
                {
                    if(_name != value)
                    {
                        this._name = value;
                        this.OnPropertyChange("Name");
                    }
                }
            }

            public event PropertyChangedEventHandler PropertyChanged;  // to be realized

            public void OnPropertyChange(string proName)
            {
                PropertyChangedEventHandler propertyChangedEventHandler = PropertyChanged;
                propertyChangedEventHandler?.Invoke(this, new PropertyChangedEventArgs(proName));
            }
        }
    }
}
```

### Value converts

例如将source的yes转为destination的 bool true（在输入框输入yes，chekbox就立即变为选中，反之亦然）

通过实现接口 IValueConverter的Convert和ConvertBack函数。具体而言，类YesNoToBooleanConverter实现该接口，同时指定该类为窗口资源，给数据绑定的控件属性converter赋以该local resource即可。

代码：

```xaml
<Window.Resources>
    <local:YesNoToBooleanConverter x:Key="YesNoToBooleanConverter"/>
</Window.Resources>

<StackPanel Margin="10">
    <TextBox Name="txtValue"/>
    <WrapPanel Margin="0.10">
        <TextBlock Text="Current value is: "/>
        <TextBox Text="{Binding Path=Text, ElementName=txtValue, Converter={StaticResource YesNoToBooleanConverter}}"/>
    </WrapPanel>
    <CheckBox IsChecked="{Binding Path=Text, ElementName=txtValue, Converter={StaticResource YesNoToBooleanConverter}}" Content="Yes"/>
</StackPanel>
```

```cs
namespace DataBinding
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }
    }

    public class YesNoToBooleanConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            switch (value.ToString().ToLower())
            {
                case "yes":
                    return true;
                case "no":
                    return false;
            }

            return false;
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if(value is bool)
            {
                if ((bool)value == true)
                {
                    return "yes";
                }
                else
                    return "no";
            }

            return "no";
        }
    }

}
```

### StringFormat

> https://wpf-tutorial.com/data-binding/the-stringformat-property/
>
> where you just want to change the way a certain value is shown and not necessarily convert it into a different type, the **StringFormat** property might very well be enough.

## Q&A

### What is the difference between Grid and Stackpanel?

> [WPF Grid vs Stackpanel](https://stackoverflow.com/questions/452045/wpf-grid-vs-stackpanel)

They are all containers.

> You should use a Grid if you need things to line up horizontally and vertically. Use a StackPanel to create a row or column of things when those things don't need to line up with anything else. And DockPanel is slightly more complex than a StackPanel, but its markup isn't as cluttered as the Grid.

### What is the difference between TextBlock and TextBox?

> [Is there any difference between WPF TextBlock and TextBox?](https://stackoverflow.com/questions/18204245/is-there-any-difference-between-wpf-textblock-and-textbox)

> TextBlock is more lightweight control for displaying text and TextBox is used when you require user input or edit existing text.
