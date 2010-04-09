From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 27/37 v2] librdmacm: add support for IB ACM service
Date: Fri, 9 Apr 2010 11:56:58 -0700
Message-ID: <E16E68D19DD84A519D17966F0602DC80@amr.corp.intel.com>
References: <63A656D773734ACAA7EA63BB2C02DDD6@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <63A656D773734ACAA7EA63BB2C02DDD6-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allow the librdmacm to contact a service via sockets to obtain
address mapping and path record data.  The use of the service
is controlled through a build option (with-ib_acm).  If the
library fails to contact the service, it falls back to using
the kernel services to resolve address and routing data.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes from v1:
ACM was modified to resolve the address and route using only the
destination address.  If a source address is not given, then ACM
returns the source address that was used to resolve the route.
The source address belongs to the same address family as that
specified by the destination address.

 Makefile.am    |    2 -
 configure.in   |   14 ++++
 src/acm.c      |  195 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/addrinfo.c |    3 +
 src/cma.c      |    9 ++-
 src/cma.h      |   13 +++-
 6 files changed, 232 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index be53c78..8d86045 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -12,7 +12,7 @@ else
     librdmacm_version_script =
 endif
 
-src_librdmacm_la_SOURCES = src/cma.c src/addrinfo.c
+src_librdmacm_la_SOURCES = src/cma.c src/addrinfo.c src/acm.c
 src_librdmacm_la_LDFLAGS = -version-info 1 -export-dynamic \
 			   $(librdmacm_version_script)
 src_librdmacm_la_DEPENDENCIES =  $(srcdir)/src/librdmacm.map
diff --git a/configure.in b/configure.in
index 1122966..3db4247 100644
--- a/configure.in
+++ b/configure.in
@@ -21,6 +21,15 @@ if test "$with_valgrind" != "" && test "$with_valgrind" != "no"; then
 	fi
 fi
 
+AC_ARG_WITH([ib_acm],
+    AC_HELP_STRING([--with-ib_acm],
+		   [Use IB ACM for route resolution - default NO]))
+
+if test "$with_ib_acm" != "" && test "$with_ib_acm" != "no"; then
+	AC_DEFINE([USE_IB_ACM], 1,
+		  [Define to 1 to use IB ACM for endpoint resolution])
+fi
+
 AC_ARG_ENABLE(libcheck, [  --disable-libcheck      do not test for presence of ib libraries],
 [       if test "$enableval" = "no"; then
                 disable_libcheck=yes
@@ -51,6 +60,11 @@ AC_CHECK_HEADER(valgrind/memcheck.h, [],
     AC_MSG_ERROR([valgrind requested but <valgrind/memcheck.h> not found.]))
 fi
 
+if test "$with_ib_acm" != "" && test "$with_ib_acm" != "no"; then
+AC_CHECK_HEADER(infiniband/acm.h, [],
+    AC_MSG_ERROR([IB ACM requested but <infiniband/acm.h> not found.]))
+fi
+
 fi
 
 AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
diff --git a/src/acm.c b/src/acm.c
new file mode 100644
index 0000000..6fdd72e
--- /dev/null
+++ b/src/acm.c
@@ -0,0 +1,195 @@
+/*
+ * Copyright (c) 2010 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#if HAVE_CONFIG_H
+#  include <config.h>
+#endif /* HAVE_CONFIG_H */
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netdb.h>
+#include <unistd.h>
+
+#include "cma.h"
+#include <rdma/rdma_cma.h>
+#include <infiniband/ib.h>
+#include <infiniband/sa.h>
+
+#ifdef USE_IB_ACM
+#include <infiniband/acm.h>
+
+static pthread_mutex_t acm_lock = PTHREAD_MUTEX_INITIALIZER;
+static int sock;
+static short server_port = 6125;
+
+void ucma_ib_init(void)
+{
+	struct sockaddr_in addr;
+	int ret;
+
+	sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+	if (sock < 0)
+		return;
+
+	memset(&addr, 0, sizeof addr);
+	addr.sin_family = AF_INET;
+	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+	addr.sin_port = htons(server_port);
+	ret = connect(sock, (struct sockaddr *) &addr, sizeof(addr));
+	if (ret)
+		goto err;
+
+	return;
+
+err:
+	close(sock);
+	sock = 0;
+}
+
+void ucma_ib_cleanup(void)
+{
+	if (sock > 0) {
+		shutdown(sock, SHUT_RDWR);
+		close(sock);
+	}
+}
+
+static void ucma_ib_save_resp(struct rdma_addrinfo *rai, struct acm_resolve_msg *msg)
+{
+	struct ib_path_data *path_data = NULL;
+	int i, cnt, path_cnt;
+
+	cnt = (msg->hdr.length - ACM_MSG_HDR_LENGTH) / ACM_MSG_EP_LENGTH;
+	for (i = 0; i < cnt; i++) {
+		switch (msg->data[i].type) {
+		case ACM_EP_INFO_PATH:
+			msg->data[i].type = 0;
+			if (!path_data)
+				path_data = (struct ib_path_data *) &msg->data[i];
+			path_cnt++;
+			break;
+		case ACM_EP_INFO_ADDRESS_IP:
+			if (!(msg->data[i].flags & ACM_EP_FLAG_SOURCE) || rai->ai_src_len)
+				break;
+
+			rai->ai_src_addr = calloc(1, sizeof(struct sockaddr_in));
+			if (!rai->ai_src_addr)
+				break;
+
+			rai->ai_src_len = sizeof(struct sockaddr_in);
+			memcpy(&((struct sockaddr_in *) rai->ai_src_addr)->sin_addr,
+			       &msg->data[i].info.addr, 4);
+			break;
+		case ACM_EP_INFO_ADDRESS_IP6:
+			if (!(msg->data[i].flags & ACM_EP_FLAG_SOURCE) || rai->ai_src_len)
+				break;
+
+			rai->ai_src_addr = calloc(1, sizeof(struct sockaddr_in6));
+			if (!rai->ai_src_addr)
+				break;
+
+			rai->ai_src_len = sizeof(struct sockaddr_in6);
+			memcpy(&((struct sockaddr_in6 *) rai->ai_src_addr)->sin6_addr,
+			       &msg->data[i].info.addr, 16);
+			break;
+		default:
+			break;
+		}
+	}
+
+	rai->ai_route = calloc(path_cnt, sizeof(*path_data));
+	if (rai->ai_route) {
+		memcpy(rai->ai_route, path_data, path_cnt * sizeof(*path_data));
+		rai->ai_route_len = path_cnt * sizeof(*path_data);
+	}
+}
+
+void ucma_ib_resolve(struct rdma_addrinfo *rai)
+{
+	struct acm_msg msg;
+	struct acm_resolve_msg *resolve_msg = (struct acm_resolve_msg *) &msg;
+	struct acm_ep_addr_data *src_data, *dst_data;
+	int ret;
+
+	if (sock <= 0)
+		return;
+
+	memset(&msg, 0, sizeof msg);
+	msg.hdr.version = ACM_VERSION;
+	msg.hdr.opcode = ACM_OP_RESOLVE;
+
+	if (rai->ai_src_len) {
+		src_data = &resolve_msg->data[0];
+		src_data->flags = ACM_EP_FLAG_SOURCE;
+		if (rai->ai_family == AF_INET) {
+			src_data->type = ACM_EP_INFO_ADDRESS_IP;
+			memcpy(src_data->info.addr,
+			       &((struct sockaddr_in *) rai->ai_src_addr)->sin_addr, 4);
+		} else {
+			src_data->type = ACM_EP_INFO_ADDRESS_IP6;
+			memcpy(src_data->info.addr,
+			       &((struct sockaddr_in6 *) rai->ai_src_addr)->sin6_addr, 16);
+		}
+		dst_data = &resolve_msg->data[1];
+		msg.hdr.length = ACM_MSG_HDR_LENGTH + (2 * ACM_MSG_EP_LENGTH);
+	} else {
+		dst_data = &resolve_msg->data[0];
+		msg.hdr.length = ACM_MSG_HDR_LENGTH + ACM_MSG_EP_LENGTH;
+	}
+
+	dst_data->flags = ACM_EP_FLAG_DEST;
+	if (rai->ai_family == AF_INET) {
+		dst_data->type = ACM_EP_INFO_ADDRESS_IP;
+		memcpy(dst_data->info.addr,
+		       &((struct sockaddr_in *) rai->ai_dst_addr)->sin_addr, 4);
+	} else {
+		dst_data->type = ACM_EP_INFO_ADDRESS_IP6;
+		memcpy(dst_data->info.addr,
+		       &((struct sockaddr_in6 *) rai->ai_dst_addr)->sin6_addr, 16);
+	}
+	
+	pthread_mutex_lock(&acm_lock);
+	ret = send(sock, (char *) &msg, msg.hdr.length, 0);
+	if (ret != msg.hdr.length) {
+		pthread_mutex_unlock(&acm_lock);
+		return;
+	}
+
+	ret = recv(sock, (char *) &msg, sizeof msg, 0);
+	pthread_mutex_unlock(&acm_lock);
+	if (ret < ACM_MSG_HDR_LENGTH || ret != msg.hdr.length || msg.hdr.status)
+		return;
+
+	ucma_ib_save_resp(rai, resolve_msg);
+}
+
+#endif /* USE_IB_ACM */
diff --git a/src/addrinfo.c b/src/addrinfo.c
index f5f86a0..c8d9f0c 100644
--- a/src/addrinfo.c
+++ b/src/addrinfo.c
@@ -171,6 +171,9 @@ int rdma_getaddrinfo(char *node, char *service,
 		rai->ai_src_len = hints->ai_src_len;
 	}
 
+	if (!(rai->ai_flags & RAI_PASSIVE))
+		ucma_ib_resolve(rai);
+
 	freeaddrinfo(ai);
 	*res = rai;
 	return 0;
diff --git a/src/cma.c b/src/cma.c
index a23e2eb..6dfb87c 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -149,6 +149,8 @@ int af_ib_support;
 
 static void ucma_cleanup(void)
 {
+	ucma_ib_cleanup();
+
 	if (cma_dev_cnt) {
 		while (cma_dev_cnt--) {
 			ibv_dealloc_pd(cma_dev_array[cma_dev_cnt].pd);
@@ -196,7 +198,7 @@ int ucma_init(void)
 	struct ibv_device **dev_list = NULL;
 	struct cma_device *cma_dev;
 	struct ibv_device_attr attr;
-	int i, ret, dev_cnt;
+	int i, ret, dev_cnt, ib;
 
 	/* Quick check without lock to see if we're already initialized */
 	if (cma_dev_cnt)
@@ -225,7 +227,7 @@ int ucma_init(void)
 		goto err2;
 	}
 
-	for (i = 0; dev_list[i];) {
+	for (i = 0, ib = 0; dev_list[i];) {
 		cma_dev = &cma_dev_array[i];
 
 		cma_dev->guid = ibv_get_device_guid(dev_list[i]);
@@ -253,8 +255,11 @@ int ucma_init(void)
 		cma_dev->port_cnt = attr.phys_port_cnt;
 		cma_dev->max_initiator_depth = (uint8_t) attr.max_qp_init_rd_atom;
 		cma_dev->max_responder_resources = (uint8_t) attr.max_qp_rd_atom;
+		ib += (cma_dev->verbs->device->transport_type == IBV_TRANSPORT_IB);
 	}
 
+	if (ib)
+		ucma_ib_init();
 	cma_dev_cnt = dev_cnt;
 	pthread_mutex_unlock(&mut);
 	ibv_free_device_list(dev_list);
diff --git a/src/cma.h b/src/cma.h
index 4e2312f..ba62456 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -43,6 +43,8 @@
 #include <endian.h>
 #include <byteswap.h>
 
+#include <rdma/rdma_cma.h>
+
 #ifdef INCLUDE_VALGRIND
 #   include <valgrind/memcheck.h>
 #   ifndef VALGRIND_MAKE_MEM_DEFINED
@@ -74,5 +76,14 @@ static inline int ERR(int err)
 
 int ucma_init();
 
-#endif /* CMA_H */
+#ifdef USE_IB_ACM
+void ucma_ib_init();
+void ucma_ib_cleanup();
+void ucma_ib_resolve(struct rdma_addrinfo *rai);
+#else
+#define ucma_ib_init()
+#define ucma_ib_cleanup()
+#define ucma_ib_resolve(x)
+#endif
 
+#endif /* CMA_H */



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
