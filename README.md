# WireMock with gRPC Docker Image
***

Пример того как написать `Dockerfile` и создать свой docker image [WireMock](https://wiremock.org/) с 
встроеным расширениями gRPC.

> Кроме того на основе данного примера можно создать образ и с другими [расширениями WireMock](https://wiremock.org/docs/extending-wiremock/)

В проекте используется:
- официальный docker образ WireMock - [wiremock/wiremock:3.5.2](https://hub.docker.com/r/wiremock/wiremock/)
- расширение для WireMock gRPC services - [wiremock-grpc-extension](https://github.com/wiremock/wiremock-grpc-extension) 
версии 0.5.0

Можно использовать готовый [Docker image](https://hub.docker.com/r/kashpovski/wiremock)
    
    docker pull kashpovski/wiremock:3.5.2

## Сборка docker image
***
Перед сборкой необходимо по пути `./extensions` скачать расширение wiremock-grpc-extension:

    cd extensions && wget https://repo1.maven.org/maven2/org/wiremock/wiremock-grpc-extension-standalone/0.5.0/wiremock-grpc-extension-standalone-0.5.0.jar

> Инструкция официального источника https://wiremock.org/docs/grpc/ 

для создания образа из `./Dockerfile` необходимо выполнить команду:

    docker build -t custom/wiremock_grpc:3.5.2 .

или запустить sh скрипт `run_create_image.sh`

> При необходимости в `./Dockerfile` можно сменить версию

## Запуск docker image
***

в `volumes` необходимо указать путь до proto файла gRPC, при старте docker image сам выполняет компиляцию 
файлы `.proto` в дескрипторы. `volumes` можно не указывать, в таком случае сервис 
запуститься в штатном режиме, но мокировать gRPC не удастся.


- Docker:

      docker run -it --rm \
        -p 8080:8080 \
        --name wiremock \
        -v [путь к расположению proto файла]/mock.proto:/home/wiremock/protos/mock.proto \
        custom/wiremock_grpc:3.5.2
  
  или запустить sh скрипт `run_start_image.sh`

  
- Docker compose:

  В репозитории располжен `./docker-compose.wiremock.yaml`:
  
      version: '3.7'
  
      services:
        wiremock:
          image: custom/wiremock_grpc:3.5.2
          container_name: wiremock
          environment:
            - TZ=Europe/Amsterdam
          volumes:
            - [путь к расположению proto файла]/mock.proto:/home/wiremock/protos/mock.proto
          ports:
            - 8080:8080

> в качестве image можно указать образ из своего репозитория Docker Hub

> Инструкция официального источника https://wiremock.org/docs/standalone/docker/

## Размещение docker image на Docker Hub
***
### Регистрация на Docker Hub

- Для начала заходим на сам сайт Docker Hub (https://hub.docker.com/).
- Нажимаем кнопку Register.
- Там нужно ввести 3 значения — Docker ID, Email и Password. (Docker ID — можно назвать логином. Он будет составлять 
часть названия образа (см.ниже))
- Нажимаете галочки, затем Sign Up.
- На почту придет уведомление. Нужно подтвердить ваш адрес.
- Заходите на Docker Hub под созданным пользователем.

### Создание своего репозитория

После того, как вы зарегистрировались, необходимо создать репозиторий (прямо как на GitHub).

На странице вы увидите плашку Create a Repository. Нажмите на неё.  

После нажатия вы попадете на страницу создания репозитория. Создайте там свой репозиторий.

Отлично! Теперь у вас есть свой репозиторий, где можно хранить свои образы. 

### Команды для работы с репозиторием

После того, как у вас появился репозиторий, попробуйте загрузить в него свой образ. 

Чтобы это сделать, необходимо локально авторизоваться, при необходимости сменить имя и тег образа и сделать пуш 
на Docker Hub.  

- Для локальной авторизации используется команда docker login:

      docker login -u USERNAME
  
  В таком случае у вас попросит username (как раз Docker ID) и пароль. 
  
  > При неуспешной авторизации (ошибка: Error saving credentials: error storing credentials - err: exit status 1, out: 
  > `error getting credentials - err: exit status 1, out:` no usernames for https://index.docker.io/v1/``) необходимо 
  > в файле `.docker/config.json` удалить `"credsStore"`:
  >
  >     nano ~/.docker/config.json
  > 
  > Before:
  >
  > ```
  > {
  >     "auths": {},
  >     "credsStore": "desktop", // remove this line, irrespective of the value of credStore
  >     "currentContext": "desktop-linux"
  > }
  > ```
  > 
  > After:
  > 
  > ```
  > {
  >     "auths": {},
  >     "currentContext": "desktop-linux"
  > }
  > ```

- Чтобы сменить название образа и тег, нужно воспользоваться командой:

        docker tag <исходный_образ> <результирующий_образ>

  > В названии `<результирующий_образ>` необходимо указать `<username>/<название репозитория>:<версия>`

- Чтобы отправить образ на Docker Hub, нужно ввести команду:

        docker push <результирующий_образ>

  > Чтобы локально разлогиниться, нужно ввести команду: 
  > 
  > 
  >     docker logout

- После того, как вы загрузили образ на Docker Hub, вы можете его скачать. 
Как вы уже знаете, делается это командой:

      docker pull <результирующий_образ>

## Дополнительно
***

- swagger для работы с WireMock - https://wiremock.org/docs/standalone/admin-api-reference/
- Python библиотека для работы с WireMock - https://wiremock.readthedocs.io/en/latest/
