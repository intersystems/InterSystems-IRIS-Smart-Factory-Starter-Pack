import sys
import asyncio
import logging
import constants

from asyncua import Client, Node, ua

sys.path.insert(0, "..")

# OPC UA server
_logger = logging.getLogger('opcua')

# Basic logger configuration
logging.basicConfig(level=logging.ERROR)
is_logger_configured = False

class SubscriptionHandler:
    """
    The SubscriptionHandler is used to handle the data that is received for the subscription.
    """
    def datachange_notification(self, node: Node, val, data):
        """
        Callback for subscription.
        This method will be called when the Client received a data change message from the Server.
        """
        _logger.info('datachange_notification %r %s', node, val)


def set_logging(log_level=logging.INFO, log_file=None):
    """
    Set the logging so we are able to trace what is going on
    Param:
        log_level   - default to INFO
        log_file    - Location of the log file to log to. Defaults to None
    """
    global is_logger_configured

    # Set default log level
    _logger.setLevel(log_level)

    if log_file and not is_logger_configured:
        fh = logging.FileHandler(log_file)
        fh.setLevel(log_level)
        _logger.addHandler(fh)
        is_logger_configured = True


async def execute(opc_server_url=None, subscription_nodes=None, polling_interval=1000):
    """
    Create the client and start listening to the nodes
    Param:
        opc_server_url      - the url to the opc ua server (example: opc.tcp://milo.digitalpetri.com:62541/milo)
        subscription_nodes  - list of nodes to subscribe on
        polling_interval    - polling interval to the opc ua server in milliseconds
    """
    client = Client(url=opc_server_url)
    async with client:

        # Create the subscription handler
        handler = SubscriptionHandler()

        # We create a Client Subscription.
        subscription = await client.create_subscription(polling_interval, handler)

        # Set current time of server for time based storage
        nodes = [client.get_node(ua.ObjectIds.Server_ServerStatus_CurrentTime)]

        for node in subscription_nodes:
            nodes.append(client.get_node(node))

        # We subscribe to data changes for two nodes (variables).
        await subscription.subscribe_data_change(nodes)

        stop_running = False
        while not stop_running:
            _logger.info("Start running loop for " +
                          str(constants.MAX_SUBSCRIPTION_RUN_INTERVAL) +
                          " seconds")

            # We let the subscription run for the MAX_SUBSCRIPTION_RUN_INTERVAL
            await asyncio.sleep(constants.MAX_SUBSCRIPTION_RUN_INTERVAL)

            if constants.STOP_AFTER_INTERVAL:
                stop_running = True

        # We delete the subscription (this un-subscribes from the data changes of the two variables).
        # This is optional since closing the connection will also delete all subscriptions.
        await subscription.delete()

        # After one second we exit the Client context manager - this will close the connection.
        await asyncio.sleep(1)

