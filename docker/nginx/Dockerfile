FROM nginx:1.19-alpine

COPY ./docker/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY ./docker/nginx/conf.templates/app.conf.template /etc/nginx/templates/

RUN mkdir -p /srv/RobotFW-frontend
COPY ./static /srv/RobotFW-frontend/static
