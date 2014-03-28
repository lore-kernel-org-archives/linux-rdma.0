From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 04/16] ibacm: move sysfs helper functions to acm_util 'module'
Date: Thu, 27 Mar 2014 22:49:58 -0700
Message-ID: <1395985810-23822-5-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This is in preparation for these functions to be included ib both ibacm and
ib_acme build.

Also rename to more global appropriate name acm_if_*

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am        |    7 ++-
 linux/acme_linux.c |   87 +---------------------------------------
 src/acm_util.c     |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/acm_util.h     |   39 ++++++++++++++++++
 src/acme.c         |    1 +
 5 files changed, 159 insertions(+), 87 deletions(-)
 create mode 100644 src/acm_util.c
 create mode 100644 src/acm_util.h

diff --git a/Makefile.am b/Makefile.am
index 57021e0..539ef83 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,11 +1,12 @@
-AM_CPPFLAGS = -I$(srcdir)/include -I$(srcdir)/linux
+AM_CPPFLAGS = -I$(srcdir)/include -I$(srcdir)/linux -I$(srcdir)/src
 
 AM_CFLAGS = -g -Wall -D_GNU_SOURCE -DSYSCONFDIR=\"$(sysconfdir)\" -DBINDIR=\"$(bindir)\" -DRDMADIR=\"@rdmadir@\"
 
 bin_PROGRAMS = util/ib_acme
 sbin_PROGRAMS = svc/ibacm
 svc_ibacm_SOURCES = src/acm.c
-util_ib_acme_SOURCES = src/acme.c linux/acme_linux.c src/libacm.c linux/libacm_linux.c src/parse.c
+util_ib_acme_SOURCES = src/acme.c linux/acme_linux.c src/libacm.c linux/libacm_linux.c \
+			src/parse.c src/acm_util.c
 svc_ibacm_CFLAGS = $(AM_CFLAGS)
 util_ib_acme_CFLAGS = $(AM_CFLAGS)
 
@@ -18,7 +19,7 @@ man_MANS = \
 	man/ibacm.1 \
 	man/ibacm.7
 
-EXTRA_DIST = src/acm_mad.h src/libacm.h ibacm.init.in \
+EXTRA_DIST = src/acm_util.h src/acm_mad.h src/libacm.h ibacm.init.in \
 	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) ibacm_hosts.data
 
 install-exec-hook:
diff --git a/linux/acme_linux.c b/linux/acme_linux.c
index 0bd1f75..b246a9c 100644
--- a/linux/acme_linux.c
+++ b/linux/acme_linux.c
@@ -34,99 +34,18 @@
 #include <arpa/inet.h>
 #include <sys/ioctl.h>
 #include <net/if.h>
-#include <net/if_arp.h>
 #include <netinet/in.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <errno.h>
 
 #include <infiniband/verbs.h>
+#include "acm_util.h"
 
 extern struct ibv_context **verbs;
 extern int dev_cnt;
 extern int verbose;
 
-
-static int
-get_pkey(char *ifname, uint16_t *pkey)
-{
-	char buf[128], *end;
-	FILE *f;
-	int ret;
-
-	snprintf(buf, sizeof buf, "//sys//class//net//%s//pkey", ifname);
-	f = fopen(buf, "r");
-	if (!f) {
-		printf("failed to open %s\n", buf);
-		return -1;
-	}
-
-	if (fgets(buf, sizeof buf, f)) {
-		*pkey = strtol(buf, &end, 16);
-		ret = 0;
-	} else {
-		printf("failed to read pkey\n");
-		ret = -1;
-	}	
-
-	fclose(f);
-	return ret;
-}
-
-static int
-get_sgid(char *ifname, union ibv_gid *sgid)
-{
-	char buf[128], *end;
-	FILE *f;
-	int i, p, ret;
-
-	snprintf(buf, sizeof buf, "//sys//class//net//%s//address", ifname);
-	f = fopen(buf, "r");
-	if (!f) {
-		printf("failed to open %s\n", buf);
-		return -1;
-	}
-
-	if (fgets(buf, sizeof buf, f)) {
-		for (i = 0, p = 12; i < 16; i++, p += 3) {
-			buf[p + 2] = '\0';
-			sgid->raw[i] = (uint8_t) strtol(buf + p, &end, 16);
-		}
- 		ret = 0;
-	} else {
-		printf("failed to read sgid\n");
-		ret = -1;
-	}
-
-	fclose(f);
-	return ret;
-}
-
-static int acm_if_is_ib(char *ifname)
-{
-	unsigned type;
-	char buf[128];
-	FILE *f;
-	int ret;
-
-	snprintf(buf, sizeof buf, "//sys//class//net//%s//type", ifname);
-	f = fopen(buf, "r");
-	if (!f) {
-		printf("failed to open %s\n", buf);
-		return 0;
-	}
-
-	if (fgets(buf, sizeof buf, f)) {
-		type = strtol(buf, NULL, 0);
-		ret = (type == ARPHRD_INFINIBAND);
-	} else {
-		ret = 0;
-	}
-
-	fclose(f);
-	return ret;
-}
-
 static int
 get_devaddr(char *ifname, int *dev_index, uint8_t *port, uint16_t *pkey)
 {
@@ -135,13 +54,13 @@ get_devaddr(char *ifname, int *dev_index, uint8_t *port, uint16_t *pkey)
 	union ibv_gid sgid, gid;
 	int ret, i;
 
-	ret = get_sgid(ifname, &sgid);
+	ret = acm_if_get_sgid(ifname, &sgid);
 	if (ret) {
 		printf("unable to get sgid\n");
 		return ret;
 	}
 
-	ret = get_pkey(ifname, pkey);
+	ret = acm_if_get_pkey(ifname, pkey);
 	if (ret) {
 		printf("unable to get pkey\n");
 		return ret;
diff --git a/src/acm_util.c b/src/acm_util.c
new file mode 100644
index 0000000..519735a
--- /dev/null
+++ b/src/acm_util.c
@@ -0,0 +1,112 @@
+/*
+ * Copyright (c) 2014 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under the OpenFabrics.org BSD license
+ * below:
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
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <net/if_arp.h>
+
+#include "acm_util.h"
+
+int acm_if_is_ib(char *ifname)
+{
+	unsigned type;
+	char buf[128];
+	FILE *f;
+	int ret;
+
+	snprintf(buf, sizeof buf, "//sys//class//net//%s//type", ifname);
+	f = fopen(buf, "r");
+	if (!f) {
+		printf("failed to open %s\n", buf);
+		return 0;
+	}
+
+	if (fgets(buf, sizeof buf, f)) {
+		type = strtol(buf, NULL, 0);
+		ret = (type == ARPHRD_INFINIBAND);
+	} else {
+		ret = 0;
+	}
+
+	fclose(f);
+	return ret;
+}
+
+int acm_if_get_pkey(char *ifname, uint16_t *pkey)
+{
+	char buf[128], *end;
+	FILE *f;
+	int ret;
+
+	snprintf(buf, sizeof buf, "//sys//class//net//%s//pkey", ifname);
+	f = fopen(buf, "r");
+	if (!f) {
+		printf("failed to open %s\n", buf);
+		return -1;
+	}
+
+	if (fgets(buf, sizeof buf, f)) {
+		*pkey = strtol(buf, &end, 16);
+		ret = 0;
+	} else {
+		printf("failed to read pkey\n");
+		ret = -1;
+	}
+
+	fclose(f);
+	return ret;
+}
+
+int acm_if_get_sgid(char *ifname, union ibv_gid *sgid)
+{
+	char buf[128], *end;
+	FILE *f;
+	int i, p, ret;
+
+	snprintf(buf, sizeof buf, "//sys//class//net//%s//address", ifname);
+	f = fopen(buf, "r");
+	if (!f) {
+		printf("failed to open %s\n", buf);
+		return -1;
+	}
+
+	if (fgets(buf, sizeof buf, f)) {
+		for (i = 0, p = 12; i < 16; i++, p += 3) {
+			buf[p + 2] = '\0';
+			sgid->raw[i] = (uint8_t) strtol(buf + p, &end, 16);
+		}
+		ret = 0;
+	} else {
+		printf("failed to read sgid\n");
+		ret = -1;
+	}
+
+	fclose(f);
+	return ret;
+}
diff --git a/src/acm_util.h b/src/acm_util.h
new file mode 100644
index 0000000..94aac9d
--- /dev/null
+++ b/src/acm_util.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (c) 2014 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under the OpenFabrics.org BSD license
+ * below:
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
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#if !defined(ACM_IF_H)
+#define ACM_IF_H
+
+#include <infiniband/verbs.h>
+
+int acm_if_is_ib(char *ifname);
+int acm_if_get_pkey(char *ifname, uint16_t *pkey);
+int acm_if_get_sgid(char *ifname, union ibv_gid *sgid);
+
+#endif /* ACM_IF_H */
diff --git a/src/acme.c b/src/acme.c
index b122e58..fbe9dbc 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -43,6 +43,7 @@
 #include <infiniband/verbs.h>
 #include <infiniband/acm.h>
 #include "libacm.h"
+#include "acm_util.h"
 
 static char *dest_dir = ACM_CONF_DIR;
 static char *addr_file = ACM_ADDR_FILE;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
