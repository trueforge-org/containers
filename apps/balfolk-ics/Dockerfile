FROM ghcr.io/trueforge-org/python-alpine:3.12.11

USER root

# Install dependencies
RUN pip install --no-cache-dir requests beautifulsoup4 icalendar pytz

# Create working directory
WORKDIR /app

# Copy code
COPY --chown=nobody:nogroup . /

# Create output dir for serving
RUN touch /app/balfolk.ics

# Setup cron
RUN apk add --no-cache busybox-suid && crontab /app/crontab.txt

# Install cron job
RUN crontab /app/crontab.txt

