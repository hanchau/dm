from network.node import Node

user1 = Node('127.0.0.1', 1234)

user2 = Node('127.0.0.1', 1235)


user1.connect(user2)