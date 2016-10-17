From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 04/13] ibacm: use the unix socket API directly
Date: Mon, 17 Oct 2016 21:11:13 +0200
Message-ID: <1476731482-26491-5-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/linux/osd.h  |  6 -----
 ibacm/src/acm.c    | 66 +++++++++++++++++++++++++++---------------------------
 ibacm/src/libacm.c | 16 ++++++-------
 3 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 31a7044..7ce52e6 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -118,12 +118,6 @@ static inline int event_wait(event_t *e, int timeout)
 #define osd_init()  0
 #define osd_close()
 
-#define SOCKET         int
-#define SOCKET_ERROR   -1
-#define INVALID_SOCKET -1
-#define socket_errno() errno
-#define closesocket    close
-
 static inline uint64_t time_stamp_us(void)
 {
 	struct timeval curtime;
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 33fc044..508148a 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -141,7 +141,7 @@ struct acmc_ep {
 
 struct acmc_client {
 	pthread_mutex_t lock;   /* acquire ep lock first */
-	SOCKET   sock;
+	int      sock;
 	int      index;
 	atomic_t refcnt;
 };
@@ -180,8 +180,8 @@ static struct acmc_prov *def_provider = NULL;
 
 static DLIST_ENTRY dev_list;
 
-static SOCKET listen_socket;
-static SOCKET ip_mon_socket;
+static int listen_socket;
+static int ip_mon_socket;
 static struct acmc_client client_array[FD_SETSIZE - 1];
 
 static FILE *flog;
@@ -195,7 +195,7 @@ static struct acmc_ep *acm_find_ep(struct acmc_port *port, uint16_t pkey);
 static int acm_ep_insert_addr(struct acmc_ep *ep, const char *name, uint8_t *addr,
 			      size_t addr_len, uint8_t addr_type);
 static void acm_event_handler(struct acmc_device *dev);
-static int acm_nl_send(SOCKET sock, struct acm_msg *msg);
+static int acm_nl_send(int sock, struct acm_msg *msg);
 
 static struct sa_data {
 	int		timeout;
@@ -484,7 +484,7 @@ int acm_resolve_response(uint64_t id, struct acm_msg *msg)
 		atomic_inc(&counter[ACM_CNTR_ERROR]);
 
 	pthread_mutex_lock(&client->lock);
-	if (client->sock == INVALID_SOCKET) {
+	if (client->sock == -1) {
 		acm_log(0, "ERROR - connection lost\n");
 		ret = ACM_STATUS_ENOTCONN;
 		goto release;
@@ -525,7 +525,7 @@ int acm_query_response(uint64_t id, struct acm_msg *msg)
 
 	acm_log(2, "status 0x%x\n", msg->hdr.status);
 	pthread_mutex_lock(&client->lock);
-	if (client->sock == INVALID_SOCKET) {
+	if (client->sock == -1) {
 		acm_log(0, "ERROR - connection lost\n");
 		ret = ACM_STATUS_ENOTCONN;
 		goto release;
@@ -559,7 +559,7 @@ static void acm_init_server(void)
 	for (i = 0; i < FD_SETSIZE - 1; i++) {
 		pthread_mutex_init(&client_array[i].lock, NULL);
 		client_array[i].index = i;
-		client_array[i].sock = INVALID_SOCKET;
+		client_array[i].sock = -1;
 		atomic_init(&client_array[i].refcnt);
 	}
 
@@ -578,24 +578,24 @@ static int acm_listen(void)
 
 	acm_log(2, "\n");
 	listen_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
-	if (listen_socket == INVALID_SOCKET) {
+	if (listen_socket == -1) {
 		acm_log(0, "ERROR - unable to allocate listen socket\n");
-		return socket_errno();
+		return errno;
 	}
 
 	memset(&addr, 0, sizeof addr);
 	addr.sin_family = AF_INET;
 	addr.sin_port = htons(server_port);
 	ret = bind(listen_socket, (struct sockaddr *) &addr, sizeof addr);
-	if (ret == SOCKET_ERROR) {
+	if (ret == -1) {
 		acm_log(0, "ERROR - unable to bind listen socket\n");
-		return socket_errno();
+		return errno;
 	}
 	
 	ret = listen(listen_socket, 0);
-	if (ret == SOCKET_ERROR) {
+	if (ret == -1) {
 		acm_log(0, "ERROR - unable to start listen\n");
-		return socket_errno();
+		return errno;
 	}
 
 	acm_log(2, "listen active\n");
@@ -606,20 +606,20 @@ static void acm_disconnect_client(struct acmc_client *client)
 {
 	pthread_mutex_lock(&client->lock);
 	shutdown(client->sock, SHUT_RDWR);
-	closesocket(client->sock);
-	client->sock = INVALID_SOCKET;
+	close(client->sock);
+	client->sock = -1;
 	pthread_mutex_unlock(&client->lock);
 	(void) atomic_dec(&client->refcnt);
 }
 
 static void acm_svr_accept(void)
 {
-	SOCKET s;
+	int s;
 	int i;
 
 	acm_log(2, "\n");
 	s = accept(listen_socket, NULL, NULL);
-	if (s == INVALID_SOCKET) {
+	if (s == -1) {
 		acm_log(0, "ERROR - failed to accept connection\n");
 		return;
 	}
@@ -633,7 +633,7 @@ static void acm_svr_accept(void)
 
 	if (i == FD_SETSIZE - 1) {
 		acm_log(0, "ERROR - all connections busy - rejecting\n");
-		closesocket(s);
+		close(s);
 		return;
 	}
 
@@ -797,7 +797,7 @@ static int acm_svr_select_src(struct acm_ep_addr_data *src, struct acm_ep_addr_d
 	union socket_addr addr;
 	socklen_t len;
 	int ret;
-	SOCKET s;
+	int s;
 
 	acm_log(2, "selecting source address\n");
 	memset(&addr, 0, sizeof addr);
@@ -818,22 +818,22 @@ static int acm_svr_select_src(struct acm_ep_addr_data *src, struct acm_ep_addr_d
 	}
 
 	s = socket(addr.sa.sa_family, SOCK_DGRAM, IPPROTO_UDP);
-	if (s == INVALID_SOCKET) {
+	if (s == -1) {
 		acm_log(0, "ERROR - unable to allocate socket\n");
-		return socket_errno();
+		return errno;
 	}
 
 	ret = connect(s, &addr.sa, len);
 	if (ret) {
 		acm_log(0, "ERROR - unable to connect socket\n");
-		ret = socket_errno();
+		ret = errno;
 		goto out;
 	}
 
 	ret = getsockname(s, &addr.sa, &len);
 	if (ret) {
 		acm_log(0, "ERROR - failed to get socket address\n");
-		ret = socket_errno();
+		ret = errno;
 		goto out;
 	}
 
@@ -1376,7 +1376,7 @@ static void acm_ipnl_handler(void)
 	}
 }
 
-static int acm_nl_send(SOCKET sock, struct acm_msg *msg)
+static int acm_nl_send(int sock, struct acm_msg *msg)
 {
 	struct sockaddr_nl dst_addr;
 	struct acm_nl_msg acmnlmsg;
@@ -1672,12 +1672,12 @@ static int acm_init_nl(void)
 {
 	struct sockaddr_nl src_addr;
 	int ret;
-	SOCKET nl_rcv_socket;
+	int nl_rcv_socket;
 
 	nl_rcv_socket = socket(PF_NETLINK, SOCK_RAW, NETLINK_RDMA);
-	if (nl_rcv_socket == INVALID_SOCKET) {
+	if (nl_rcv_socket == -1) {
 		acm_log(0, "ERROR - unable to allocate netlink recv socket\n");
-		return socket_errno();
+		return errno;
 	}
 
 	memset(&src_addr, 0, sizeof(src_addr));
@@ -1687,10 +1687,10 @@ static int acm_init_nl(void)
 
 	ret = bind(nl_rcv_socket, (struct sockaddr *)&src_addr,
 		   sizeof(src_addr));
-	if (ret == SOCKET_ERROR) {
+	if (ret == -1) {
 		acm_log(0, "ERROR - unable to bind netlink socket\n");
 		close(nl_rcv_socket);
-		return socket_errno();
+		return errno;
 	}
 
 	/* init nl client structure */
@@ -1725,7 +1725,7 @@ static void acm_server(void)
 		FD_SET(ip_mon_socket, &readfds);
 
 		for (i = 0; i < FD_SETSIZE - 1; i++) {
-			if (client_array[i].sock != INVALID_SOCKET) {
+			if (client_array[i].sock != -1) {
 				FD_SET(client_array[i].sock, &readfds);
 				n = max(n, (int) client_array[i].sock);
 			}
@@ -1739,7 +1739,7 @@ static void acm_server(void)
 		}
 
 		ret = select(n + 1, &readfds, NULL, NULL, NULL);
-		if (ret == SOCKET_ERROR) {
+		if (ret == -1) {
 			acm_log(0, "ERROR - server select error\n");
 			continue;
 		}
@@ -1751,7 +1751,7 @@ static void acm_server(void)
 			acm_ipnl_handler();
 
 		for (i = 0; i < FD_SETSIZE - 1; i++) {
-			if (client_array[i].sock != INVALID_SOCKET &&
+			if (client_array[i].sock != -1 &&
 				FD_ISSET(client_array[i].sock, &readfds)) {
 				acm_log(2, "receiving from client %d\n", i);
 				if (i == NL_CLIENT_INDEX)
@@ -3122,7 +3122,7 @@ int CDECL_FUNC main(int argc, char **argv)
 	acm_server();
 
 	acm_log(0, "shutting down\n");
-	if (client_array[NL_CLIENT_INDEX].sock != INVALID_SOCKET)
+	if (client_array[NL_CLIENT_INDEX].sock != -1)
 		close(client_array[NL_CLIENT_INDEX].sock);
 	acm_close_providers();
 	acm_stop_sa_handler();
diff --git a/ibacm/src/libacm.c b/ibacm/src/libacm.c
index 0f45469..4273dfe 100644
--- a/ibacm/src/libacm.c
+++ b/ibacm/src/libacm.c
@@ -39,7 +39,7 @@
 #include <arpa/inet.h>
 
 extern pthread_mutex_t lock;
-static SOCKET sock = INVALID_SOCKET;
+static int sock = -1;
 static short server_port = 6125;
 
 static void acm_set_server_port(void)
@@ -67,8 +67,8 @@ int ib_acm_connect(char *dest)
 		return ret;
 
 	sock = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
-	if (sock == INVALID_SOCKET) {
-		ret = socket_errno();
+	if (sock == -1) {
+		ret = errno;
 		goto err1;
 	}
 
@@ -81,8 +81,8 @@ int ib_acm_connect(char *dest)
 	return 0;
 
 err2:
-	closesocket(sock);
-	sock = INVALID_SOCKET;
+	close(sock);
+	sock = -1;
 err1:
 	freeaddrinfo(res);
 	return ret;
@@ -90,10 +90,10 @@ err1:
 
 void ib_acm_disconnect(void)
 {
-	if (sock != INVALID_SOCKET) {
+	if (sock != -1) {
 		shutdown(sock, SHUT_RDWR);
-		closesocket(sock);
-		sock = INVALID_SOCKET;
+		close(sock);
+		sock = -1;
 	}
 }
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
