# アプリ名
RentaP(レンタパーク)

# 概要
駐車スペースを貸したい時に貸す、借りたい時に借りるアプリ

# 制作背景(意図)
## 飲食店を利用する際に感じた経験
- 混んでいて駐車場がなく諦める
- やっと空いた駐車場でも狭くて駐車しにくい、出にくくてためらう
- 「近くに広い空いたスペースがあるのに」
- 駐車場不足で周囲の住民・店舗に迷惑がかかり（無断駐車）閉店した店

## 経験から考えたこと
- 多少であればお金を払ってでもあのスペースに駐車したい
- 貸す側も気軽にできれば空きスペースで利益を出せる


# テーブル設計

### Usersテーブル

|Column             |Type    |Options                        |
|-------------------|--------|-------------------------------|
|nickname           |string  |null: false                    |
|email              |string  |null: false, unique: true      |
|encrypted_password |string  |null: false                    |
|last_name          |string  |null: false                    |
|first_name         |string  |null: false                    |
|last_name_kana     |string  |null: false                    |
|first_name_kana    |string  |null: false                    |
|postal_code        |string  |null: false                    |
|prefecture_id      |integer |null: false                    |
|city               |string  |null: false                    |
|street             |string  |null: false                    |
|explosive          |string  |                               |
|phone_number       |string  |null: false                    |

### Association
- has_many :events
- has_many :cars
- has_many :parks

## Carsテーブル

|Column             |Type           |Options                        |
|-------------------|---------------|-------------------------------|
|vehicle_type       |string         |null: false                    |
|city               |string         |null: false                    |
|class_number       |integer        |null: false                    |
|registration_type  |string         |null: false                    |
|designated_number  |integer        |null: false                    |
|user               |references     |null: false, foreign_key: true |

### Association
- belongs_to :user
- has_many :parks
- has_many :events

## Parksテーブル

|Column             |Type           |Options                        |
|-------------------|---------------|-------------------------------|
|name               |string         |null: false                    |
|number             |integer        |null: false                    |
|postal_code        |string         |null: false                    |
|prefecture_id      |integer        |null: false                    |
|city               |string         |null: false                    |
|street             |string         |null: false                    |
|explosive          |string         |                               |
|unit_price         |integer        |null: false                    |
|start_time         |datetime       |null: false                    |
|end_time           |datetime       |null: false                    |
|user               |references     |null: false, foreign_key: true |

### Association
- belongs_to :user
- has_many :unusable_times
- has_many :events

## Eventsテーブル

|Column             |Type           |Options                        |
|-------------------|---------------|-------------------------------|
|start_date         |datetime       |null: false                    |
|end_date           |datetime       |null: false                    |
|park               |references     |null: false, foreign_key: true |
|user               |references     |null: false, foreign_key: true |
|car                |references     |null: false, foreign_key: true |

### Association
- belongs_to :park
- belongs_to :user
- belongs_to :car

# 使用技術

## バックエンド
Ruby、Ruby on Rails
## フロントエンド
Haml、bootstap、Javascript
## データベース
MySQL
## 本番環境
AWS
## ソース管理
Git、Github
## テスト
Rspec
## エディダ
VScode

# 課題や今後実装したい機能
- 貸し出したユーザーが駐車場ごとの利益一覧、グラフ化