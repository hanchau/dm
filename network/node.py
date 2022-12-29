from network.network import Network
from network.connection import Connection
from chat.chat import Chat
import uuid

class Node(Network):
    def __init__(self, Host, Port):
        self.id = uuid.uuid4()
        self.address = {'host': Host, 'port': Port}
        self.connections = Connection(self)
        self.chat = Chat(self.id)

    def connect(self, peer):
        self.connections.connect(peer)

    def accept_connection_request():
        pass

    def load_chat(self):
        pass