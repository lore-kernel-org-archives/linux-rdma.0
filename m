From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ibacm: Add performance counters
Date: Thu, 30 Jun 2011 18:26:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302BEF9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add performance counters to track service usage.  Counters are exposed
via a new perf query request.  Update ib_acme to retrieve counters from
a specified endpoint.

Counters that are currently defined are:

- Address and route resolution errors
- Resolution requests
- Requests not satisfied as a result of no data available
- Requests requiring an address lookup
- Requests that found address information in the cache
- Requests requiring a route lookup (i.e. path record query)
- Requests that found route information in the cache

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/acm.h |   19 +++++++++-
 src/acm.c                |   90 +++++++++++++++++++++++++++++++++++-----------
 src/acme.c               |   66 ++++++++++++++++++++++++++++++----
 src/libacm.c             |   66 ++++++++++++++++++++++++++++------
 src/libacm.h             |   12 +++++-
 5 files changed, 209 insertions(+), 44 deletions(-)

diff --git a/include/infiniband/acm.h b/include/infiniband/acm.h
index 143d512..23d8198 100644
--- a/include/infiniband/acm.h
+++ b/include/infiniband/acm.h
@@ -37,6 +37,7 @@
 
 #define ACM_OP_MASK             0x0F
 #define ACM_OP_RESOLVE          0x01
+#define ACM_OP_PERF_QUERY       0x02
 #define ACM_OP_ACK              0x80
 
 #define ACM_STATUS_SUCCESS      0
@@ -66,7 +67,7 @@ struct acm_hdr {
 	uint8_t                 version;
 	uint8_t                 opcode;
 	uint8_t                 status;
-	uint8_t		        reserved[3];
+	uint8_t		        data[3];
 	uint16_t                length;
 	uint64_t                tid;
 };
@@ -97,6 +98,22 @@ struct acm_resolve_msg {
 	struct acm_ep_addr_data data[0];
 };
 
+enum {
+	ACM_CNTR_ERROR,
+	ACM_CNTR_RESOLVE,
+	ACM_CNTR_NODATA,
+	ACM_CNTR_ADDR_QUERY,
+	ACM_CNTR_ADDR_CACHE,
+	ACM_CNTR_ROUTE_QUERY,
+	ACM_CNTR_ROUTE_CACHE,
+	ACM_MAX_COUNTER
+};
+
+struct acm_perf_msg {
+	struct acm_hdr          hdr;
+	uint64_t                data[0];
+};
+
 struct acm_msg {
 	struct acm_hdr          hdr;
 	uint8_t                 data[ACM_MSG_DATA_LENGTH];
diff --git a/src/acm.c b/src/acm.c
index 7b0639a..54b2411 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -47,7 +47,7 @@
 #include <search.h>
 #include "acm_mad.h"
 
-#define src_out     reserved[0]
+#define src_out     data[0]
 
 #define MAX_EP_ADDR 4
 #define MAX_EP_MC   2
@@ -194,7 +194,11 @@ static struct acm_client client[FD_SETSIZE - 1];
 static FILE *flog;
 static lock_t log_lock;
 PER_THREAD char log_data[ACM_MAX_ADDRESS];
+static atomic_t counter[ACM_MAX_COUNTER];
 
+/*
+ * Service options - may be set through acm_opts file.
+ */
 static char *opts_file = "/etc/ibacm/acm_opts.cfg";
 static char *addr_file = "/etc/ibacm/acm_addr.cfg";
 static char log_file[128] = "/var/log/ibacm.log";
@@ -893,6 +897,7 @@ static uint8_t acm_resolve_path(struct acm_ep *ep, struct acm_dest *dest,
 	memcpy(mad->data, &dest->path, sizeof(dest->path));
 	mad->comp_mask = acm_path_comp_mask(&dest->path);
 
+	atomic_inc(&counter[ACM_CNTR_ROUTE_QUERY]);
 	dest->state = ACM_QUERY_ROUTE;
 	acm_post_send(&ep->sa_queue, msg);
 	return ACM_STATUS_SUCCESS;
@@ -1004,6 +1009,11 @@ acm_client_resolve_resp(struct acm_client *client, struct acm_resolve_msg *req_m
 	acm_log(2, "client %d, status 0x%x\n", client->index, status);
 	memset(&msg, 0, sizeof msg);
 
+	if (status == ACM_STATUS_ENODATA)
+		atomic_inc(&counter[ACM_CNTR_NODATA]);
+	else if (status)
+		atomic_inc(&counter[ACM_CNTR_ERROR]);
+
 	lock_acquire(&client->lock);
 	if (client->sock == INVALID_SOCKET) {
 		acm_log(0, "ERROR - connection lost\n");
@@ -1015,7 +1025,7 @@ acm_client_resolve_resp(struct acm_client *client, struct acm_resolve_msg *req_m
 	resp_msg->hdr.opcode |= ACM_OP_ACK;
 	resp_msg->hdr.status = status;
 	resp_msg->hdr.length = ACM_MSG_HDR_LENGTH;
-	memset(resp_msg->hdr.reserved, 0, sizeof(resp_msg->hdr.reserved));
+	memset(resp_msg->hdr.data, 0, sizeof(resp_msg->hdr.data));
 
 	if (status == ACM_STATUS_SUCCESS) {
 		resp_msg->hdr.length += ACM_MSG_EP_LENGTH;
@@ -1848,6 +1858,7 @@ acm_svr_query_path(struct acm_client *client, struct acm_resolve_msg *msg)
 	memcpy(mad->data, &msg->data[0].info.path, sizeof(struct ibv_path_record));
 	mad->comp_mask = acm_path_comp_mask(&msg->data[0].info.path);
 
+	atomic_inc(&counter[ACM_CNTR_ROUTE_QUERY]);
 	acm_post_send(&ep->sa_queue, sa_msg);
 	return ACM_STATUS_SUCCESS;
 
@@ -1896,6 +1907,7 @@ acm_send_resolve(struct acm_ep *ep, struct acm_dest *dest,
 	for (i = 0; i < ep->mc_cnt; i++)
 		memcpy(&rec->gid[i], ep->mc_dest[i].address, 16);
 	
+	atomic_inc(&counter[ACM_CNTR_ADDR_QUERY]);
 	acm_post_send(&ep->resolve_queue, msg);
 	return 0;
 }
@@ -2038,7 +2050,7 @@ acm_svr_queue_req(struct acm_dest *dest, struct acm_client *client,
 }
 
 static int
-acm_svr_resolve(struct acm_client *client, struct acm_resolve_msg *msg)
+acm_svr_resolve_dest(struct acm_client *client, struct acm_resolve_msg *msg)
 {
 	struct acm_ep *ep;
 	struct acm_dest *dest;
@@ -2082,10 +2094,12 @@ acm_svr_resolve(struct acm_client *client, struct acm_resolve_msg *msg)
 	switch (dest->state) {
 	case ACM_READY:
 		acm_log(2, "request satisfied from local cache\n");
+		atomic_inc(&counter[ACM_CNTR_ROUTE_CACHE]);
 		status = ACM_STATUS_SUCCESS;
 		break;
 	case ACM_ADDR_RESOLVED:
 		acm_log(2, "have address, resolving route\n");
+		atomic_inc(&counter[ACM_CNTR_ADDR_CACHE]);
 		status = acm_resolve_path(ep, dest, acm_dest_sa_resp);
 		if (status) {
 			break;
@@ -2175,6 +2189,7 @@ acm_svr_resolve_path(struct acm_client *client, struct acm_resolve_msg *msg)
 	switch (dest->state) {
 	case ACM_READY:
 		acm_log(2, "request satisfied from local cache\n");
+		atomic_inc(&counter[ACM_CNTR_ROUTE_CACHE]);
 		status = ACM_STATUS_SUCCESS;
 		break;
 	case ACM_INIT:
@@ -2209,10 +2224,46 @@ put:
 	return ret;
 }
 
+static int acm_svr_resolve(struct acm_client *client, struct acm_resolve_msg *msg)
+{
+	if (msg->data[0].type == ACM_EP_INFO_PATH) {
+		if (msg->data[0].flags & ACM_FLAGS_QUERY_SA) {
+			return acm_svr_query_path(client, msg);
+		} else {
+			return acm_svr_resolve_path(client, msg);
+		}
+	} else {
+		return acm_svr_resolve_dest(client, msg);
+	}
+}
+
+static int acm_svr_perf_query(struct acm_client *client, struct acm_perf_msg *msg)
+{
+	int ret, i;
+
+	acm_log(2, "client %d\n", client->index);
+	msg->hdr.opcode |= ACM_OP_ACK;
+	msg->hdr.status = ACM_STATUS_SUCCESS;
+	msg->hdr.data[0] = ACM_MAX_COUNTER;
+	msg->hdr.data[1] = 0;
+	msg->hdr.data[2] = 0;
+	msg->hdr.length = ACM_MSG_HDR_LENGTH + (ACM_MAX_COUNTER * sizeof(uint64_t));
+
+	for (i = 0; i < ACM_MAX_COUNTER; i++)
+		msg->data[i] = (uint64_t) atomic_get(&counter[i]);
+
+	ret = send(client->sock, (char *) msg, msg->hdr.length, 0);
+	if (ret != msg->hdr.length)
+		acm_log(0, "ERROR - failed to send response\n");
+	else
+		ret = 0;
+
+	return ret;
+}
+
 static void acm_svr_receive(struct acm_client *client)
 {
 	struct acm_msg msg;
-	struct acm_resolve_msg *resolve_msg = (struct acm_resolve_msg *) &msg;
 	int ret;
 
 	acm_log(2, "client %d\n", client->index);
@@ -2228,19 +2279,17 @@ static void acm_svr_receive(struct acm_client *client)
 		goto out;
 	}
 
-	if ((msg.hdr.opcode & ACM_OP_MASK) != ACM_OP_RESOLVE) {
+	switch (msg.hdr.opcode & ACM_OP_MASK) {
+	case ACM_OP_RESOLVE:
+		atomic_inc(&counter[ACM_CNTR_RESOLVE]);
+		ret = acm_svr_resolve(client, (struct acm_resolve_msg *) &msg);
+		break;
+	case ACM_OP_PERF_QUERY:
+		ret = acm_svr_perf_query(client, (struct acm_perf_msg *) &msg);
+		break;
+	default:
 		acm_log(0, "ERROR - unknown opcode 0x%x\n", msg.hdr.opcode);
-		goto out;
-	}
-
-	if (resolve_msg->data[0].type == ACM_EP_INFO_PATH) {
-		if (resolve_msg->data[0].flags & ACM_FLAGS_QUERY_SA) {
-			ret = acm_svr_query_path(client, resolve_msg);
-		} else {
-			ret = acm_svr_resolve_path(client, resolve_msg);
-		}
-	} else {
-		ret = acm_svr_resolve(client, resolve_msg);
+		break;
 	}
 
 out:
@@ -2557,7 +2606,6 @@ static struct acm_ep *
 acm_alloc_ep(struct acm_port *port, uint16_t pkey, uint16_t pkey_index)
 {
 	struct acm_ep *ep;
-	int i;
 
 	acm_log(1, "\n");
 	ep = calloc(1, sizeof *ep);
@@ -2577,9 +2625,6 @@ acm_alloc_ep(struct acm_port *port, uint16_t pkey, uint16_t pkey_index)
 	DListInit(&ep->wait_queue);
 	lock_init(&ep->lock);
 
-	for (i = 0; i < MAX_EP_MC; i++)
-		acm_init_dest(&ep->mc_dest[i], ACM_ADDRESS_GID, NULL, 0);
-
 	return ep;
 }
 
@@ -3080,7 +3125,7 @@ static void show_usage(char *program)
 
 int CDECL_FUNC main(int argc, char **argv)
 {
-	int op, daemon = 1;
+	int i, op, daemon = 1;
 
 	while ((op = getopt(argc, argv, "DPA:O:")) != -1) {
 		switch (op) {
@@ -3123,6 +3168,9 @@ int CDECL_FUNC main(int argc, char **argv)
 	DListInit(&dev_list);
 	DListInit(&timeout_list);
 	event_init(&timeout_event);
+	for (i = 0; i < ACM_MAX_COUNTER; i++)
+		atomic_init(&counter[i]);
+
 	umad_init();
 	if (acm_open_devices()) {
 		acm_log(0, "ERROR - unable to open any devices\n");
diff --git a/src/acme.c b/src/acme.c
index d42ba81..3787998 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -52,8 +52,6 @@ static char *src_addr;
 static char addr_type = 'u';
 static int verify;
 static int nodelay;
-static int make_addr;
-static int make_opts;
 int verbose;
 
 struct ibv_context **verbs;
@@ -74,6 +72,8 @@ static void show_usage(char *program)
 	printf("   [-v]             - verify ACM response against SA query response\n");
 	printf("   [-c]             - read ACM cached data only\n");
 	printf("usage 2: %s\n", program);
+	printf("   -P dest_addr     - query performance data from destination service");
+	printf("usage 3: %s\n", program);
 	printf("   -A [addr_file]   - generate local address configuration file\n");
 	printf("                      (default is %s)\n", ACM_ADDR_FILE);
 	printf("   -O [opt_file]    - generate local acm_opts.cfg options file\n");
@@ -587,7 +587,7 @@ static int resolve(char *program, char *dest_arg)
 	int ret, i = 0;
 	char dest_type;
 
-	ret = libacm_init();
+	ret = ib_acm_connect("127.0.0.1");
 	if (ret) {
 		printf("Unable to contact ib_acm service\n");
 		return ret;
@@ -631,7 +631,47 @@ static int resolve(char *program, char *dest_arg)
 	}
 
 	free(dest_list);
-	libacm_cleanup();
+	ib_acm_disconnect();
+	return ret;
+}
+
+static int query_perf(char *program, char *dest_arg)
+{
+	char **dest_list;
+	int ret, cnt, i, d;
+	uint64_t *counters;
+
+	dest_list = parse(dest_arg, NULL);
+	if (!dest_list) {
+		printf("Unable to parse destination argument\n");
+		return -1;
+	}
+
+	printf("Destination,Error Count,Resolve Count,No Data,Addr Query Count,"
+	       "Addr Cache Count,Route Query Count,Route Cache Count\n");
+	for (d = 0; dest_list[d]; d++) {
+
+		printf("%s,", dest_list[d]);
+		ret = ib_acm_connect(dest_list[d]);
+		if (ret) {
+			printf("Unable to contact ib_acm service\n");
+			continue;
+		}
+
+		ret = ib_acm_query_perf(&counters, &cnt);
+		if (ret) {
+			printf("Failed to query perf data %s\n", strerror(errno));
+		} else {
+			for (i = 0; i < cnt; i++)
+				printf("%llu,", (unsigned long long) counters[i]);
+			printf("\n");
+			ib_acm_free_perf(counters);
+		}
+
+		ib_acm_disconnect();
+	}
+
+	free(dest_list);
 	return ret;
 }
 
@@ -650,12 +690,15 @@ int CDECL_FUNC main(int argc, char **argv)
 {
 	char *dest_arg = NULL;
 	int op, ret;
+	int make_addr = 0;
+	int make_opts = 0;
+	int perf_query = 0;
 
 	ret = osd_init();
 	if (ret)
 		goto out;
 
-	while ((op = getopt(argc, argv, "f:s:d:vcA::O::D:V")) != -1) {
+	while ((op = getopt(argc, argv, "f:s:d:vcA::O::D:P:V")) != -1) {
 		switch (op) {
 		case 'f':
 			addr_type = optarg[0];
@@ -685,6 +728,10 @@ int CDECL_FUNC main(int argc, char **argv)
 		case 'D':
 			dest_dir = optarg;
 			break;
+		case 'P':
+			perf_query = 1;
+			dest_arg = optarg;
+			break;
 		case 'V':
 			verbose = 1;
 			break;
@@ -700,8 +747,12 @@ int CDECL_FUNC main(int argc, char **argv)
 		exit(1);
 	}
 
-	if (dest_arg)
-		ret = resolve(argv[0], dest_arg);
+	if (dest_arg) {
+		if (perf_query)
+			ret = query_perf(argv[0], dest_arg);
+		else
+			ret = resolve(argv[0], dest_arg);
+	}
 
 	if (!ret && make_addr)
 		ret = gen_addr();
@@ -709,6 +760,7 @@ int CDECL_FUNC main(int argc, char **argv)
 	if (!ret && make_opts)
 		ret = gen_opts();
 
+	osd_close();
 out:
 	if (verbose || !(make_addr || make_opts) || ret)
 		printf("return status 0x%x\n", ret);
diff --git a/src/libacm.c b/src/libacm.c
index 31014d1..5331b2c 100644
--- a/src/libacm.c
+++ b/src/libacm.c
@@ -36,6 +36,8 @@
 #include <infiniband/acm.h>
 #include <stdio.h>
 #include <errno.h>
+#include <netdb.h>
+#include <arpa/inet.h>
 
 struct acm_port {
 	uint8_t           port_num;
@@ -66,45 +68,46 @@ static void acm_set_server_port(void)
 	}
 }
 
-int libacm_init(void)
+int ib_acm_connect(char *dest)
 {
-	struct sockaddr_in addr;
+	struct addrinfo hint, *res;
 	int ret;
 
-	ret = osd_init();
+	acm_set_server_port();
+	memset(&hint, 0, sizeof hint);
+	hint.ai_protocol = IPPROTO_TCP;
+	ret = getaddrinfo(dest, NULL, &hint, &res);
 	if (ret)
 		return ret;
 
-	acm_set_server_port();
-	sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+	sock = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
 	if (sock == INVALID_SOCKET) {
 		ret = socket_errno();
 		goto err1;
 	}
 
-	memset(&addr, 0, sizeof addr);
-	addr.sin_family = AF_INET;
-	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
-	addr.sin_port = htons(server_port);
-	ret = connect(sock, (struct sockaddr *) &addr, sizeof(addr));
+	((struct sockaddr_in *) res->ai_addr)->sin_port = htons(server_port);
+	ret = connect(sock, res->ai_addr, res->ai_addrlen);
 	if (ret)
 		goto err2;
 
+	freeaddrinfo(res);
 	return 0;
 
 err2:
 	closesocket(sock);
 	sock = INVALID_SOCKET;
 err1:
-	osd_close();
+	freeaddrinfo(res);
 	return ret;
 }
 
-void libacm_cleanup(void)
+void ib_acm_disconnect(void)
 {
 	if (sock != INVALID_SOCKET) {
 		shutdown(sock, SHUT_RDWR);
 		closesocket(sock);
+		sock = INVALID_SOCKET;
 	}
 }
 
@@ -310,3 +313,42 @@ out:
 	lock_release(&lock);
 	return ret;
 }
+
+int ib_acm_query_perf(uint64_t **counters, int *count)
+{
+	struct acm_msg msg;
+	struct acm_perf_msg *perf_msg = (struct acm_perf_msg *) &msg;
+	int ret;
+
+	lock_acquire(&lock);
+	memset(&msg, 0, sizeof msg);
+	msg.hdr.version = ACM_VERSION;
+	msg.hdr.opcode = ACM_OP_PERF_QUERY;
+	msg.hdr.length = ACM_MSG_HDR_LENGTH;
+
+	ret = send(sock, (char *) &msg, msg.hdr.length, 0);
+	if (ret != msg.hdr.length)
+		goto out;
+
+	ret = recv(sock, (char *) &msg, sizeof msg, 0);
+	if (ret < ACM_MSG_HDR_LENGTH || ret != msg.hdr.length)
+		goto out;
+
+	if (msg.hdr.status) {
+		ret = acm_error(msg.hdr.status);
+		goto out;
+	}
+
+	*counters = malloc(sizeof(uint64_t) * msg.hdr.data[0]);
+	if (!*counters) {
+		ret = ACM_STATUS_ENOMEM;
+		goto out;
+	}
+
+	memcpy(*counters, perf_msg->data, sizeof(uint64_t) * msg.hdr.data[0]);
+	*count = msg.hdr.data[0];
+	ret = 0;
+out:
+	lock_release(&lock);
+	return ret;
+}
diff --git a/src/libacm.h b/src/libacm.h
index 16df8b0..049b7a9 100644
--- a/src/libacm.h
+++ b/src/libacm.h
@@ -27,10 +27,13 @@
  * SOFTWARE.
  */
 
+#ifndef LIBACM_H
+#define LIBACM_H
+
 #include <infiniband/acm.h>
 
-int libacm_init();
-void libacm_cleanup();
+int ib_acm_connect(char *dest_svc);
+void ib_acm_disconnect();
 
 int ib_acm_resolve_name(char *src, char *dest,
 	struct ibv_path_data **paths, int *count, uint32_t flags);
@@ -38,3 +41,8 @@ int ib_acm_resolve_ip(struct sockaddr *src, struct sockaddr *dest,
 	struct ibv_path_data **paths, int *count, uint32_t flags);
 int ib_acm_resolve_path(struct ibv_path_record *path, uint32_t flags);
 #define ib_acm_free_paths(paths) free(paths)
+
+int ib_acm_query_perf(uint64_t **counters, int *count);
+#define ib_acm_free_perf(counters) free(counters)
+
+#endif /* LIBACM_H */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
