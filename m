From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH krping]: Add support to accept IPV6 addresses as input argument.
Date: Thu, 3 Oct 2013 11:43:03 +0530
Message-ID: <68b243a0-781c-4d56-8a25-5dbb3d464a3c@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 krping.c |   55 ++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/krping.c b/krping.c
index 59900ab..43799eb 100644
--- a/krping.c
+++ b/krping.c
@@ -79,6 +79,7 @@ static const struct krping_option krping_opts[] = {
 	{"count", OPT_INT, 'C'},
 	{"size", OPT_INT, 'S'},
 	{"addr", OPT_STRING, 'a'},
+	{"addr6", OPT_STRING, 'A'},
 	{"port", OPT_INT, 'p'},
 	{"verbose", OPT_NOPARAM, 'v'},
 	{"validate", OPT_NOPARAM, 'V'},
@@ -131,6 +132,7 @@ static struct proc_dir_entry *krping_proc;
  *
  * /bin/echo server,port=9999,addr=192.168.69.142,validate > /proc/krping  
  * /bin/echo client,port=9999,addr=192.168.69.142,validate > /proc/krping  
+ * /bin/echo client,port=9999,addr6=2001:db8:0:f101::1,validate > /proc/krping
  *
  * krping "ping/pong" loop:
  * 	client sends source rkey/addr/len
@@ -235,8 +237,9 @@ struct krping_cb {
 	struct krping_stats stats;
 
 	uint16_t port;			/* dst port in NBO */
-	uint32_t addr;			/* dst addr in NBO */
+	u8 addr[16];			/* dst addr in NBO */
 	char *addr_str;			/* dst addr string */
+	uint8_t addr_type;		/* ADDR_FAMILY - IPv4/V6 */
 	int verbose;			/* verbose logging */
 	int count;			/* ping count */
 	int size;			/* ping data size */
@@ -1577,17 +1580,32 @@ static int fastreg_supported(struct ib_device *dev)
 	return 1;
 }
 
+static void fill_sockaddr(struct sockaddr *sin, struct krping_cb *cb)
+{
+	memset(sin, 0, sizeof(*sin));
+
+	if (cb->addr_type == AF_INET) {
+		struct sockaddr_in *sin4 = (struct sockaddr_in *)sin;
+		sin4->sin_family = AF_INET;
+		memcpy((void *)&sin4->sin_addr.s_addr, cb->addr, 4);
+		sin4->sin_port = cb->port;
+	} else if (cb->addr_type == AF_INET6) {
+		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)sin;
+		sin6->sin6_family = AF_INET6;
+		memcpy((void *)&sin6->sin6_addr, cb->addr, 16);
+		sin6->sin6_port = cb->port;
+	}
+}
+
 static int krping_bind_server(struct krping_cb *cb)
 {
-	struct sockaddr_in sin;
+	struct sockaddr sin;
 	int ret;
 
-	memset(&sin, 0, sizeof(sin));
-	sin.sin_family = AF_INET;
-	sin.sin_addr.s_addr = cb->addr;
-	sin.sin_port = cb->port;
 
-	ret = rdma_bind_addr(cb->cm_id, (struct sockaddr *) &sin);
+	fill_sockaddr(&sin, cb);
+
+	ret = rdma_bind_addr(cb->cm_id, &sin);
 	if (ret) {
 		printk(KERN_ERR PFX "rdma_bind_addr error %d\n", ret);
 		return ret;
@@ -1692,7 +1710,9 @@ static void krping_test_client(struct krping_cb *cb)
 			printk(KERN_ERR PFX "krping_format_send failed\n");
 			break;
 		}
+		DEBUG_LOG("%s(): Calling ib_post_send\n", __func__);
 		ret = ib_post_send(cb->qp, &cb->sq_wr, &bad_wr);
+		DEBUG_LOG("%s(): ib_post_send = %d\n", __func__, ret);
 		if (ret) {
 			printk(KERN_ERR PFX "post send error %d\n", ret);
 			break;
@@ -2029,6 +2049,7 @@ static int krping_connect_client(struct krping_cb *cb)
 	conn_param.initiator_depth = 1;
 	conn_param.retry_count = 10;
 
+	DEBUG_LOG("Calling rdma_connect..\n");
 	ret = rdma_connect(cb->cm_id, &conn_param);
 	if (ret) {
 		printk(KERN_ERR PFX "rdma_connect error %d\n", ret);
@@ -2047,16 +2068,12 @@ static int krping_connect_client(struct krping_cb *cb)
 
 static int krping_bind_client(struct krping_cb *cb)
 {
-	struct sockaddr_in sin;
+	struct sockaddr sin;
 	int ret;
 
-	memset(&sin, 0, sizeof(sin));
-	sin.sin_family = AF_INET;
-	sin.sin_addr.s_addr = cb->addr;
-	sin.sin_port = cb->port;
+	fill_sockaddr(&sin, cb);
 
-	ret = rdma_resolve_addr(cb->cm_id, NULL, (struct sockaddr *) &sin,
-				2000);
+	ret = rdma_resolve_addr(cb->cm_id, NULL, &sin, 2000);
 	if (ret) {
 		printk(KERN_ERR PFX "rdma_resolve_addr error %d\n", ret);
 		return ret;
@@ -2103,6 +2120,7 @@ static void krping_run_client(struct krping_cb *cb)
 		printk(KERN_ERR PFX "ib_post_recv failed: %d\n", ret);
 		goto err2;
 	}
+	DEBUG_LOG("ib_post_recv success!\n");
 
 	ret = krping_connect_client(cb);
 	if (ret) {
@@ -2155,9 +2173,16 @@ int krping_doit(char *cmd)
 		switch (op) {
 		case 'a':
 			cb->addr_str = optarg;
-			cb->addr = in_aton(optarg);
+			in4_pton(optarg, -1, cb->addr, -1, NULL);
+			cb->addr_type = AF_INET;
 			DEBUG_LOG("ipaddr (%s)\n", optarg);
 			break;
+		case 'A':
+			cb->addr_str = optarg;
+			in6_pton(optarg, -1, cb->addr, -1, NULL);
+			cb->addr_type = AF_INET6;
+			DEBUG_LOG("ipv6addr (%s)\n", optarg);
+			break;
 		case 'p':
 			cb->port = htons(optint);
 			DEBUG_LOG("port %d\n", (int)optint);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
