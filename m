From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] ibacm: support no delay options
Date: Wed, 8 Dec 2010 12:41:08 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1ECAE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow a user to specify that address and/or route resolution
protocols should be suppressed, and that only locally cached
data should be returned.

This helps support rdma_getaddrinfo options RAI_NUMERICHOST
and RAI_NOROUTE.  If data for a request is available, it is
immediately returned.  Otherwise, the client request is
failed, but the lookup is still initiated.  This avoids
blocking a client for an extended period of time while
resolution completes, but allows future calls to find cached
data.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/acm.h |    1 +
 man/ib_acme.1            |    4 ++++
 src/acm.c                |   17 ++++++++---------
 src/acme.c               |   21 ++++++++++++++++++---
 src/libacm.c             |   14 +++++++-------
 src/libacm.h             |    4 ++--
 6 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/include/infiniband/acm.h b/include/infiniband/acm.h
index d193d43..41b95b8 100644
--- a/include/infiniband/acm.h
+++ b/include/infiniband/acm.h
@@ -51,6 +51,7 @@
 #define ACM_STATUS_EDESTTYPE    10
 
 #define ACM_FLAGS_QUERY_SA      (1<<31)
+#define ACM_FLAGS_NODELAY	(1<<30)
 
 #define ACM_MSG_HDR_LENGTH      16
 #define ACM_MAX_ADDRESS         64
diff --git a/man/ib_acme.1 b/man/ib_acme.1
index 0c0e332..52000a3 100644
--- a/man/ib_acme.1
+++ b/man/ib_acme.1
@@ -37,6 +37,10 @@ Indicates that the resolved path information should be verified with the
 active IB SA.  Use of the -v option provides a sanity check that
 resolved path information is usable given the current cluster configuration.
 .TP
+\-c
+Instructs the ACM service to only returned information that currently resides
+in its local cache.
+.TP
 \-A
 With this option, the ib_acme utility automatically generates the address
 configuration file acm_addr.cfg.  The generated file is
diff --git a/src/acm.c b/src/acm.c
index d9a81d9..08f233c 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1914,8 +1914,7 @@ acm_svr_verify_resolve(struct acm_resolve_msg *msg,
 
 	cnt = (msg->hdr.length - ACM_MSG_HDR_LENGTH) / ACM_MSG_EP_LENGTH;
 	for (i = 0; i < cnt; i++) {
-		switch (msg->data[i].flags) {
-		case ACM_EP_FLAG_SOURCE:
+		if (msg->data[i].flags & ACM_EP_FLAG_SOURCE) {
 			if (src) {
 				acm_log(0, "ERROR - multiple sources specified\n");
 				return ACM_STATUS_ESRCADDR;
@@ -1925,8 +1924,8 @@ acm_svr_verify_resolve(struct acm_resolve_msg *msg,
 				return ACM_STATUS_ESRCTYPE;
 			}
 			src = &msg->data[i];
-			break;
-		case ACM_EP_FLAG_DEST:
+		}
+		if (msg->data[i].flags & ACM_EP_FLAG_DEST) {
 			if (dst) {
 				acm_log(0, "ERROR - multiple destinations specified\n");
 				return ACM_STATUS_EDESTADDR;
@@ -1936,11 +1935,6 @@ acm_svr_verify_resolve(struct acm_resolve_msg *msg,
 				return ACM_STATUS_EDESTTYPE;
 			}
 			dst = &msg->data[i];
-			break;
-		default:
-			acm_log(0, "ERROR - unexpected endpoint flags 0x%x\n",
-				msg->data[i].flags);
-			return ACM_STATUS_EINVAL;
 		}
 	}
 
@@ -2040,6 +2034,11 @@ acm_svr_resolve(struct acm_client *client, struct acm_resolve_msg *msg)
 		/* fall through */
 	default:
 queue:
+		if (daddr->flags & ACM_FLAGS_NODELAY) {
+			acm_log(2, "lookup initiated, but client wants no delay\n");
+			status = ACM_STATUS_ENODATA;
+			break;
+		}
 		status = acm_svr_queue_req(dest, client, msg);
 		if (status) {
 			break;
diff --git a/src/acme.c b/src/acme.c
index cc34577..daa6051 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -51,6 +51,7 @@ static char *dest_addr;
 static char *src_addr;
 static char addr_type = 'i';
 static int verify;
+static int nodelay;
 static int make_addr;
 static int make_opts;
 int verbose;
@@ -70,6 +71,7 @@ static void show_usage(char *program)
 	printf("   -s src_addr      - format defined by -f option\n");
 	printf("   -d dest_addr     - format defined by -f option\n");
 	printf("   [-v]             - verify ACM response against SA query response\n");
+	printf("   [-c]             - read ACM cached data only\n");
 	printf("usage 2: %s\n", program);
 	printf("   -A [addr_file]   - generate local address configuration file\n");
 	printf("                      (default is %s)\n", ACM_ADDR_FILE);
@@ -418,6 +420,16 @@ static void show_path(struct ibv_path_record *path)
 	printf("  packet lifetime: %d\n", path->packetlifetime & 0x1F);
 }
 
+static uint32_t get_resolve_flags()
+{
+	uint32_t flags = 0;
+
+	if (nodelay)
+		flags |= ACM_FLAGS_NODELAY;
+
+	return flags;
+}
+
 static int resolve_ip(struct ibv_path_record *path)
 {
 	struct ibv_path_data *paths;
@@ -439,7 +451,7 @@ static int resolve_ip(struct ibv_path_record *path)
 	}
 
 	ret = ib_acm_resolve_ip((struct sockaddr *) &src, (struct sockaddr *) &dest,
-		&paths, &count);
+		&paths, &count, get_resolve_flags());
 	if (ret) {
 		printf("ib_acm_resolve_ip failed: 0x%x\n", ret);
 		return ret;
@@ -455,7 +467,7 @@ static int resolve_name(struct ibv_path_record *path)
 	struct ibv_path_data *paths;
 	int ret, count;
 
-	ret = ib_acm_resolve_name(src_addr, dest_addr, &paths, &count);
+	ret = ib_acm_resolve_name(src_addr, dest_addr, &paths, &count, get_resolve_flags());
 	if (ret) {
 		printf("ib_acm_resolve_name failed: 0x%x\n", ret);
 		return ret;
@@ -550,7 +562,7 @@ int CDECL_FUNC main(int argc, char **argv)
 	if (ret)
 		goto out;
 
-	while ((op = getopt(argc, argv, "f:s:d:vA::O::D:V")) != -1) {
+	while ((op = getopt(argc, argv, "f:s:d:vcA::O::D:V")) != -1) {
 		switch (op) {
 		case 'f':
 			addr_type = optarg[0];
@@ -564,6 +576,9 @@ int CDECL_FUNC main(int argc, char **argv)
 		case 'v':
 			verify = 1;
 			break;
+		case 'c':
+			nodelay = 1;
+			break;
 		case 'A':
 			make_addr = 1;
 			if (opt_arg(argc, argv))
diff --git a/src/libacm.c b/src/libacm.c
index 3ce0cd0..59a181b 100644
--- a/src/libacm.c
+++ b/src/libacm.c
@@ -143,7 +143,7 @@ err:
 }
 
 static int acm_resolve(uint8_t *src, uint8_t *dest, uint8_t type,
-	struct ibv_path_data **paths, int *count)
+	struct ibv_path_data **paths, int *count, uint32_t flags)
 {
 	struct acm_msg msg;
 	struct acm_resolve_msg *resolve_msg = (struct acm_resolve_msg *) &msg;
@@ -162,7 +162,7 @@ static int acm_resolve(uint8_t *src, uint8_t *dest, uint8_t type,
 	src_data->type   = type;
 	src_data->flags  = ACM_EP_FLAG_SOURCE;
 	dest_data->type  = type;
-	dest_data->flags = ACM_EP_FLAG_DEST;
+	dest_data->flags = ACM_EP_FLAG_DEST | flags;
 
 	switch (type) {
 	case ACM_EP_INFO_NAME:
@@ -202,21 +202,21 @@ out:
 }
 
 int ib_acm_resolve_name(char *src, char *dest,
-	struct ibv_path_data **paths, int *count)
+	struct ibv_path_data **paths, int *count, uint32_t flags)
 {
 	return acm_resolve((uint8_t *) src, (uint8_t *) dest,
-		ACM_EP_INFO_NAME, paths, count);
+		ACM_EP_INFO_NAME, paths, count, flags);
 }
 
 int ib_acm_resolve_ip(struct sockaddr *src, struct sockaddr *dest,
-	struct ibv_path_data **paths, int *count)
+	struct ibv_path_data **paths, int *count, uint32_t flags)
 {
 	if (((struct sockaddr *) dest)->sa_family == AF_INET) {
 		return acm_resolve((uint8_t *) src, (uint8_t *) dest,
-			ACM_EP_INFO_ADDRESS_IP, paths, count);
+			ACM_EP_INFO_ADDRESS_IP, paths, count, flags);
 	} else {
 		return acm_resolve((uint8_t *) src, (uint8_t *) dest,
-			ACM_EP_INFO_ADDRESS_IP6, paths, count);
+			ACM_EP_INFO_ADDRESS_IP6, paths, count, flags);
 	}
 }
 
diff --git a/src/libacm.h b/src/libacm.h
index 302099b..16df8b0 100644
--- a/src/libacm.h
+++ b/src/libacm.h
@@ -33,8 +33,8 @@ int libacm_init();
 void libacm_cleanup();
 
 int ib_acm_resolve_name(char *src, char *dest,
-	struct ibv_path_data **paths, int *count);
+	struct ibv_path_data **paths, int *count, uint32_t flags);
 int ib_acm_resolve_ip(struct sockaddr *src, struct sockaddr *dest,
-	struct ibv_path_data **paths, int *count);
+	struct ibv_path_data **paths, int *count, uint32_t flags);
 int ib_acm_resolve_path(struct ibv_path_record *path, uint32_t flags);
 #define ib_acm_free_paths(paths) free(paths)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
