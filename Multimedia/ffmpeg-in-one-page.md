# ffmpeg and multimedia in one page

## Resources

- tutorials for raw players [ffmpeg from hero to zero](https://ffmpegfromzerotohero.com/)
- from SO [Where can I learn ffmpeg?](https://stackoverflow.com/questions/60230868/where-can-i-learn-ffmpeg)
- official [documents](https://ffmpeg.org/documentation.html)
- unofficial [examples](https://hhsprings.bitbucket.io/docs/programming/examples/ffmpeg/index.html#)
- ffmpeg [wiki](https://trac.ffmpeg.org/wiki)
- sdl2 library: https://www.libsdl.org/
- my former notes (downloaded from lark): [pdf version](./pdfs/ffmpeg.pdf)
- blogs: https://github.com/Eyevinn/streaming-onboarding

## Q&A

### What is loudness normalization?

> https://en.wikipedia.org/wiki/Audio_normalization

### What are Rate Control Modes ?

> https://slhck.info/video/2017/03/01/rate-control.html

### What is the difference between mono and stereo?

> https://music.stackexchange.com/questions/24631/what-is-the-difference-between-mono-and-stereo

## Practices

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

### How to add a watermark to my video?

> [How to add transparent watermark in center of a video with ffmpeg?](https://stackoverflow.com/questions/10918907/how-to-add-transparent-watermark-in-center-of-a-video-with-ffmpeg)

TODO

### Create a video from many pictures

TODO
