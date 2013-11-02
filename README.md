Table of Contents
=================
* [Deploy](#deploy)
* [Tasks](#tasks)
* [Server API](#server-api)
  * [`GET /user`](#get-user)
  * [`GET /events/{event_id}`](#get-eventsevent_id)
  * [`(PATCH|PUT) /events/{event_id}`](#patchput-eventsevent_id)
  * [`GET /news_items`](#get-news_items)
  * [`GET /news_items/{id}`](#get-news_itemsid)
* [Google Calendar API](#google-calendar-api)
* [範例程式碼](#範例程式碼)
  * [取得使用者日曆](#取得使用者日曆)
  * [取得使用者日曆（使用 Google Client Library）](#取得使用者日曆使用-google-client-library)

Deploy
======

`cap production deploy`

Tasks
=====

Task          | Description
------------- | -----------
`news:fetch`  | 透過 YQL 撈新聞 RSS feed
`news:export` | 先從 news_seed.json 匯入新聞到 db，再 `news:fetch`，再將 db 匯出回 news_seed.json

Server API
==========

`GET /user`
-----------

取得使用者資料。

### Parameters

 Name         | Type    | State    | Description
 ------------ | ------- | -------- | -----------
refresh_token | boolean | optional | 如果使用者的 access token 過期了，可以透過此參數同時更新使用者的 token，預設是 `false`。**注意：這是透過 server 發送 request 給 Google 達到，不應該太頻繁的使用，建議使用 Google API 之前先檢查 `expires_at`**

### Response

<table>
  <thead>
    <tr>
      <th>Context</th>
      <th>Status</th>
      <th>Body</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Success</td><td>200 OK</td><td><pre><code>{
   "uid":"106993981418226624133",
   "name":"簡煒航",
   "email":"tonytonyjan@gmail.com",
   "image":"https://lh6.googleusercontent.com/-juhg9DCk0C4/AAAAAAAAAAI/AAAAAAAACes/huF_LET92Z0/photo.jpg",
   "token":"ya29.AHES6ZQP7yP_-ju6SzgNmAz5XOraIh7hCMJFa-OEJr9CWl-6",
   "refresh_token":"1/H1VMRZxlpaKIMJiNu8P2hd0iFmG_fkJcBegLyvnaFVE",
   "expires_at":1381689196,
   "expires":true,
   "created_at":"2013-10-13T05:12:08.206Z",
   "updated_at":"2013-10-13T17:49:45.854Z"
}</code></pre></td>
    </tr>
    <tr><td>User not Authorized</td><td>401 Unauthorized</td><td></td></tr>
  </tbody>
</table>

`GET /events/{event_id}`
------------------------

取得 Event 狀態。

### Response

<table>
  <thead>
    <tr>
      <th>Context</th>
      <th>Status</th>
      <th>Body</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Success</td><td>200 OK</td><td><pre><code>{
  "user_id": 1,
  "event_id": "e6g8g00h875i146apha12cebl6",
  "state": "unset"
}</code></pre></td>
    </tr>
    <tr><td>User not Authorized</td><td>401 Unauthorized</td><td></td></tr>
  </tbody>
</table>
  

`(PATCH|PUT) /events/{event_id}`
---------------------------------

更新 Event。

### Parameters

Name         | Type   | State    | Description
------------ | ------ | -------- | -----------
event[state] | string | required | 白清單：`unset`、`lock`、`unlock`

### Response

Context             | Status                   | Body
------------------- | ------------------------ | -----------
Success             | 204 No Content           |
Invalid Parameters  | 422 Unprocessable Entity | ex. `{"state":["is not included in the list"]}`
User not Authorized | 401 Unauthorized         |

GET /news_items
---------------

取得新聞清單，每 25 個一頁，可指定時間範圍

### Parameters

Name     | Type     | State    | Description
-------- | -------- | -------- | -----------
begin_at | datetime | optional | RFC 3339 timestamp，要和 `end_at` 並存
end_at   | datetime | optional | RFC 3339 timestamp，要和 `begin_at` 並存
page     | integer  | optional | 頁數

### Response

Context             | Status                   | Body
------------------- | ------------------------ | -----------
Success             | 200 OK                   | Array of [News Object](#news-object)
Invalid Parameters  | 422 Unprocessable Entity |
User not Authorized | 401 Unauthorized         |

GET /news_items/{id}
--------------------

取得一個新聞

### Parameters

### Response

Context             | Status           | Body
------------------- | ---------------- | ----
Success             | 200 OK           | [News Object](#news-object)
Not found           | 404 Not Found    |
User not Authorized | 401 Unauthorized |

### News Object

Name        | Type     | Appearance Condition   | Description
----------- | -------- | ---------------------- | -----------
id          | integer  | `GET /news_items`      |
guid        | string   |                        | RSS unique identifier for the item
title       | string   |                        | 新聞標題
description | string   |                        | 新聞摘要，內含 HTML
link        | string   |                        | 新聞連結
publish_at  | datetime |                        | 新聞發布時間（RFC 3339 timestamp）
raw_data    | object   |                        | YQL 原始資料
url         | string   | `GET /news_items`      | API 網址，例：`http://hostname/news_items/{id}`

#### Example

```json
{
   "id":115,
   "guid":"%E7%B1%B3%E6%A0%BC%E9%AD%AF%E7%8B%82%E7%8A%AC%E7%97%85%E5%AF%A6%E9%A9%97-%E6%98%8E%E5%B9%B4%E5%86%8D%E6%B1%BA%E5%AE%9A-105815676",
   "title":"米格魯狂犬病實驗 明年再議",
   "description":"\u003Cp\u003E\u003Ca href=\"http://tw.news.yahoo.com/%E7%B1%B3%E6%A0%BC%E9%AD%AF%E7%8B%82%E7%8A%AC%E7%97%85%E5%AF%A6%E9%A9%97-%E6%98%8E%E5%B9%B4%E5%86%8D%E6%B1%BA%E5%AE%9A-105815676.html\"\u003E\u003Cimg src=\"http://l.yimg.com/bt/api/res/1.2/ulUWIJm14BsW7Bv8sut.uQ--/YXBwaWQ9eW5ld3M7Zmk9ZmlsbDtoPTg2O3E9NzU7dz0xMzA-/http://media.zenfs.com/zh_hant_tw/News/libertytimes/life4_20130716.600_4.jpg\" width=\"130\" height=\"86\" alt=\"米格魯新任務 聞病根當樹醫\" align=\"left\" title=\"米格魯新任務 聞病根當樹醫\" border=\"0\" /\u003E\u003C/a\u003E農委會想進行病毒實驗，引起好萊塢明星關心，亞歷鮑德溫致函陳保基 ...\u003C/p\u003E\u003Cbr clear=\"all\"/\u003E",
   "link":"http://tw.news.yahoo.com/%E7%B1%B3%E6%A0%BC%E9%AD%AF%E7%8B%82%E7%8A%AC%E7%97%85%E5%AF%A6%E9%A9%97-%E6%98%8E%E5%B9%B4%E5%86%8D%E6%B1%BA%E5%AE%9A-105815676.html",
   "publish_at":"2013-10-27T10:58:15.000Z",
   "raw_data":{
      "title":"米格魯狂犬病實驗 明年再議",
      "description":"\u003Cp\u003E\u003Ca href=\"http://tw.news.yahoo.com/%E7%B1%B3%E6%A0%BC%E9%AD%AF%E7%8B%82%E7%8A%AC%E7%97%85%E5%AF%A6%E9%A9%97-%E6%98%8E%E5%B9%B4%E5%86%8D%E6%B1%BA%E5%AE%9A-105815676.html\"\u003E\u003Cimg src=\"http://l.yimg.com/bt/api/res/1.2/ulUWIJm14BsW7Bv8sut.uQ--/YXBwaWQ9eW5ld3M7Zmk9ZmlsbDtoPTg2O3E9NzU7dz0xMzA-/http://media.zenfs.com/zh_hant_tw/News/libertytimes/life4_20130716.600_4.jpg\" width=\"130\" height=\"86\" alt=\"米格魯新任務 聞病根當樹醫\" align=\"left\" title=\"米格魯新任務 聞病根當樹醫\" border=\"0\" /\u003E\u003C/a\u003E農委會想進行病毒實驗，引起好萊塢明星關心，亞歷鮑德溫致函陳保基 ...\u003C/p\u003E\u003Cbr clear=\"all\"/\u003E",
      "link":"http://tw.news.yahoo.com/%E7%B1%B3%E6%A0%BC%E9%AD%AF%E7%8B%82%E7%8A%AC%E7%97%85%E5%AF%A6%E9%A9%97-%E6%98%8E%E5%B9%B4%E5%86%8D%E6%B1%BA%E5%AE%9A-105815676.html",
      "pubDate":"Sun, 27 Oct 2013 18:58:15 +0800",
      "source":{
         "url":"http://www.cna.com.tw/",
         "content":"中央社"
      },
      "guid":{
         "isPermaLink":"false",
         "content":"%E7%B1%B3%E6%A0%BC%E9%AD%AF%E7%8B%82%E7%8A%AC%E7%97%85%E5%AF%A6%E9%A9%97-%E6%98%8E%E5%B9%B4%E5%86%8D%E6%B1%BA%E5%AE%9A-105815676"
      },
      "content":{
         "height":"86",
         "type":"image/jpeg",
         "url":"http://l.yimg.com/bt/api/res/1.2/ulUWIJm14BsW7Bv8sut.uQ--/YXBwaWQ9eW5ld3M7Zmk9ZmlsbDtoPTg2O3E9NzU7dz0xMzA-/http://media.zenfs.com/zh_hant_tw/News/libertytimes/life4_20130716.600_4.jpg",
         "width":"130"
      },
      "text":{
         "type":"html",
         "content":"\u003Cp\u003E\u003Ca href=\"http://tw.news.yahoo.com/%E7%B1%B3%E6%A0%BC%E9%AD%AF%E7%8B%82%E7%8A%AC%E7%97%85%E5%AF%A6%E9%A9%97-%E6%98%8E%E5%B9%B4%E5%86%8D%E6%B1%BA%E5%AE%9A-105815676.html\"\u003E\u003Cimg src=\"http://l.yimg.com/bt/api/res/1.2/ulUWIJm14BsW7Bv8sut.uQ--/YXBwaWQ9eW5ld3M7Zmk9ZmlsbDtoPTg2O3E9NzU7dz0xMzA-/http://media.zenfs.com/zh_hant_tw/News/libertytimes/life4_20130716.600_4.jpg\" width=\"130\" height=\"86\" alt=\"米格魯新任務 聞病根當樹醫\" align=\"left\" title=\"米格魯新任務 聞病根當樹醫\" border=\"0\" /\u003E\u003C/a\u003E農委會想進行病毒實驗，引起好萊塢明星關心，亞歷鮑德溫致函陳保基 ...\u003C/p\u003E\u003Cbr clear=\"all\"/\u003E"
      },
      "credit":{
         "role":"publishing company"
      }
   },
   "url":"http://localhost:3000/news_items/115"
}
```

Google Calendar API
===================
  
[calendar.events.list](https://developers.google.com/google-apps/calendar/v3/reference/events/list)
----------------------

  * `singleEvents`: 將規律的 event 展開
  * `timeMax`、`timeMin`：設定範圍，RFC 3339 timestamp

Event Object
------------

``` json
{
   "kind":"calendar#event",
   "etag":"\"2Xe5ZDn_ZMD5bsyedBn8h1XCRfw/MTM4MTE0ODA3MzgyNTAwMA\"",
   "id":"910tb0i7v02db78r5hnes2sqqg",
   "status":"confirmed",
   "htmlLink":"https://www.google.com/calendar/event?eid=OTEwdGIwaTd2MDJkYjc4cjVobmVzMnNxcWcgdG9ueXRvbnlqYW5AbQ",
   "created":"2013-10-07T12:14:33.000Z",
   "updated":"2013-10-07T12:14:33.825Z",
   "summary":"與房客下午茶",
   "location":"南京東路 玫瑰夫人",
   "creator":{
      "email":"tonytonyjan@gmail.com",
      "displayName":"簡煒航",
      "self":true
   },
   "organizer":{
      "email":"tonytonyjan@gmail.com",
      "displayName":"簡煒航",
      "self":true
   },
   "start":{
      "dateTime":"2013-10-13T02:00:00+08:00"
   },
   "end":{
      "dateTime":"2013-10-13T03:00:00+08:00"
   },
   "iCalUID":"910tb0i7v02db78r5hnes2sqqg@google.com",
   "sequence":0,
   "reminders":{
      "useDefault":true
   }
}
```

範例程式碼
==========

取得使用者日曆
--------------

``` javascript
$.ajax({
  url: '/user',
  data: {
    refresh_token: true
  }
}).done(function(data){
  current_user = data
  console.log(current_user)
  
  var day_start = new Date();
  day_start.setHours(0,0,0,0);

  var day_end = new Date();
  day_end.setHours(23,59,59,999);

  $.ajax({
    url: 'https://www.googleapis.com/calendar/v3/calendars/' + data.email + '/events',
    headers: {
      Authorization: 'Bearer ' + data.token
    },
    data: {
      timeMax: day_start.toISOString(),
      timeMin: day_end.toISOString(),
      singleEvents: true
    }
  }).done(function(data){
    console.log(data)
  })
})
```

取得使用者日曆（使用 Google Client Library）
----------------------------------------

請參考 [`app/assets/javascripts/home.js.erb`](https://github.com/tonytonyjan/message_time_locker/tree/47ab956666d01e3a4796ea20abe983456552cf57/app/assets/javascripts/home.js.erb)

``` javascript
var clientId = '<%= Settings.google.key %>';
var apiKey = '<%= Settings.google.server_key %>';
var scopes = 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/calendar.readonly';

function handleClientLoad() {
  gapi.client.setApiKey(apiKey);
  window.setTimeout(checkAuth,1);
}

function checkAuth() {
  gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: true}, handleAuthResult);
}

function handleAuthResult(authResult) {
  var authorizeButton = document.getElementById('authorize-button');
  if (authResult && !authResult.error) {
    authorizeButton.style.visibility = 'hidden';
    makeApiCall();
  } else {
    authorizeButton.style.visibility = '';
    authorizeButton.onclick = handleAuthClick;
  }
}

function handleAuthClick(event) {
  gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: false}, handleAuthResult);
  return false;
}

function makeApiCall() {
  // 取得使用者資料
  gapi.client.load('oauth2', 'v2', function() {
    var request = gapi.client.oauth2.userinfo.v2.me.get();
    request.execute(function(resp) {
      currentUser = resp
      console.log(currentUser);

      // 取得使用者日曆
      gapi.client.load('calendar', 'v3', function() {
        var day_start = new Date();
        day_start.setHours(0,0,0,0);
         
        var day_end = new Date();
        day_end.setHours(23,59,59,999);

        var request = gapi.client.calendar.events.list({
          calendarId: currentUser.email,
          timeMax: day_end.toISOString(),
          timeMin: day_start.toISOString(),
          singleEvents: true
        });
        request.execute(function(resp){
          console.log(resp);
        })
      });
    });
  });
}
```