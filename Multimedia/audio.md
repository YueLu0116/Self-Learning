# 音频专题

## 参考资料

1. 公司知识库：音频基础知识专题；
2. [Windows core
3. [audio api](https://docs.microsoft.com/en-us/windows/win32/coreaudio/core-audio-apis-in-windows-vista)
4. [ffmpeg document](https://ffmpeg.org/doxygen/2.3/index.html)

## 日常总结

### Aug. 13th, 2021

音频基础：

1. 基本概念：TODO

   - 人耳听力范围：人耳正常的听力频率在20至20000赫兹之间

   - [基本概念](https://blog.csdn.net/caoshangpa/article/details/51218597):

     > 音频的帧的概念没有视频帧那么清晰，几乎所有视频编码格式都可以简单的认为一帧就是编码后的一副图像。但音频帧跟编码格式相关，它是各个编码标准自己实现的。
     >
     > 5.1声道已广泛运用于各类传统影院和家庭影院中，一些比较知名的声音录制压缩格式，譬如杜比AC-3（Dolby Digital）、DTS等都是以5.1声音系统为技术蓝本的，其中“.1”声道，则是一个专门设计的超低音声道，这一声道可以产生频响范围20～120Hz的超低音。

   - 采样率与码率的关系：[参考](https://www.zhihu.com/question/27460676)

     采样-量化后得到原始音频数据，压缩后再计算码率；

2. 编解码：

   - [pcm](https://www.jianshu.com/p/fd43c1c82945): 未经压缩，一般双声道，(.wav)；planar or packet; bid endian or little endian? signed or unsigned...

   > FFmpeg音频解码后的数据是存放在AVFrame结构中的。
   >
   > - Packed格式，frame.data[0]或frame.extended_data[0]包含所有的音频数据中。
   > - Planar格式，frame.data[i]或者frame.extended_data[i]表示第i个声道的数据（假设声道0是第一个）, AVFrame.data数组大小固定为8，如果声道数超过8，需要从frame.extended_data获取声道数据。

   - [AAC](https://my.oschina.net/zhangxu0512/blog/341178): 高压缩比，高音质：

     aac+sbr/ps形成不同规格：sbr: 低频高频不同的编码策略；ps：去除双声道数据的相似性；

   > 目前使用最多的（规格）是LC和HE(适合低码率)。流行的Nero AAC编码程序只支持LC，HE，HEv2这三种规格，编码后的AAC音频，规格显示都是LC。HE其实就是AAC（LC）+SBR技术，HEv2就是AAC（LC）+SBR+PS技术。

   ​       ADIF和ADTS文件格式：只有一个全局头文件 vs 同步、纠错、帧头；

   - Opus: 主要应用在低延迟场景下；

   - mp3:

   - FLAC: 无损，大文件

   - 其他可以参考维基百科词条[Audio coding format](https://en.wikipedia.org/wiki/Audio_coding_format)

     > Audio content encoded in a particular audio coding format is normally encapsulated within a [container format](https://en.wikipedia.org/wiki/Container_format_(digital)). As such, the user normally doesn't have a raw [AAC](https://en.wikipedia.org/wiki/Advanced_Audio_Coding) file, but instead has a .m4a [audio file](https://en.wikipedia.org/wiki/Audio_file_format), which is a [MPEG-4 Part 14](https://en.wikipedia.org/wiki/MPEG-4_Part_14) container containing AAC-encoded audio. The container also contains [metadata](https://en.wikipedia.org/wiki/Metadata) such as title and other tags, and perhaps an index for fast seeking.

3. 信号处理算法：

   - 3A: AGC, ANS, AEC
   - DDSP
   - RNNoise
   - [混响](https://www.jianshu.com/p/b39f70294f84)

4. 评价准则：TODO

---

Programming

1. ffmpeg 对音频进行重采样：使用[libswresample](https://ffmpeg.org/doxygen/2.3/group__lswr.html#details).

   - 通过调用swr_alloc_set_opts分配一个SwrContext；

     ```cpp
     SwrContext *swr = swr_alloc_set_opts(NULL,  // we're allocating a new context
                           AV_CH_LAYOUT_STEREO,  // out_ch_layout
                           AV_SAMPLE_FMT_S16,    // out_sample_fmt
                           44100,                // out_sample_rate
                           AV_CH_LAYOUT_5POINT1, // in_ch_layout
                           AV_SAMPLE_FMT_FLTP,   // in_sample_fmt
                           48000,                // in_sample_rate
                           0,                    // log_offset
                           NULL);                // log_ctx
     ```

   - swr_init

   - libavutil [samples manipulation](https://ffmpeg.org/doxygen/2.3/group__lavu__sampmanip.html) API