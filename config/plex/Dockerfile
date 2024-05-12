# The first stage is responsible for building the application
FROM ruby:3.2.2-alpine as BUILD

# Set the environment variables
ENV ROOT=/srv

# Create the directory structure
RUN mkdir -p $ROOT

# Copy the Gemfile and Gemfile.lock separately to leverage Docker caching
COPY Gemfile* $ROOT/

# Change the working directory to the app's root directory
WORKDIR $ROOT

# Install build dependencies and necessary libraries
RUN apk --update --no-cache add \
      build-base \
      postgresql-dev \
      tzdata \
      git && \
    gem install bundler && \
    bundle install && \
    apk del build-base && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy the rest of the application code
COPY . $ROOT/

# The second stage is responsible for preparing the runtime
FROM ruby:3.2.2-alpine as RUNTIME

# Set environmental variables
ENV PORT=9594 \
    USER=app \
    GROUP=appgroup \
    ROOT=/srv

# Create the user and group
RUN addgroup -S $GROUP && \
    adduser -S $USER -G $GROUP

# Copy over files from the BUILD step
COPY --from=BUILD $ROOT $ROOT

# Set ownership and permissions
RUN chown -R $USER:$GROUP $ROOT && \
    chmod 755 $ROOT/config.ru && \
    chmod -R 775 $ROOT

# Change to the app's directory
WORKDIR $ROOT

# Switch to the non-root user
USER $USER:$GROUP

# Define the default command
CMD bundle exec puma -b tcp://0.0.0.0:$PORT
