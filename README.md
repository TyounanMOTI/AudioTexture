# AudioTexture
音声データをTexture2Dにしてシェーダーからアクセスするサンプルプロジェクト

# Examples
## AudioTexture/Examples/VolumeVisualizer.unity
テクスチャ化した音声データの振幅値で箱のスケールを変化させています。

## AudioTexture/Examples/RMSVisualizer.unity
Root Mean Square (RMS) 値をシェーダーで算出し、箱のスケールを変化させています。

# 使い方
1. AudioTexture.unitypackageをUnityで開く
2. UnityメインメニューのAudioTexture/Generateを選択
3. AudioClipを指定してCreate
4. RGFloat型のTexture2Dがプロジェクトペインに作成される

サンプルを参考にしてイイ感じの視覚エフェクトを作りましょう！

# Acknowledgement
下記音声データはユニティちゃんライセンスで提供されています。
- AudioTexture/Examples/Audio/Unite In The Sky (short).mp3

© Unity Technologies Japan/UCL

# License
The MIT License (c) Hirotoshi Yoshitaka
