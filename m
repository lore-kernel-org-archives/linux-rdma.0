From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 03/14] ibacm: use sysfs (in acm_if_is_ib) rather than ioctl(... SIOCGIFHWADDR ...) to read interface type
Date: Thu,  3 Apr 2014 20:51:43 -0400
Message-ID: <1396572714-16498-4-git-send-email-ira.weiny@intel.com>
References: <1396572714-16498-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396572714-16498-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Getting an interface type from sysfs is easier than using an ioctl when an
interface name is readily available (as is the case with netlink.)

In preparation for netlink support create a function which uses sysfs and use
it instead of ioctls.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 linux/acme_linux.c |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/linux/acme_linux.c b/linux/acme_linux.c
index 201ff19..0bd1f75 100644
--- a/linux/acme_linux.c
+++ b/linux/acme_linux.c
@@ -38,6 +38,7 @@
 #include <netinet/in.h>
 #include <sys/socket.h>
 #include <sys/types.h>
+#include <errno.h>
 
 #include <infiniband/verbs.h>
 
@@ -101,6 +102,31 @@ get_sgid(char *ifname, union ibv_gid *sgid)
 	return ret;
 }
 
+static int acm_if_is_ib(char *ifname)
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
 static int
 get_devaddr(char *ifname, int *dev_index, uint8_t *port, uint16_t *pkey)
 {
@@ -189,13 +215,7 @@ int gen_addr_ip(FILE *f)
 			continue;
 		}
 
-		ret = ioctl(s, SIOCGIFHWADDR, &ifr[i]);
-		if (ret) {
-			printf("failed to get hw address %d\n", ret);
-			continue;
-		}
-
-		if (ifr[i].ifr_hwaddr.sa_family != ARPHRD_INFINIBAND)
+		if (!acm_if_is_ib(ifr[i].ifr_name))
 			continue;
 
 		ret = get_devaddr(ifr[i].ifr_name, &dev_index, &port, &pkey);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
