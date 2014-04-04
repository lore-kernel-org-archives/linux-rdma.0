From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 06/14] ibacm: move acm_if_iter_sys to acm_util.c
Date: Thu,  3 Apr 2014 20:51:46 -0400
Message-ID: <1396572714-16498-7-git-send-email-ira.weiny@intel.com>
References: <1396572714-16498-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396572714-16498-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 linux/acme_linux.c |   80 ---------------------------------------------------
 src/acm_util.c     |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 80 deletions(-)

diff --git a/linux/acme_linux.c b/linux/acme_linux.c
index 187507d..33fafd2 100644
--- a/linux/acme_linux.c
+++ b/linux/acme_linux.c
@@ -30,14 +30,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <unistd.h>
-#include <arpa/inet.h>
-#include <sys/ioctl.h>
-#include <net/if.h>
-#include <netinet/in.h>
-#include <sys/socket.h>
-#include <sys/types.h>
-#include <errno.h>
 
 #include <infiniband/verbs.h>
 #include "acm_util.h"
@@ -101,75 +93,3 @@ int gen_addr_ip(FILE *f)
 {
 	return acm_if_iter_sys(iter_cb, (void *)f);
 }
-
-int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
-{
-	struct ifconf *ifc;
-	struct ifreq *ifr;
-	char ip[INET6_ADDRSTRLEN];
-	int s, ret, i, len;
-	uint16_t pkey;
-	union ibv_gid sgid;
-
-	s = socket(AF_INET6, SOCK_DGRAM, 0);
-	if (!s)
-		return -1;
-
-	len = sizeof(*ifc) + sizeof(*ifr) * 64;
-	ifc = malloc(len);
-	if (!ifc) {
-		ret = -1;
-		goto out1;
-	}
-
-	memset(ifc, 0, len);
-	ifc->ifc_len = len;
-	ifc->ifc_req = (struct ifreq *) (ifc + 1);
-
-	ret = ioctl(s, SIOCGIFCONF, ifc);
-	if (ret < 0) {
-		printf("ioctl ifconf error %d\n", ret);
-		goto out2;
-	}
-
-	ifr = ifc->ifc_req;
-	for (i = 0; i < ifc->ifc_len / sizeof(struct ifreq); i++) {
-		switch (ifr[i].ifr_addr.sa_family) {
-		case AF_INET:
-			inet_ntop(ifr[i].ifr_addr.sa_family,
-				&((struct sockaddr_in *) &ifr[i].ifr_addr)->sin_addr, ip, sizeof ip);
-			break;
-		case AF_INET6:
-			inet_ntop(ifr[i].ifr_addr.sa_family,
-				&((struct sockaddr_in6 *) &ifr[i].ifr_addr)->sin6_addr, ip, sizeof ip);
-			break;
-		default:
-			continue;
-		}
-
-		if (!acm_if_is_ib(ifr[i].ifr_name))
-			continue;
-
-		ret = acm_if_get_sgid(ifr[i].ifr_name, &sgid);
-		if (ret) {
-			printf("unable to get sgid\n");
-			continue;
-		}
-
-		ret = acm_if_get_pkey(ifr[i].ifr_name, &pkey);
-		if (ret) {
-			printf("unable to get pkey\n");
-			continue;
-		}
-
-		cb(ifr[i].ifr_name, &sgid, pkey, 0, NULL, 0, ip, ctx);
-	}
-	ret = 0;
-
-out2:
-	free(ifc);
-out1:
-	close(s);
-	return ret;
-
-}
diff --git a/src/acm_util.c b/src/acm_util.c
index 519735a..922eceb 100644
--- a/src/acm_util.c
+++ b/src/acm_util.c
@@ -30,6 +30,15 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <net/if_arp.h>
+#include <string.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <sys/ioctl.h>
+#include <net/if.h>
+#include <netinet/in.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <errno.h>
 
 #include "acm_util.h"
 
@@ -110,3 +119,75 @@ int acm_if_get_sgid(char *ifname, union ibv_gid *sgid)
 	fclose(f);
 	return ret;
 }
+
+int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
+{
+	struct ifconf *ifc;
+	struct ifreq *ifr;
+	char ip[INET6_ADDRSTRLEN];
+	int s, ret, i, len;
+	uint16_t pkey;
+	union ibv_gid sgid;
+
+	s = socket(AF_INET6, SOCK_DGRAM, 0);
+	if (!s)
+		return -1;
+
+	len = sizeof(*ifc) + sizeof(*ifr) * 64;
+	ifc = malloc(len);
+	if (!ifc) {
+		ret = -1;
+		goto out1;
+	}
+
+	memset(ifc, 0, len);
+	ifc->ifc_len = len;
+	ifc->ifc_req = (struct ifreq *) (ifc + 1);
+
+	ret = ioctl(s, SIOCGIFCONF, ifc);
+	if (ret < 0) {
+		printf("ioctl ifconf error %d\n", ret);
+		goto out2;
+	}
+
+	ifr = ifc->ifc_req;
+	for (i = 0; i < ifc->ifc_len / sizeof(struct ifreq); i++) {
+		switch (ifr[i].ifr_addr.sa_family) {
+		case AF_INET:
+			inet_ntop(ifr[i].ifr_addr.sa_family,
+				&((struct sockaddr_in *) &ifr[i].ifr_addr)->sin_addr, ip, sizeof ip);
+			break;
+		case AF_INET6:
+			inet_ntop(ifr[i].ifr_addr.sa_family,
+				&((struct sockaddr_in6 *) &ifr[i].ifr_addr)->sin6_addr, ip, sizeof ip);
+			break;
+		default:
+			continue;
+		}
+
+		if (!acm_if_is_ib(ifr[i].ifr_name))
+			continue;
+
+		ret = acm_if_get_sgid(ifr[i].ifr_name, &sgid);
+		if (ret) {
+			printf("unable to get sgid\n");
+			continue;
+		}
+
+		ret = acm_if_get_pkey(ifr[i].ifr_name, &pkey);
+		if (ret) {
+			printf("unable to get pkey\n");
+			continue;
+		}
+
+		cb(ifr[i].ifr_name, &sgid, pkey, 0, NULL, 0, ip, ctx);
+	}
+	ret = 0;
+
+out2:
+	free(ifc);
+out1:
+	close(s);
+	return ret;
+
+}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
