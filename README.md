#テーブル設計

## users テーブル

| Column      | Type       | Options         |
| ----------- | -----------| ----------------|
| name        | string     | null : false    |
| email       | string     | null : false    |
| password    | string     | null : false    |


### Association
- has_many :calenders
- has_many :bookmarks

## Calender テーブル

| Column       | Type          | Options                            |
| -------------| --------------| -----------------------------------|
| date         | date          | null : false                       |
| user         | references    | null : false, foreign key: true    |

### Association
- belongs_to :users
- has_many : bookmark_calenders
- has_many : bookmarks, through:bookmark_calenders




## Bookmark テーブル

| Column       | Type          | Options                            |
| -------------| --------------| -----------------------------------|
| name         | string        | null : false                       |
| departure    | string        | null : false                       |
| destination  | string        | null : false                       |
| time         | datetime      | null : false                       |
| user         | references    | null : false, foreign key: true    |
| status_check | boolean       |                                    |

### Association
- belongs_to :users
- has_many : bookmark_calenders
- has_many : calenders, through:bookmark_calenders

## BookmarkCalender テーブル

| Column       | Type          | Options                            |
| -------------| --------------| -----------------------------------|
| bookmark     | references    | null : false, foreign key: true    |
| Calender     | references    | null : false, foreign key: true    |

### Association
- belongs_to : bookmark
- belongs_to : calender





