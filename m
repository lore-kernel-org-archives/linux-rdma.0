From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2 16/16 ibacm] Add option to allow for ACM cache lookup performance
 measurement
Date: Thu, 27 Jun 2013 15:14:35 -0400
Message-ID: <51CC8F1B.8090902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


-C option is added for resolution repetition count

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Rebased

 man/ib_acme.1 |    8 ++++++--
 src/acme.c    |   52 +++++++++++++++++++++++++++++++---------------------
 src/libacm.c  |   20 +++++++++++---------
 src/libacm.h  |    7 +++++--
 4 files changed, 53 insertions(+), 34 deletions(-)

diff --git a/man/ib_acme.1 b/man/ib_acme.1
index 6485858..e67a242 100644
--- a/man/ib_acme.1
+++ b/man/ib_acme.1
@@ -1,10 +1,10 @@
-.TH "ib_acme" 7 "2013-06-15" "ib_acme" "ib_acme" ib_acme
+.TH "ib_acme" 7 "2013-06-21" "ib_acme" "ib_acme" ib_acme
 .SH NAME
 ib_acme \- test and configuration utility for the IB ACM
 .SH SYNOPSIS
 .sp
 .nf
-\fIib_acme\fR [-f addr_format] [-s src_addr] -d dest_addr [-v] [-c] [-P] [-S svc_addr]
+\fIib_acme\fR [-f addr_format] [-s src_addr] -d dest_addr [-v] [-c] [-P] [-S svc_addr] [-C repetitions]
 .fi
 .nf
 \fIib_acme\fR [-A [addr_file]] [-O [opt_file]] [-D dest_dir] [-V]
@@ -48,6 +48,10 @@ Queries performance data from the destination service
 \-S svc_addr
 address of ACM service, default: local service
 .TP
+\-C repetitions
+number of repetitions to perform resolution.  Used to measure
+performance of ACM cache lookups.  Defaults to 1. 
+.TP
 \-A [addr_file]
 With this option, the ib_acme utility automatically generates the address
 configuration file ibacm_addr.cfg.  The generated file is
diff --git a/src/acme.c b/src/acme.c
index 648e97f..525868e 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2009-2010 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies LTD. All rights reserved. 
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -55,6 +56,7 @@ static char *src_arg;
 static char addr_type = 'u';
 static int verify;
 static int nodelay;
+static int repetitions = 1;
 
 enum perf_query_output {
 	PERF_QUERY_NONE,
@@ -84,6 +86,7 @@ static void show_usage(char *program)
 	printf("   [-c]             - read ACM cached data only\n");
 	printf("   [-P]             - query performance data from destination service\n");
 	printf("   [-S svc_addr]    - address of ACM service, default: local service\n");
+	printf("   [-C repetitions] - repeat count for resolution\n");
 	printf("usage 2: %s\n", program);
 	printf("Generate default ibacm service configuration and option files\n");
 	printf("   -A [addr_file]   - generate local address configuration file\n");
@@ -528,7 +531,7 @@ static int resolve_ip(struct ibv_path_record *path)
 
 	ret = ib_acm_resolve_ip(saddr,
 		(is_ipv6_dest ? (struct sockaddr *) &dest6 : (struct sockaddr *) &dest),
-		&paths, &count, get_resolve_flags());
+		&paths, &count, get_resolve_flags(), (repetitions == 1));
 	if (ret) {
 		printf("ib_acm_resolve_ip failed: %s\n", strerror(errno));
 		return ret;
@@ -544,7 +547,7 @@ static int resolve_name(struct ibv_path_record *path)
 	struct ibv_path_data *paths;
 	int ret, count;
 
-	ret = ib_acm_resolve_name(src_addr, dest_addr, &paths, &count, get_resolve_flags());
+	ret = ib_acm_resolve_name(src_addr, dest_addr, &paths, &count, get_resolve_flags(), (repetitions == 1));
 	if (ret) {
 		printf("ib_acm_resolve_name failed: %s\n", strerror(errno));
 		return ret;
@@ -658,7 +661,7 @@ static void resolve(char *svc)
 {
 	char **dest_list, **src_list;
 	struct ibv_path_record path;
-	int ret, d = 0, s = 0;
+	int ret = 0, d = 0, s = 0, i;
 	char dest_type;
 
 	dest_list = parse(dest_arg, NULL);
@@ -678,23 +681,25 @@ static void resolve(char *svc)
 			printf("Destination: %s\n", dest_addr);
 			if (src_addr)
 				printf("Source: %s\n", src_addr);
-			switch (dest_type) {
-			case 'i':
-				ret = resolve_ip(&path);
-				break;
-			case 'n':
-				ret = resolve_name(&path);
-				break;
-			case 'l':
-				memset(&path, 0, sizeof path);
-				ret = resolve_lid(&path);
-				break;
-			case 'g':
-				memset(&path, 0, sizeof path);
-				ret = resolve_gid(&path);
-				break;
-			default:
-				break;
+			for (i = 0; i < repetitions; i++) {
+				switch (dest_type) {
+				case 'i':
+					ret = resolve_ip(&path);
+					break;
+				case 'n':
+					ret = resolve_name(&path);
+					break;
+				case 'l':
+					memset(&path, 0, sizeof path);
+					ret = resolve_lid(&path);
+					break;
+				case 'g':
+					memset(&path, 0, sizeof path);
+					ret = resolve_gid(&path);
+					break;
+				default:
+					break;
+				}
 			}
 
 			if (!ret)
@@ -798,7 +803,7 @@ int CDECL_FUNC main(int argc, char **argv)
 	if (ret)
 		goto out;
 
-	while ((op = getopt(argc, argv, "f:s:d:vcA::O::D:P::S:V")) != -1) {
+	while ((op = getopt(argc, argv, "f:s:d:vcA::O::D:P::S:C:V")) != -1) {
 		switch (op) {
 		case 'f':
 			addr_type = optarg[0];
@@ -840,6 +845,11 @@ int CDECL_FUNC main(int argc, char **argv)
 		case 'S':
 			svc_arg = optarg;
 			break;
+		case 'C':
+			repetitions = atoi(optarg);
+			if (!repetitions)
+				repetitions = 1;
+			break;
 		case 'V':
 			verbose = 1;
 			break;
diff --git a/src/libacm.c b/src/libacm.c
index 274eb2d..1bf7030 100644
--- a/src/libacm.c
+++ b/src/libacm.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2009 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies LTD. All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -113,7 +114,7 @@ void ib_acm_disconnect(void)
 }
 
 static int acm_format_resp(struct acm_msg *msg,
-	struct ibv_path_data **paths, int *count)
+	struct ibv_path_data **paths, int *count, int print)
 {
 	struct ibv_path_data *path_data;
 	char addr[ACM_MAX_ADDRESS];
@@ -154,7 +155,8 @@ static int acm_format_resp(struct acm_msg *msg,
 			default:
 				goto err;
 			}
-			printf("Source: %s\n", addr);
+			if (print)
+				printf("Source: %s\n", addr);
 			break;
 		}
 	}
@@ -221,7 +223,7 @@ static int acm_error(uint8_t status)
 }
 
 static int acm_resolve(uint8_t *src, uint8_t *dest, uint8_t type,
-	struct ibv_path_data **paths, int *count, uint32_t flags)
+	struct ibv_path_data **paths, int *count, uint32_t flags, int print)
 {
 	struct acm_msg msg;
 	int ret, cnt = 0;
@@ -258,28 +260,28 @@ static int acm_resolve(uint8_t *src, uint8_t *dest, uint8_t type,
 		goto out;
 	}
 
-	ret = acm_format_resp(&msg, paths, count);
+	ret = acm_format_resp(&msg, paths, count, print);
 out:
 	lock_release(&lock);
 	return ret;
 }
 
 int ib_acm_resolve_name(char *src, char *dest,
-	struct ibv_path_data **paths, int *count, uint32_t flags)
+	struct ibv_path_data **paths, int *count, uint32_t flags, int print)
 {
 	return acm_resolve((uint8_t *) src, (uint8_t *) dest,
-		ACM_EP_INFO_NAME, paths, count, flags);
+		ACM_EP_INFO_NAME, paths, count, flags, print);
 }
 
 int ib_acm_resolve_ip(struct sockaddr *src, struct sockaddr *dest,
-	struct ibv_path_data **paths, int *count, uint32_t flags)
+	struct ibv_path_data **paths, int *count, uint32_t flags, int print)
 {
 	if (((struct sockaddr *) dest)->sa_family == AF_INET) {
 		return acm_resolve((uint8_t *) src, (uint8_t *) dest,
-			ACM_EP_INFO_ADDRESS_IP, paths, count, flags);
+			ACM_EP_INFO_ADDRESS_IP, paths, count, flags, print);
 	} else {
 		return acm_resolve((uint8_t *) src, (uint8_t *) dest,
-			ACM_EP_INFO_ADDRESS_IP6, paths, count, flags);
+			ACM_EP_INFO_ADDRESS_IP6, paths, count, flags, print);
 	}
 }
 
diff --git a/src/libacm.h b/src/libacm.h
index 61220d5..9a241aa 100644
--- a/src/libacm.h
+++ b/src/libacm.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2009 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2013 Mellanox Technologies LTD. All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -36,9 +37,11 @@ int ib_acm_connect(char *dest_svc);
 void ib_acm_disconnect();
 
 int ib_acm_resolve_name(char *src, char *dest,
-	struct ibv_path_data **paths, int *count, uint32_t flags);
+	struct ibv_path_data **paths, int *count, uint32_t flags,
+	int print);
 int ib_acm_resolve_ip(struct sockaddr *src, struct sockaddr *dest,
-	struct ibv_path_data **paths, int *count, uint32_t flags);
+	struct ibv_path_data **paths, int *count, uint32_t flags,
+	int print);
 int ib_acm_resolve_path(struct ibv_path_record *path, uint32_t flags);
 #define ib_acm_free_paths(paths) free(paths)
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
