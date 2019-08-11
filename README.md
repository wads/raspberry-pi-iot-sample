# 概要
Raspberry PiをAWS IoTのThingとして登録して、gpsモジュールから位置情報を取得するサンプルコードです。

Thing登録、gpsのデータをPOSTするBackend APIが別途必要です。

# ファイルの説明
## get_cpu_serial.sh
Raspberry Piのシリアルナンバーを取得するスクリプトです。

## gps.js
GPSモジュールから位置情報を取得して、APIにPOSTします。
Backend APIが別途必要です。

## register.sh
シリアルナンバーをthing idとしてAWS IoTに登録し、レスポンスで帰ってきた秘密鍵や証明書を保存します。
AWS IoTへの登録にはBackend APIが別途必要です。

## setup.sh
Raspberry Piに必要なライブラリをインストールします。

## shadow.js
AWS IoTのThing shadowと同期するプログラムです。