# Generated file please do not change

import logging
import subscriptionexecutor

# Url of the OPC ua server
opc_server_url = ##CONNECTION##

# Url of the REST server
rest_server_url = ##RESTURL##

# Nodes to subscribe on
subscription_nodes = [##SUBSCRIPTIONNODES##]

# Polling interval in milliseconds
polling_interval = ##POLLINGINTERVAL##

# Log settings
log_level = logging.INFO
log_file = ##LOGFILEPATH##

# Execute the subscription listener
subscriptionexecutor.execute(opc_server_url, rest_server_url, subscription_nodes, polling_interval, log_level, log_file)
