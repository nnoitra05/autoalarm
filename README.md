

Original links (be made by our project participants: @jxn1156596, @yunayotuba, and me)
https://github.com/jxn1156596/autoalarm

#テーブル設計

## users テーブル

| Column      | Type       | Options         |
| ----------- | -----------| ----------------|
| name        | string     | null : false    |
| email       | string     | null : false    |
| password    | string     | null : false    |


### Association
- has_many :calendars
- has_many :bookmarks

## Calendar テーブル

| Column       | Type          | Options                            |
| -------------| --------------| -----------------------------------|
| date         | date          | null : false                       |
| user         | references    | null : false, foreign key: true    |

### Association
- belongs_to :users
- has_many : bookmark_calendars
- has_many : bookmarks, through:bookmark_calendars




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
- has_many : bookmark_calendars
- has_many : calendars, through:bookmark_calendars

## BookmarkCalendar テーブル

| Column       | Type          | Options                            |
| -------------| --------------| -----------------------------------|
| bookmark     | references    | null : false, foreign key: true    |
| Calendar     | references    | null : false, foreign key: true    |

### Association
- belongs_to : bookmark
- belongs_to : calendar





