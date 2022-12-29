from network.network import Network
import socket            

class Connection(Network):
    def __init__(self, node):
        self.node_id = node.id
        self.peers = {self.node_id: {'peer': node, 'conn': None}}

    def connect(self, peer):
        peer_host = peer.address.get('host')
        peer_port = peer.address.get('port')
        peer_id =  peer.id
        sock = socket.socket()        
        sock.bind((peer_host, peer_port))        
        sock.listen(5)    
        while True:
            conn, addr = sock.accept()    
            print ('Got connection from', addr )
            conn.send('Thank you for connecting'.encode())
            break
        self.peers[peer_id] = {"peer": peer, "conn":conn}

    def connectClient(self, peer):
        peer_host = peer.address.get('host')
        peer_port = peer.address.get('port')
        peer_id =  peer.id
        sock = socket.socket()        
        sock.bind((peer_host, peer_port))        
        sock.listen(5)    
        while True:
            conn, addr = sock.accept()    
            print ('Got connection from', addr )
            conn.send('Thank you for connecting'.encode())
            break
        self.peers[peer_id] = {"peer": peer, "conn":conn}

    def disconnect(self, peer):
        peer_host = peer.address.get('host')
        peer_port = peer.address.get('port')
        for peer in self.peers:
            if peer.get('peer').address.get('host') == peer_host \
                and  peer.get('peer').address.get('port') == peer_port:
                peer.get('conn').close()


    def forget(self, peer):
        peer_host = peer.address.get('host')
        peer_port = peer.address.get('port')
        found_peer = None
        for peer in self.peers:
            if peer.get('peer').address.get('host') == peer_host \
                and  peer.get('peer').address.get('port') == peer_port:
                found_peer = peer; break
        self.peers.remove(found_peer)
