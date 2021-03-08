### テーブル設計

# Usersテーブル

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
|address            |string  |null: false                    |
|explosive          |string  |                               |
|phone_number       |string  |null: false                    |

## Association
- has_many :rentals
- has_many :cars
- has_many :parks

# Carsテーブル

|Column             |Type           |Options                        |
|-------------------|---------------|-------------------------------|
|type               |string         |null: false                    |
|city               |string         |null: false                    |
|class_number       |integer        |null: false, unique: true      |
|registration_type  |string         |null: false                    |
|designated_number  |integer        |null: false, unique: true      |
|user               |references     |null: false, foreign_key: true |

## Association
- belongs_to :user
- has_many :parks

# Parksテーブル

|Column             |Type           |Options                        |
|-------------------|---------------|-------------------------------|
|name               |string         |null: false                    |
|number             |integer        |null: false                    |
|postal_code        |string         |null: false                    |
|prefecture_id      |integer        |null: false                    |
|city               |string         |null: false                    |
|address            |string         |null: false                    |
|explosive          |string         |                               |
|unit_price         |integer        |null: false                    |
|start_time         |datetime       |null: false                    |
|end_time           |datetime       |null: false                    |
|user               |references     |null: false, foreign_key: true |

## Association
- belongs_to :user
- has_many :unusable_times
- has_many :rentals

# Unusable_timesテーブル

|Column             |Type           |Options                        |
|-------------------|---------------|-------------------------------|
|start_time         |datetime       |null: false                    |
|end_time           |datetime       |null: false                    |
|park               |references     |null: false, foreign_key: true |

## Association
- belongs_to :park

# Rentalsテーブル

|Column             |Type           |Options                        |
|-------------------|---------------|-------------------------------|
|start_time         |datetime       |null: false                    |
|end_time           |datetime       |null: false                    |
|park               |references     |null: false, foreign_key: true |
|user               |references     |null: false, foreign_key: true |
|car                |references     |null: false, foreign_key: true |

## Association
- belongs_to :park
- belongs_to :user
- belongs_to :car