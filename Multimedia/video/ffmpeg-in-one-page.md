# ffmpeg and video processing in one page

## Resources

- tutorials for raw players [ffmpeg from hero to zero](https://ffmpegfromzerotohero.com/)
- from SO [Where can I learn ffmpeg?](https://stackoverflow.com/questions/60230868/where-can-i-learn-ffmpeg)
- official [documents](https://ffmpeg.org/documentation.html)
- unofficial [examples](https://hhsprings.bitbucket.io/docs/programming/examples/ffmpeg/index.html#)
- ffmpeg [wiki](https://trac.ffmpeg.org/wiki)
- sdl2 library: https://www.libsdl.org/
- my former notes (downloaded from lark): [pdf version](./pdfs/ffmpeg.pdf)
- blogs: https://github.com/Eyevinn/streaming-onboarding

## Basics on video processing

### What is loudness normalization?

> https://en.wikipedia.org/wiki/Audio_normalization

### What are Rate Control Modes ?

> https://slhck.info/video/2017/03/01/rate-control.html

### What is the difference between mono and stereo?

> https://music.stackexchange.com/questions/24631/what-is-the-difference-between-mono-and-stereo

### H.264 NALU explaination

> A great [answer](https://stackoverflow.com/a/24890903/11100389)

## Command lines

### How to rotate a video (e.g.  Rotate 90 clockwise)?

> [Rotating videos with FFmpeg](https://stackoverflow.com/questions/3937387/rotating-videos-with-ffmpeg)

```
ffmpeg -i in.mov -vf "transpose=1" out.mov
```

```
0 = 90CounterCLockwise and Vertical Flip (default)
1 = 90Clockwise
2 = 90CounterClockwise
3 = 90Clockwise and Vertical Flip
```

### How to count the number of frames in a video?

> [Fetch frame count with ffmpeg](https://stackoverflow.com/questions/2017843/fetch-frame-count-with-ffmpeg)

Use ffprobe

```bash
$ ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 input.mp4
```

### How to add a watermark to my video?

> [How to add transparent watermark in center of a video with ffmpeg?](https://stackoverflow.com/questions/10918907/how-to-add-transparent-watermark-in-center-of-a-video-with-ffmpeg)

TODO

How to extract h264 stream from a video file?

> [extracting h264 raw video stream from mp4 or flv with ffmpeg generate an invalid stream](https://stackoverflow.com/questions/19300350/extracting-h264-raw-video-stream-from-mp4-or-flv-with-ffmpeg-generate-an-invalid)

```bash
$ ffmpeg -i test.flv -vcodec copy -an -bsf:v h264_mp4toannexb test.h264
```

> The raw stream without [H264 Annex B / NAL](http://en.wikipedia.org/wiki/Network_Abstraction_Layer) cannot be decode by player. With that option ffmpeg perform a simple "mux" of each h264 sample in a NAL unit.

## Programming

### What is the difference between av_init_packet() and av_packet_alloc()?

> [FFmpeg中av_init_packet()和av_packet_alloc()以及av_new_packet()三者的区别以及用法](https://blog.csdn.net/u010380485/article/details/54668696)

## Open source

### Comparison with SDL and SFML

> https://www.reddit.com/r/gamedev/comments/fk8c1q/sfml_vs_sdl_in_2020/
>
> SFML
>
> - More beginner friendly and uses C++ objects which manage their lifetimes (so you don't need to worry about memory management that much)
> - Has everything you need to make a simple 2D game. I mean everything, 2D rendering, audio, it has it all.
> - Very customizable 2D rendering, which is great for games where you don't want just rectangles with textures on them.
> - Works great on Windows PC, not sure about mobile but I am sure it runs fine there.
> - Not as much community as SDL.
>
> SDL
>
> - SDL is not beginner friendly but it's not unfriendly either.
> - It's written in C so it can be easily used in other languages that make bindings for it.
> - It is used widely in the industry, has big organisations behind it like Valve and is going to be more robust than SFML.
> - It's mainly used for its cross platform window management, most companies then roll their own rendering on top of it. They don't usually use the built in 2D renderer, which isn't that customizable compared to SFML. (No shader support)
> - Only has BMP image loading built in, you need to install another SDL library (SDL_image) or use stb_image (which isn't beginner friendly).
> - Built in audio is not user friendly and many people use another SDL library (SDL_mixer) to handle it for them.
>
> I recommend SFML if you don't want to deal with other libraries and just want to get straight into making something.
