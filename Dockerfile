# 使用 Ruby 作為建置環境
FROM ruby:3.2 AS builder

WORKDIR /app

# 複製 Gemfile 與 Gemfile.lock 以利用快取
COPY Gemfile Gemfile.lock ./

# 安裝 Bundler 並安裝 Jekyll 依賴
RUN gem install bundler
RUN bundle install

# 複製其他所有檔案
COPY . .

# 產生 Jekyll 靜態檔案到 _site 資料夾
RUN bundle exec jekyll build

# 使用輕量級 Nginx 作為靜態檔案伺服器
FROM nginx:stable-alpine

# 清空預設 nginx 靜態頁面（可選）
RUN rm -rf /usr/share/nginx/html/*

# 從 builder 複製 Jekyll 靜態檔案到 nginx 預設路徑
COPY --from=builder /app/_site /usr/share/nginx/html

# 開放 80 埠口
EXPOSE 80

# 啟動 nginx，前景執行
CMD ["nginx", "-g", "daemon off;"]
