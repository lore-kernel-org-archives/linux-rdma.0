From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 3/22] [for 2.6.36] rdma/cm: include AF_IB in loopback and any address checks
Date: Tue, 23 Mar 2010 10:55:36 -0700
Message-ID: <93211619C35B4722BE2F2E632532CCB6@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2F3826558E79459EAD2A457A604221C1-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enhance checks for loopback and any address to support AF_IB
in addition to AF_INET and AF_INT6.  This will allow future
patches to use AF_IB when binding and resolving addresses.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9041a2b..6460fbf 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -46,6 +46,7 @@
 
 #include <rdma/rdma_cm.h>
 #include <rdma/rdma_cm_ib.h>
+#include <rdma/ib.h>
 #include <rdma/ib_cache.h>
 #include <rdma/ib_cm.h>
 #include <rdma/ib_sa.h>
@@ -616,26 +617,30 @@ EXPORT_SYMBOL(rdma_init_qp_attr);
 
 static inline int cma_zero_addr(struct sockaddr *addr)
 {
-	struct in6_addr *ip6;
-
-	if (addr->sa_family == AF_INET)
-		return ipv4_is_zeronet(
-			((struct sockaddr_in *)addr)->sin_addr.s_addr);
-	else {
-		ip6 = &((struct sockaddr_in6 *) addr)->sin6_addr;
-		return (ip6->s6_addr32[0] | ip6->s6_addr32[1] |
-			ip6->s6_addr32[2] | ip6->s6_addr32[3]) == 0;
+	switch (addr->sa_family) {
+	case AF_INET:
+		return ipv4_is_zeronet(((struct sockaddr_in *)addr)->sin_addr.s_addr);
+	case AF_INET6:
+		return ipv6_addr_any(&((struct sockaddr_in6 *) addr)->sin6_addr);
+	case AF_IB:
+		return ib_addr_any(&((struct sockaddr_ib *) addr)->sib_addr);
+	default:
+		return 0;
 	}
 }
 
 static inline int cma_loopback_addr(struct sockaddr *addr)
 {
-	if (addr->sa_family == AF_INET)
-		return ipv4_is_loopback(
-			((struct sockaddr_in *) addr)->sin_addr.s_addr);
-	else
-		return ipv6_addr_loopback(
-			&((struct sockaddr_in6 *) addr)->sin6_addr);
+	switch (addr->sa_family) {
+	case AF_INET:
+		return ipv4_is_loopback(((struct sockaddr_in *) addr)->sin_addr.s_addr);
+	case AF_INET6:
+		return ipv6_addr_loopback(&((struct sockaddr_in6 *) addr)->sin6_addr);
+	case AF_IB:
+		return ib_addr_loopback(&((struct sockaddr_ib *) addr)->sib_addr);
+	default:
+		return 0;
+	}
 }
 
 static inline int cma_any_addr(struct sockaddr *addr)



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
