# Используем официальный образ PHP для Symfony с поддержкой PHP 8.2
FROM php:8.2-fpm

# Установка инструментов, которые могут потребоваться для установки symfony-cmd
RUN apt-get update \
    && apt-get install -y wget unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Установка symfony-cmd
RUN wget https://get.symfony.com/cli/installer -O - | bash \
    && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony-cmd


# Устанавливаем необходимые расширения PHP
RUN docker-php-ext-install pdo_mysql

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Устанавливаем рабочую директорию
WORKDIR /var/www/html

# Копируем файлы проекта в контейнер
COPY . /var/www/html

# Устанавливаем зависимости Composer и генерируем оптимизированный автозагрузчик
RUN composer install --no-dev --optimize-autoloader

# Указываем права на запись для каталогов, где могут появляться файлы, созданные приложением
RUN chown -R www-data:www-data var

# Команда, которая будет выполнена при запуске контейнера
CMD ["php-fpm"]

# Открываем порт 9000 для внешнего доступа
EXPOSE 9000
