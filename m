From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [ibacm] ibacm: Timeout address and route data
Date: Wed, 10 Oct 2012 15:54:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346AA40A7@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add an option that allows address and route data to
time out.  Once data has timed out, it needs to be
resolved again.  This helps handle cases where the
remote data has changed.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 linux/osd.h |    4 +++-
 src/acm.c   |   41 ++++++++++++++++++++++++++++++++++++++++-
 src/acme.c  |   21 +++++++++++++++++++--
 3 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/linux/osd.h b/linux/osd.h
index e2424b4..c8278aa 100644
--- a/linux/osd.h
+++ b/linux/osd.h
@@ -155,7 +155,9 @@ static inline uint64_t time_stamp_us(void)
 	return (uint64_t) curtime.tv_sec * 1000000 + (uint64_t) curtime.tv_usec;
 }
 
-#define time_stamp_ms() (time_stamp_us() / 1000)
+#define time_stamp_ms()  (time_stamp_us() / (uint64_t) 1000)
+#define time_stamp_sec() (time_stamp_ms() / (uint64_t) 1000)
+#define time_stamp_min() (time_stamp_sec() / (uint64_t) 60)
 
 #define PER_THREAD __thread
 static inline int beginthread(void (*func)(void *), void *arg)
diff --git a/src/acm.c b/src/acm.c
index b6fa32f..00fc35d 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2009-2010 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009-2012 Intel Corporation. All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -90,6 +90,8 @@ struct acm_dest {
 	lock_t                 lock;
 	enum acm_state         state;
 	atomic_t               refcnt;
+	uint64_t	       addr_timeout;
+	uint64_t	       route_timeout;
 	uint8_t                addr_type;
 };
 
@@ -212,7 +214,9 @@ static char log_file[128] = "/var/log/ibacm.log";
 static int log_level = 0;
 static char lock_file[128] = "/var/run/ibacm.pid";
 static enum acm_addr_prot addr_prot = ACM_ADDR_PROT_ACM;
+static int addr_timeout = 1440;
 static enum acm_route_prot route_prot = ACM_ROUTE_PROT_SA;
+static int route_timeout = -1;
 static enum acm_loopback_prot loopback_prot = ACM_LOOPBACK_PROT_LOCAL;
 static short server_port = 6125;
 static int timeout = 2000;
@@ -805,6 +809,8 @@ acm_record_acm_route(struct acm_ep *ep, struct acm_dest *dest)
 	dest->path = ep->mc_dest[i].path;
 	dest->path.dgid = dest->av.grh.dgid;
 	dest->path.dlid = htons(dest->av.dlid);
+	dest->addr_timeout = time_stamp_min() + (unsigned) addr_timeout;
+	dest->route_timeout = time_stamp_min() + (unsigned) route_timeout;
 	dest->state = ACM_READY;
 	return ACM_STATUS_SUCCESS;
 }
@@ -1111,6 +1117,9 @@ acm_dest_sa_resp(struct acm_send_msg *msg, struct ibv_wc *wc, struct acm_mad *ma
 	if (!status) {
 		memcpy(&dest->path, sa_mad->data, sizeof(dest->path));
 		acm_init_path_av(msg->ep->port, dest);
+		dest->addr_timeout = time_stamp_min() + (unsigned) addr_timeout;
+		dest->route_timeout = time_stamp_min() + (unsigned) route_timeout;
+		acm_log(2, "timeout addr %llu route %llu\n", dest->addr_timeout, dest->route_timeout);
 		dest->state = ACM_READY;
 	} else {
 		dest->state = ACM_INIT;
@@ -2085,6 +2094,22 @@ acm_svr_queue_req(struct acm_dest *dest, struct acm_client *client,
 	return ACM_STATUS_SUCCESS;
 }
 
+static int acm_dest_timeout(struct acm_dest *dest)
+{
+	uint64_t timestamp = time_stamp_min();
+
+	if (timestamp > dest->addr_timeout) {
+		acm_log(2, "%s address timed out\n", dest->name);
+		dest->state = ACM_INIT;
+		return 1;
+	} else if (timestamp > dest->route_timeout) {
+		acm_log(2, "%s route timed out\n", dest->name);
+		dest->state = ACM_ADDR_RESOLVED;
+		return 1;
+	}
+	return 0;
+}
+
 static int
 acm_svr_resolve_dest(struct acm_client *client, struct acm_msg *msg)
 {
@@ -2127,8 +2152,11 @@ acm_svr_resolve_dest(struct acm_client *client, struct acm_msg *msg)
 	}
 
 	lock_acquire(&dest->lock);
+test:
 	switch (dest->state) {
 	case ACM_READY:
+		if (acm_dest_timeout(dest))
+			goto test;
 		acm_log(2, "request satisfied from local cache\n");
 		atomic_inc(&counter[ACM_CNTR_ROUTE_CACHE]);
 		status = ACM_STATUS_SUCCESS;
@@ -2222,8 +2250,11 @@ acm_svr_resolve_path(struct acm_client *client, struct acm_msg *msg)
 	}
 
 	lock_acquire(&dest->lock);
+test:
 	switch (dest->state) {
 	case ACM_READY:
+		if (acm_dest_timeout(dest))
+			goto test;
 		acm_log(2, "request satisfied from local cache\n");
 		atomic_inc(&counter[ACM_CNTR_ROUTE_CACHE]);
 		status = ACM_STATUS_SUCCESS;
@@ -2620,6 +2651,8 @@ static int acm_init_ep_loopback(struct acm_ep *ep)
 		dest->path.rate = (uint8_t) ep->port->rate;
 
 		dest->remote_qpn = ep->qp->qp_num;
+		dest->addr_timeout = (uint64_t) ~0ULL;
+		dest->route_timeout = (uint64_t) ~0ULL;
 		dest->state = ACM_READY;
 		acm_put_dest(dest);
 		acm_log(1, "added loopback dest %s\n", dest->name);
@@ -3055,8 +3088,12 @@ static void acm_set_options(void)
 			strcpy(lock_file, value);
 		else if (!stricmp("addr_prot", opt))
 			addr_prot = acm_convert_addr_prot(value);
+		else if (!stricmp("addr_timeout", opt))
+			addr_timeout = atoi(value);
 		else if (!stricmp("route_prot", opt))
 			route_prot = acm_convert_route_prot(value);
+		else if (!strcmp("route_timeout", opt))
+			route_timeout = atoi(value);
 		else if (!stricmp("loopback_prot", opt))
 			loopback_prot = acm_convert_loopback_prot(value);
 		else if (!stricmp("server_port", opt))
@@ -3087,7 +3124,9 @@ static void acm_log_options(void)
 	acm_log(0, "log level %d\n", log_level);
 	acm_log(0, "lock file %s\n", lock_file);
 	acm_log(0, "address resolution %d\n", addr_prot);
+	acm_log(0, "address timeout %d\n", addr_timeout);
 	acm_log(0, "route resolution %d\n", route_prot);
+	acm_log(0, "route timeout %d\n", route_timeout);
 	acm_log(0, "loopback resolution %d\n", loopback_prot);
 	acm_log(0, "server_port %d\n", server_port);
 	acm_log(0, "timeout %d ms\n", timeout);
diff --git a/src/acme.c b/src/acme.c
index 0e1d4ed..4cd1a97 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -132,6 +132,14 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "\n");
 	fprintf(f, "addr_prot acm\n");
 	fprintf(f, "\n");
+	fprintf(f, "# addr_timeout:\n");
+	fprintf(f, "# Number of minutes to maintain IP address to GID mapping before\n");
+	fprintf(f, "# repeating address resolution.  A value of -1 indicates that the\n");
+	fprintf(f, "# mapping will not time out.\n");
+	fprintf(f, "# 1 hour = 60, 1 day = 1440, 1 week = 10080, 1 month ~ 43200");
+	fprintf(f, "\n");
+	fprintf(f, "addr_timeout 1440\n");
+	fprintf(f, "\n");
 	fprintf(f, "# route_prot:\n");
 	fprintf(f, "# Default resolution protocol to resolve IB routing information.\n");
 	fprintf(f, "# Supported protocols are:\n");
@@ -140,6 +148,15 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "\n");
 	fprintf(f, "route_prot sa\n");
 	fprintf(f, "\n");
+	fprintf(f, "# route_timeout:\n");
+	fprintf(f, "# Number of minutes to maintain IB routing information before\n");
+	fprintf(f, "# repeating route resolution.  A value of -1 indicates that the\n");
+	fprintf(f, "# mapping will not time out.  However, the route will\n");
+	fprintf(f, "# automatically time out when the address times out.\n");
+	fprintf(f, "# 1 hour = 60, 1 day = 1440, 1 week = 10080, 1 month ~ 43200");
+	fprintf(f, "\n");
+	fprintf(f, "route_timeout -1\n");
+	fprintf(f, "\n");
 	fprintf(f, "# loopback_prot:\n");
 	fprintf(f, "# Address and route resolution protocol to resolve local addresses\n");
 	fprintf(f, "# Supported protocols are:\n");
@@ -660,9 +677,9 @@ static void query_perf(char *svc)
 	}
 
 	printf("%s,", svc);
-	for (i = 0; i < cnt; i++)
+	for (i = 0; i < cnt - 1; i++)
 		printf("%llu,", (unsigned long long) counters[i]);
-	printf("\n");
+	printf("%llu\n", (unsigned long long) counters[i]);
 	ib_acm_free_perf(counters);
 }
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
