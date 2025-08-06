# �ϥ� Ruby �@���ظm����
FROM ruby:3.2 AS builder

WORKDIR /app

# �ƻs Gemfile �P Gemfile.lock �H�Q�Χ֨�
COPY Gemfile Gemfile.lock ./

# �w�� Bundler �æw�� Jekyll �̿�
RUN gem install bundler
RUN bundle install

# �ƻs��L�Ҧ��ɮ�
COPY . .

# ���� Jekyll �R�A�ɮר� _site ��Ƨ�
RUN bundle exec jekyll build

# �ϥλ��q�� Nginx �@���R�A�ɮצ��A��
FROM nginx:stable-alpine

# �M�Źw�] nginx �R�A�����]�i��^
RUN rm -rf /usr/share/nginx/html/*

# �q builder �ƻs Jekyll �R�A�ɮר� nginx �w�]���|
COPY --from=builder /app/_site /usr/share/nginx/html

# �}�� 80 ��f
EXPOSE 80

# �Ұ� nginx�A�e������
CMD ["nginx", "-g", "daemon off;"]
