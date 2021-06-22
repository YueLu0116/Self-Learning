# Digital video introduction

## 颜色的表示

## 分辨率、宽高比（DAR)与像素宽高比(PAR)

## FPS

## 比特率（what is bitrate and how to compute it?)

## Use FFmpeg to check videos' attributes

- https://github.com/leandromoreira/digital_video_introduction/blob/master/encoding_pratical_examples.md#inspect-stream

## 数据压缩

- 视觉冗余-亮度（YCrCb)；
  - [标准建议](https://en.wikipedia.org/wiki/Rec._2020)：
  - 色度子采样，YCrCb: a​ x ​y
- 时间冗余：
  - I帧：关键帧，自足的帧；
  - P帧：前向预测；
  - B帧：后向预测；
  - **帧间预测**，只编码运动向量的差值。
- 空间冗余：
  - **帧内预测**

## Codec

1. 分区；
2. 预测：
   - 帧间预测：运动向量和残差；
   - 帧内预测：预测方向和残差；
3. 变换DCT；
4. 量化
5. 编码
6. 生成比特流：将压缩过的帧和内容打包进去。需要明确告知解码器编码定义

## Free sound resource

https://freesound.org/

