import asyncio
import logging
import clientsubscription


def execute(opc_server_url=None, rest_server_url=None, subscription_nodes=None, polling_interval=1000, log_level=logging.INFO, log_file=None):

    """
    Execute the subscription
    Param:
        opc_server_url      - the url to the opc ua server (example: opc.tcp://milo.digitalpetri.com:62541/milo)
        rest_server_url     - the url to the REST server to post readings to
        subscription_nodes  - list of nodes to subscribe on
        polling_interval    - polling interval to the opc ua server in milliseconds
        log_level           - default to INFO
        log_file            - Location of the log file to log to. Defaults to None
    """
    try:

        # Set the client subscription
        clientsubscription.set_logging(log_level, log_file)
        clientsubscription.URL = rest_server_url

        # Get the event loop for this thread. When the loop is
        # closed create a new event loop for this thread
        loop = asyncio.get_event_loop()
        if loop.is_closed():
            loop = asyncio.new_event_loop()

        loop.run_until_complete(clientsubscription.execute(opc_server_url,
                                                           subscription_nodes,
                                                           polling_interval))

    finally:
        loop.close()
