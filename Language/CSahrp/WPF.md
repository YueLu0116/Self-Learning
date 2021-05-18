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

  