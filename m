From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 07/16] ibacm: convert logging in acm_util.c to acm_log
Date: Thu, 27 Mar 2014 22:50:01 -0700
Message-ID: <1395985810-23822-8-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

ib_acme build defines ACME_PRINTS which overrides acm_log to printf

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am    |    2 +-
 src/acm.c      |    6 ++----
 src/acm_util.c |   21 +++++++++------------
 src/acm_util.h |   12 ++++++++++++
 4 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 539ef83..703030d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -8,7 +8,7 @@ svc_ibacm_SOURCES = src/acm.c
 util_ib_acme_SOURCES = src/acme.c linux/acme_linux.c src/libacm.c linux/libacm_linux.c \
 			src/parse.c src/acm_util.c
 svc_ibacm_CFLAGS = $(AM_CFLAGS)
-util_ib_acme_CFLAGS = $(AM_CFLAGS)
+util_ib_acme_CFLAGS = $(AM_CFLAGS) -DACME_PRINTS
 
 ibacmincludedir = $(includedir)/infiniband
 
diff --git a/src/acm.c b/src/acm.c
index 82f9431..5dc2684 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -47,6 +47,7 @@
 #include <dlist.h>
 #include <search.h>
 #include "acm_mad.h"
+#include "acm_util.h"
 
 #define src_out     data[0]
 
@@ -245,10 +246,7 @@ static uint8_t min_rate = IBV_RATE_10_GBPS;
 static enum acm_route_preload route_preload;
 static enum acm_addr_preload addr_preload;
 
-#define acm_log(level, format, ...) \
-	acm_write(level, "%s: "format, __func__, ## __VA_ARGS__)
-
-static void acm_write(int level, const char *format, ...)
+void acm_write(int level, const char *format, ...)
 {
 	va_list args;
 	struct timeval tv;
diff --git a/src/acm_util.c b/src/acm_util.c
index 922eceb..7a84ac7 100644
--- a/src/acm_util.c
+++ b/src/acm_util.c
@@ -52,7 +52,7 @@ int acm_if_is_ib(char *ifname)
 	snprintf(buf, sizeof buf, "//sys//class//net//%s//type", ifname);
 	f = fopen(buf, "r");
 	if (!f) {
-		printf("failed to open %s\n", buf);
+		acm_log(0, "failed to open %s\n", buf);
 		return 0;
 	}
 
@@ -60,6 +60,7 @@ int acm_if_is_ib(char *ifname)
 		type = strtol(buf, NULL, 0);
 		ret = (type == ARPHRD_INFINIBAND);
 	} else {
+		acm_log(0, "failed to read interface type\n");
 		ret = 0;
 	}
 
@@ -76,7 +77,7 @@ int acm_if_get_pkey(char *ifname, uint16_t *pkey)
 	snprintf(buf, sizeof buf, "//sys//class//net//%s//pkey", ifname);
 	f = fopen(buf, "r");
 	if (!f) {
-		printf("failed to open %s\n", buf);
+		acm_log(0, "failed to open %s\n", buf);
 		return -1;
 	}
 
@@ -84,7 +85,7 @@ int acm_if_get_pkey(char *ifname, uint16_t *pkey)
 		*pkey = strtol(buf, &end, 16);
 		ret = 0;
 	} else {
-		printf("failed to read pkey\n");
+		acm_log(0, "failed to read pkey\n");
 		ret = -1;
 	}
 
@@ -101,7 +102,7 @@ int acm_if_get_sgid(char *ifname, union ibv_gid *sgid)
 	snprintf(buf, sizeof buf, "//sys//class//net//%s//address", ifname);
 	f = fopen(buf, "r");
 	if (!f) {
-		printf("failed to open %s\n", buf);
+		acm_log(0, "failed to open %s\n", buf);
 		return -1;
 	}
 
@@ -112,7 +113,7 @@ int acm_if_get_sgid(char *ifname, union ibv_gid *sgid)
 		}
 		ret = 0;
 	} else {
-		printf("failed to read sgid\n");
+		acm_log(0, "failed to read sgid\n");
 		ret = -1;
 	}
 
@@ -146,7 +147,7 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 
 	ret = ioctl(s, SIOCGIFCONF, ifc);
 	if (ret < 0) {
-		printf("ioctl ifconf error %d\n", ret);
+		acm_log(0, "ioctl ifconf error %d\n", ret);
 		goto out2;
 	}
 
@@ -169,16 +170,12 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 			continue;
 
 		ret = acm_if_get_sgid(ifr[i].ifr_name, &sgid);
-		if (ret) {
-			printf("unable to get sgid\n");
+		if (ret)
 			continue;
-		}
 
 		ret = acm_if_get_pkey(ifr[i].ifr_name, &pkey);
-		if (ret) {
-			printf("unable to get pkey\n");
+		if (ret)
 			continue;
-		}
 
 		cb(ifr[i].ifr_name, &sgid, pkey, 0, NULL, 0, ip, ctx);
 	}
diff --git a/src/acm_util.h b/src/acm_util.h
index ea86133..4f111b6 100644
--- a/src/acm_util.h
+++ b/src/acm_util.h
@@ -32,6 +32,18 @@
 
 #include <infiniband/verbs.h>
 
+#ifdef ACME_PRINTS
+
+#define acm_log(level, format, ...) \
+	printf(format, ## __VA_ARGS__)
+
+#else /* !ACME_PRINTS */
+#define acm_log(level, format, ...) \
+	acm_write(level, "%s: "format, __func__, ## __VA_ARGS__)
+
+void acm_write(int level, const char *format, ...);
+#endif /* ACME_PRINTS */
+
 int acm_if_is_ib(char *ifname);
 int acm_if_get_pkey(char *ifname, uint16_t *pkey);
 int acm_if_get_sgid(char *ifname, union ibv_gid *sgid);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
