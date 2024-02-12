## How many days linebot

子供が産まれると、なにかと「何週目」とか「何才何ヶ月」といった情報が必要になることがあります。
そこで、毎日子供の「何ヶ月何日か」「何週何日か」「何日か」の情報を通知するLINE BOTを作りました。

## 実装方法など

- Ruby
  - `app.rb`でrubyのプログラムむとして作成しています。
- LINE Messaging API
  - `line-bot-api` gemを利用しています。
- Github Actions
  - 定期実行はGitHub Actionsで行っています。(`.github/workflows/run_app.yml`)
