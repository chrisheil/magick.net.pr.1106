FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y && apt-get install wget curl -y

# The base image of ubuntu doesn't seem to have this installed by default, I am guessing the .iso includes it for the desktop environment
# If this is not installed then no steps below resolves the "Fontconfig error: Cannot load default config file" error
RUN apt-get install fontconfig -y

WORKDIR /tmp

# Install dotnet SDK
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

# Running script from dlemstra's comment
# https://github.com/dlemstra/Magick.NET/issues/598#issuecomment-605603721
RUN apt-get update \
 && apt-get install -y cabextract wget xfonts-utils \
 && curl -s -o ttf-mscorefonts-installer_3.7_all.deb http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb \
 && sh -c "echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections" \
 && dpkg -i ttf-mscorefonts-installer_3.7_all.deb

RUN apt-get update; \
  apt-get install -y apt-transport-https && \
  apt-get update && \
  apt-get install -y dotnet-sdk-6.0


# Setting env variable for fontconfig path from sambeckingham's comment
# https://github.com/dlemstra/Magick.NET/issues/598#issuecomment-605624607
ENV FONTCONFIG_PATH=/etc/fonts

# Begin running the app
WORKDIR /app
COPY . .
WORKDIR /app/MagickNet.1106

RUN dotnet build
RUN dotnet run
