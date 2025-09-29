FROM ghcr.io/trueforge-org/python-alpine:3.13.0

USER root

# Install dependencies
RUN pip install --no-cache-dir requests beautifulsoup4 icalendar pytz

# Create working directory
WORKDIR /app

# Copy code
COPY --chown=nobody:nogroup --chmod=775 . /

# Create output dir for serving
RUN touch /app/balfolk.ics

# Setup cron
RUN apk add --no-cache bash curl busybox-suid && \
    echo "#!/bin/sh\ncrond -f -L /dev/stdout" > /start.sh && \
    chmod +x /start.sh

# Install cron job
RUN crontab /app/crontab.txt

# Start cron and HTTP server
CMD sh -c "python3 /app/balfolk_ical.py && crond -f -L /dev/stdout & python3 -m http.server 8000 --directory /app"



