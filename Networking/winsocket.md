# Winsocket notes

> reference: [MSDN-Windows Sockets 2](https://docs.microsoft.com/en-us/windows/win32/winsock/windows-sockets-start-page-2)

## Simple TCP Client-Server Program

> repo: https://github.com/YueLu0116/Winsocket-learning

### Procedure

- Server：

1. initialize & create socket
   - api-[WSAStartup](https://docs.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-wsastartup)
   - data structure-[struct addrinfo](https://docs.microsoft.com/en-us/windows/win32/api/ws2def/ns-ws2def-addrinfoa)
   - api-[getaddrinfo-provides protocol-independent translation from an ANSI host name to an address.](https://docs.microsoft.com/en-us/windows/win32/api/ws2tcpip/nf-ws2tcpip-getaddrinfo)
   - data-structure-**SOCKET**
   - api-[socket](https://docs.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-socket)
   - 
2. bind
   - [bind-associates a local address with a socket.](https://docs.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-bind)
3. listen
   - [listen-listen on that IP address and port for incoming connection requests.](https://docs.microsoft.com/en-us/windows/win32/winsock/listening-on-a-socket)
4. accept
   - [accept-permits an incoming connection attempt on a socket.](https://docs.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-accept)
5. send & receive
6. disconnect

- Client

1. initialize & create
2. connect
   - [connect-establishes a connection to a specified socket.](https://docs.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-connect)
3. send & receive
   - [send-sends data on a connected socket.](https://docs.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-send)
   - [shutdown-disables sends or receives on a socket.](https://docs.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-shutdown)
   - [recv-receives data from a connected socket or a bound connectionless socket.](https://docs.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-recv)
4. disconnect