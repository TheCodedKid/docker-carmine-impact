# Use an Arch Linux base image
FROM archlinux:latest

# Update system and install dependencies
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm sdl2 sdl2_mixer sdl2_image sdl2_ttf curl enet git cmake make gcc \
    && pacman -Scc --noconfirm

# Clone the repository
RUN git clone --recursive https://github.com/HarpNetStudios/cardboard.git /cardboard

# Build the project
WORKDIR /cardboard
RUN git checkout $(git describe --tags) \
    && cmake CMakeLists.txt \
    && make native_server\
    && make install

# Modify the cardboard_unix script
# RUN sed -i 's/-cOFFLINE/-cYOUR_REPLACEMENT/g' cardboard_unix

# Create volume
# VOLUME ["/cardboard"]

# Set permissions
RUN chmod +x native_server

# Expose any necessary ports
 EXPOSE 35000
 EXPOSE 35001

# Command to run the application
CMD ["./native_server"]
