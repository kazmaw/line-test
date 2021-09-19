#!/bin/bash

#
# Dockerの各種操作をまとめたスクリプトです。
# Dockerイメージのビルドからmigrateまでスクリプトで行います。
# upは1行の操作なのでここには入れません。
# 前提条件
#   - 環境変更用のスクリプト(change_env.sh)が同じ階層で実行できる状態になっていること
#   - docker-sync導入済みであること
#
usage() {
  cat <<EOM
Usage: $(basename "$0") [OPTION]...
  -h          Display help
  stop        stop docker and docker-sync
  clean       lean docker and doker-sync
  install     bundle install & yarn install
  migrate     change enviroment to develop and migrate development & test
  build       build docker and docker-sync, install and migrate
  init        clean and build
  start       start docker-sync & docker compose up -d
EOM

  exit 2
}

stop() {
  docker compose stop
  docker-sync stop
}

clean() {
  stop
  docker system prune --volumes
  docker-sync clean
}

install() {
  docker compose run app bundle install --path vendor/bundle --clean
  docker compose run app yarn install
}

migrate() {
  docker compose run app bin/rails db:create db:migrate
  docker compose run app bin/rails db:migrate RAILS_ENV=test
}

build() {
  docker compose build --no-cache
  docker-sync start
  install
  migrate
}

init() {
  clean
  build
}

start() {
  docker-sync start
  docker compose up -d
}

case $1 in
  "stop")    stop ;;
  "clean")   clean ;;
  "install") install ;;
  "migrate") migrate ;;
  "build")   build ;;
  "init")    init ;;
  "start")   start ;;
  "-h"|"--help"|*) usage ;;
esac

exit 0
