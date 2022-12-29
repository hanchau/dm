

class Chat():
    def __init__(self, id):
        self.node_id = id
        self.chat = []
    
    def send(self, msg):
        self.chat.append(msg)

    def update(self):
        pass

    def delete(self):
        pass

    def save(self):
        pass