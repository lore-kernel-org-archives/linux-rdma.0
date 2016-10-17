From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/13] ibacm: cleanup "lock"
Date: Mon, 17 Oct 2016 21:11:19 +0200
Message-ID: <1476731482-26491-11-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Make it static to libacm.c, give it a more reasonable name and initialize
it at compile time.

Note tha the critical sections for this lock could be reduced easily, but
that's a different project if someone cares enough..

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/CMakeLists.txt       |  1 -
 ibacm/linux/libacm_linux.c | 37 -------------------------------------
 ibacm/src/libacm.c         | 22 +++++++++++-----------
 3 files changed, 11 insertions(+), 49 deletions(-)
 delete mode 100644 ibacm/linux/libacm_linux.c

diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
index 7ed8fd5..505fba3 100644
--- a/ibacm/CMakeLists.txt
+++ b/ibacm/CMakeLists.txt
@@ -38,7 +38,6 @@ set_target_properties(ibacmp PROPERTIES
 install(TARGETS ibacmp DESTINATION "${ACM_PROVIDER_DIR}")
 
 rdma_executable(ib_acme
-  linux/libacm_linux.c
   src/acme.c
   src/libacm.c
   src/parse.c
diff --git a/ibacm/linux/libacm_linux.c b/ibacm/linux/libacm_linux.c
deleted file mode 100644
index 2b8a910..0000000
--- a/ibacm/linux/libacm_linux.c
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Copyright (c) 2009 Intel Corporation. All rights reserved.
- *
- * This software is available to you under the OpenIB.org BSD license
- * below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#include <osd.h>
-
-pthread_mutex_t lock;
-
-static void __attribute__((constructor)) lib_init(void)
-{
-	pthread_mutex_init(&lock, NULL);
-}
diff --git a/ibacm/src/libacm.c b/ibacm/src/libacm.c
index 4273dfe..1980919 100644
--- a/ibacm/src/libacm.c
+++ b/ibacm/src/libacm.c
@@ -38,7 +38,7 @@
 #include <netdb.h>
 #include <arpa/inet.h>
 
-extern pthread_mutex_t lock;
+static pthread_mutex_t acm_lock = PTHREAD_MUTEX_INITIALIZER;
 static int sock = -1;
 static short server_port = 6125;
 
@@ -212,7 +212,7 @@ static int acm_resolve(uint8_t *src, uint8_t *dest, uint8_t type,
 	struct acm_msg msg;
 	int ret, cnt = 0;
 
-	pthread_mutex_lock(&lock);
+	pthread_mutex_lock(&acm_lock);
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_RESOLVE;
@@ -246,7 +246,7 @@ static int acm_resolve(uint8_t *src, uint8_t *dest, uint8_t type,
 
 	ret = acm_format_resp(&msg, paths, count, print);
 out:
-	pthread_mutex_unlock(&lock);
+	pthread_mutex_unlock(&acm_lock);
 	return ret;
 }
 
@@ -275,7 +275,7 @@ int ib_acm_resolve_path(struct ibv_path_record *path, uint32_t flags)
 	struct acm_ep_addr_data *data;
 	int ret;
 
-	pthread_mutex_lock(&lock);
+	pthread_mutex_lock(&acm_lock);
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_RESOLVE;
@@ -299,7 +299,7 @@ int ib_acm_resolve_path(struct ibv_path_record *path, uint32_t flags)
 		*path = data->info.path;
 
 out:
-	pthread_mutex_unlock(&lock);
+	pthread_mutex_unlock(&acm_lock);
 	return ret;
 }
 
@@ -308,7 +308,7 @@ int ib_acm_query_perf(int index, uint64_t **counters, int *count)
 	struct acm_msg msg;
 	int ret, i;
 
-	pthread_mutex_lock(&lock);
+	pthread_mutex_lock(&acm_lock);
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_PERF_QUERY;
@@ -341,7 +341,7 @@ int ib_acm_query_perf(int index, uint64_t **counters, int *count)
 		(*counters)[i] = ntohll(msg.perf_data[i]);
 	ret = 0;
 out:
-	pthread_mutex_unlock(&lock);
+	pthread_mutex_unlock(&acm_lock);
 	return ret;
 }
 
@@ -353,7 +353,7 @@ int ib_acm_enum_ep(int index, struct acm_ep_config_data **data)
 	int cnt;
 	struct acm_ep_config_data *edata;
 
-	pthread_mutex_lock(&lock);
+	pthread_mutex_lock(&acm_lock);
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_EP_QUERY;
@@ -391,7 +391,7 @@ int ib_acm_enum_ep(int index, struct acm_ep_config_data **data)
 	*data = edata;
 	ret = 0;
 out:
-	pthread_mutex_unlock(&lock);
+	pthread_mutex_unlock(&acm_lock);
 	return ret;
 }
 
@@ -404,7 +404,7 @@ int ib_acm_query_perf_ep_addr(uint8_t *src, uint8_t type,
 	if (!src) 
 		return -1;
 
-	pthread_mutex_lock(&lock);
+	pthread_mutex_lock(&acm_lock);
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_PERF_QUERY;
@@ -444,7 +444,7 @@ int ib_acm_query_perf_ep_addr(uint8_t *src, uint8_t type,
 
 	ret = 0;
 out:
-	pthread_mutex_unlock(&lock);
+	pthread_mutex_unlock(&acm_lock);
 	return ret;
 }
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
