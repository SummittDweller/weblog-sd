### Dockerfile

# Part 0
FROM alpine/git
COPY . /data
WORKDIR /data

RUN if [ -d themes/internet-weblog ]; then rm -Rf themes/internet-weblog; fi
RUN git clone https://github.com/SummittDweller/internet-weblog.git themes/internet-weblog

##

# Part 1
FROM klakegg/hugo:0.55.6-ext-alpine
# FROM skyscrapers/hugo:0.48
# FROM skyscrapers/hugo:0.46
COPY --from=0 /data /data
WORKDIR /data
RUN hugo

##

# Part 2
FROM mysocialobservations/docker-tdewolff-minify
COPY --from=1 /data/public /data/public
WORKDIR /data
RUN minify --recursive --verbose \
        --match=\.*.js$ \
        --type=js \
        --output public/ \
        public/

WORKDIR /data
RUN minify --recursive --verbose \
        --match=\.*.css$ \
        --type=css \
        --output public/ \
        public/

WORKDIR /data
RUN minify --recursive --verbose \
        --match=\.*.html$ \
        --type=html \
        --output public/ \
        public/

##

# Part 3
FROM nginx:alpine
LABEL maintainer Mark A. McFate <mark.mcfate@icloud.com>
COPY --from=2 /data/public /var/www/site
WORKDIR /var/www/site
