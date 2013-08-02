From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH librdmacm 1/5] rsockets: Support native IB addressing on connected rsockets
Date: Fri,  2 Aug 2013 15:20:18 -0700
Message-ID: <1375482022-5953-2-git-send-email-sean.hefty@intel.com>
References: <1375482022-5953-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375482022-5953-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Update rsockets to support AF_IB addresses on connected rsockets.
Support for datagram rsockets is more difficult as a result of
using real UDP sockets for QP resolution, so that support is
deferred.  For connected sockets, we need to update internal
checks to handle AF_IB.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c     |   12 ------------
 src/cma.h     |   12 ++++++++++++
 src/rsocket.c |   39 +++++++++++++++++++++++++++++----------
 3 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 33379cf..45bcb81 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -116,18 +116,6 @@ static pthread_mutex_t acm_lock = PTHREAD_MUTEX_INITIALIZER;
 static int sock = -1;
 static uint16_t server_port;
 
-struct ib_connect_hdr {
-	uint8_t  cma_version;
-	uint8_t  ip_version; /* IP version: 7:4 */
-	uint16_t port;
-	uint32_t src_addr[4];
-	uint32_t dst_addr[4];
-#define cma_src_ip4 src_addr[3]
-#define cma_src_ip6 src_addr[0]
-#define cma_dst_ip4 dst_addr[3]
-#define cma_dst_ip6 dst_addr[0]
-};
-
 static int ucma_set_server_port(void)
 {
 	FILE *f;
diff --git a/src/cma.h b/src/cma.h
index e6fba8b..e944a9a 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -206,6 +206,18 @@ struct ibv_path_data
 };
 #endif
 
+struct ib_connect_hdr {
+	uint8_t  cma_version;
+	uint8_t  ip_version; /* IP version: 7:4 */
+	uint16_t port;
+	uint32_t src_addr[4];
+	uint32_t dst_addr[4];
+#define cma_src_ip4 src_addr[3]
+#define cma_src_ip6 src_addr[0]
+#define cma_dst_ip4 dst_addr[3]
+#define cma_dst_ip6 dst_addr[0]
+};
+
 #ifndef SYSCONFDIR
 #define SYSCONFDIR "/etc"
 #endif
diff --git a/src/rsocket.c b/src/rsocket.c
index ef24dfb..e2b1cc7 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -187,6 +187,16 @@ struct rs_conn_data {
 	struct rs_sge	  data_buf;
 };
 
+struct rs_conn_private_data {
+	union {
+		struct rs_conn_data		conn_data;
+		struct {
+			struct ib_connect_hdr	ib_hdr;
+			struct rs_conn_data	conn_data;
+		} af_ib;
+	};
+};
+
 /*
  * rsocket states are ordered as passive, connecting, connected, disconnected.
  */
@@ -965,8 +975,13 @@ static void rs_free(struct rsocket *rs)
 	free(rs);
 }
 
-static void rs_set_conn_data(struct rsocket *rs, struct rdma_conn_param *param,
-			     struct rs_conn_data *conn)
+static size_t rs_conn_data_offset(struct rsocket *rs)
+{
+	return (rs->cm_id->route.addr.src_addr.sa_family == AF_IB) ?
+		sizeof(struct ib_connect_hdr) : 0;
+}
+
+static void rs_format_conn_data(struct rsocket *rs, struct rs_conn_data *conn)
 {
 	conn->version = 1;
 	conn->flags = RS_CONN_FLAG_IOMAP |
@@ -982,9 +997,6 @@ static void rs_set_conn_data(struct rsocket *rs, struct rdma_conn_param *param,
 	conn->data_buf.addr = htonll((uintptr_t) rs->rbuf);
 	conn->data_buf.length = htonl(rs->rbuf_size >> 1);
 	conn->data_buf.key = htonl(rs->rmr->rkey);
-
-	param->private_data = conn;
-	param->private_data_len = sizeof *conn;
 }
 
 static void rs_save_conn_data(struct rsocket *rs, struct rs_conn_data *conn)
@@ -1063,7 +1075,7 @@ int rsocket(int domain, int type, int protocol)
 	struct rsocket *rs;
 	int index, ret;
 
-	if ((domain != PF_INET && domain != PF_INET6) ||
+	if ((domain != AF_INET && domain != AF_INET6 && domain != AF_IB) ||
 	    ((type != SOCK_STREAM) && (type != SOCK_DGRAM)) ||
 	    (type == SOCK_STREAM && protocol && protocol != IPPROTO_TCP) ||
 	    (type == SOCK_DGRAM && protocol && protocol != IPPROTO_UDP))
@@ -1165,7 +1177,8 @@ int raccept(int socket, struct sockaddr *addr, socklen_t *addrlen)
 	if (ret < 0)
 		goto err;
 
-	creq = (struct rs_conn_data *) new_rs->cm_id->event->param.conn.private_data;
+	creq = (struct rs_conn_data *)
+	       (new_rs->cm_id->event->param.conn.private_data + rs_conn_data_offset(rs));
 	if (creq->version != 1) {
 		ret = ERR(ENOTSUP);
 		goto err;
@@ -1180,7 +1193,9 @@ int raccept(int socket, struct sockaddr *addr, socklen_t *addrlen)
 
 	rs_save_conn_data(new_rs, creq);
 	param = new_rs->cm_id->event->param.conn;
-	rs_set_conn_data(new_rs, &param, &cresp);
+	rs_format_conn_data(new_rs, &cresp);
+	param.private_data = &cresp;
+	param.private_data_len = sizeof cresp;
 	ret = rdma_accept(new_rs->cm_id, &param);
 	if (!ret)
 		new_rs->state = rs_connect_rdwr;
@@ -1201,7 +1216,8 @@ err:
 static int rs_do_connect(struct rsocket *rs)
 {
 	struct rdma_conn_param param;
-	struct rs_conn_data creq, *cresp;
+	struct rs_conn_private_data cdata;
+	struct rs_conn_data *creq, *cresp;
 	int to, ret;
 
 	switch (rs->state) {
@@ -1246,7 +1262,10 @@ do_connect:
 			break;
 
 		memset(&param, 0, sizeof param);
-		rs_set_conn_data(rs, &param, &creq);
+		creq = (void *) &cdata + rs_conn_data_offset(rs);
+		rs_format_conn_data(rs, creq);
+		param.private_data = (void *) creq - rs_conn_data_offset(rs);
+		param.private_data_len = sizeof(*creq) + rs_conn_data_offset(rs);
 		param.flow_control = 1;
 		param.retry_count = 7;
 		param.rnr_retry_count = 7;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
