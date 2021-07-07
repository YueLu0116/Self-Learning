# Window下编译obs

0. vs 2019, git, and cmake-gui

1. 下载qt5[开源版本](https://www.qt.io/download-open-source)，所需下载选项[参考](https://obsproject.com/forum/threads/qt-msvc-package-for-visual-studio-2019.135923/)：

   ![](C:\Users\Admin\Desktop\notes\self-learning\Multimedia\images\qtpackages.png)

2. 下载[依赖项](https://obsproject.com/downloads/dependencies2019.zip)

3. clone源码

   `git clone --recursive https://github.com/obsproject/obs-studio.git`

4. CMake环境变量配置

   ```
   DepsPath64 = C:\obs-deps\win64\include
   DepsPath32 = C:\obs-deps\win32\include
   QTDIR32 = D:\Qt\5.15.2\msvc2019
   QTDIR64 = D:\Qt\5.15.2\msvc2019_64
   ```

5. Configure后去掉**`BUILD_BROWSER`** ，再次Configure-Generate-Open Project

6. 打开.sln，build.