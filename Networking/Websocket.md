# Websocket

> 目前先简单理解，汇总部分资源，不定期学习。

- [An Introduction to WebSockets  | Treehouse Blog](https://blog.teamtreehouse.com/an-introduction-to-websockets)

Quick notes:

1. persistent connection between a client and server that both parties can use to start sending data at any time.
2. WebSocket handshake completes the initial HTTP connection which is replaced by a WebSocket connection.
3. Data is transferred through a WebSocket as *messages*, each of which consists of one or more *frames* containing the data you are sending (the payload).
4. Each frame is prefixed with 4-12 bytes of data about the payload, in order to ensure the message can be properly reconstructed

- [轮询、长轮询、长连接、websocket - 听风。 - 博客园](https://www.cnblogs.com/huchong/p/8595644.html)

- [About HTML5 WebSocket - Powered by Kaazing](https://www.websocket.org/aboutwebsocket.html)

