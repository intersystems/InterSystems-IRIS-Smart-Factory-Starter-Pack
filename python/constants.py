# Subscription runtime before next period in seconds
# Default 60 but can be much higher in production.
MAX_SUBSCRIPTION_RUN_INTERVAL = 60

# After the run interval has expired stop the service. Call Interval
# will call the service again. When False the service will continue for ever.
STOP_AFTER_INTERVAL = True
