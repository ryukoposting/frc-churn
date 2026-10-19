FROM ruby:3.4

# Set the working directory
WORKDIR /churn

# Install system dependencies for Gruff
RUN apt-get update && apt-get install -y --no-install-recommends \
    imagemagick \
    zip \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install the gruff Ruby gem
RUN gem install gruff csv descriptive_statistics

COPY . .

VOLUME ["/churn/cache", "/churn/output"]
