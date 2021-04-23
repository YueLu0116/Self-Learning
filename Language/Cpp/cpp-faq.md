# cpp FAQ

> personal questions generated in everyday programming. Answers mainly extracted from stackoverflow

## Parallel Programming

1. Why can't I use reference in a thread process function?

   > [Passing object by reference to std::thread in C++11](https://stackoverflow.com/questions/34078208/passing-object-by-reference-to-stdthread-in-c11/34078246)

   线程启动时，如果引用指向的变量已经被销毁，则与线程执行相关的函数将会崩溃。举例如下：

   ```c++
   // thread function
   void SimpleThread(int& i) {
       std::this_thread::sleep_for(std::chrono::seconds{1});
       i = 0;
   }
   
   // main function
   // causing thread funcion failed
   int main()
   {
       {
           int a;
           std::thread th(SimpleThread, a);
           th.detach();
       }
       // "a" is out of scope
       // at this point the thread may be still running
       // ...
   }
   ```

   如果偏要使用引用作为参数，则可以使用`std::ref`:

   ```c++
   auto thread1 = std::thread(SimpleThread, std::ref(a));
   ```

   ## Types and Conversions

   1. How to convert string to wstring?

      > [C++ Convert string (or char*) to wstring (or wchar_t*)](https://stackoverflow.com/questions/2573834/c-convert-string-or-char-to-wstring-or-wchar-t)
      >
      > [How do I convert a string to a wstring using the value of the string?](https://stackoverflow.com/questions/18244133/how-do-i-convert-a-string-to-a-wstring-using-the-value-of-the-string)

      just for reference. c++ 20 may update this function.

      Windows API solution (use `MultiByteToWideChar`):

      ```c++
      std::wstring s2ws(const std::string& s)
      {
          int len;
          int slength = (int)s.length() + 1;
          len = MultiByteToWideChar(CP_ACP, 0, s.c_str(), slength, 0, 0); 
          wchar_t* buf = new wchar_t[len];
          MultiByteToWideChar(CP_ACP, 0, s.c_str(), slength, buf, len);
          std::wstring r(buf);
          delete[] buf;
          return r;
      }
      ```

      

   2. `string` v.s. `wstring`

      > [std::wstring VS std::string](https://stackoverflow.com/questions/402283/stdwstring-vs-stdstring)
      >
      > [utf-8 everywhere](http://utf8everywhere.org/)
      >
      > [Should UTF-16 be considered harmful?](https://softwareengineering.stackexchange.com/questions/102205/should-utf-16-be-considered-harmful)

      `std::string` 以`char`为模板，而`std::wstring`以`wchar_t`为模板。

      `char`8位1字节，而`wchar_t`由操作系统决定。在linux上，`wchar_t`是4字节，而在windows上`char`是2字节，在windows上（UFT-16)，使用`char`型变量的被称为multibyte，而使用`wchar_t`的被称为widechar，相关api有`MultibyteToWideChar`以及`WideCharToMultiByte`。

      

   