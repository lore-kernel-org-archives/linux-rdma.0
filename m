From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 5/22 v2] [for 2.6.36] rdma/cm: update port reservation to support AF_IB
Date: Thu, 25 Mar 2010 12:05:33 -0700
Message-ID: <7451BD1514874F3E987E55040776EECC@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com> <012F7D9E5E97445E9100EF170212AEE7@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <012F7D9E5E97445E9100EF170212AEE7-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update the port reservation code path to support AF_IB addresses.
AF_IB is limited to the port spaces defined by the RDMA CM IP Annex
which are already supported by the rdma cm.

AF_IB is used with a sockaddr_ib structure, which exposes a 64-bit
service ID, rather than a 16-bit port number used by IP.  As a result,
port numbers must be converted between the two formats as defined by
the above annex.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
changes from v1:
SID calculation in cma_bind_port for AF_IB was incorrect.

 drivers/infiniband/core/cma.c |   38 +++++++++++++++++++++++++++++++-------
 1 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ac57155..57f1521 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -657,18 +657,28 @@ static int cma_addr_cmp(struct sockaddr *src, struct sockaddr *dst)
 	case AF_INET:
 		return ((struct sockaddr_in *) src)->sin_addr.s_addr !=
 		       ((struct sockaddr_in *) dst)->sin_addr.s_addr;
-	default:
+	case AF_INET6:
 		return ipv6_addr_cmp(&((struct sockaddr_in6 *) src)->sin6_addr,
 				     &((struct sockaddr_in6 *) dst)->sin6_addr);
+	default:
+		return ib_addr_cmp(&((struct sockaddr_ib *) src)->sib_addr,
+				   &((struct sockaddr_ib *) dst)->sib_addr);
 	}
 }
 
-static inline __be16 cma_port(struct sockaddr *addr)
+/* AF_IB must be using the RDMA CM IP Annex */
+static __be16 cma_port(struct sockaddr *addr)
 {
-	if (addr->sa_family == AF_INET)
+	switch (addr->sa_family) {
+	case AF_INET:
 		return ((struct sockaddr_in *) addr)->sin_port;
-	else
+	case AF_INET6:
 		return ((struct sockaddr_in6 *) addr)->sin6_port;
+	case AF_IB:
+		return htons((u16) be64_to_cpu(((struct sockaddr_ib *) addr)->sib_sid));
+	default:
+		return 0;
+	}
 }
 
 static inline int cma_any_port(struct sockaddr *addr)
@@ -1945,10 +1955,24 @@ EXPORT_SYMBOL(rdma_resolve_addr);
 static void cma_bind_port(struct rdma_bind_list *bind_list,
 			  struct rdma_id_private *id_priv)
 {
-	struct sockaddr_in *sin;
+	struct sockaddr *addr;
+	__be16 port;
 
-	sin = (struct sockaddr_in *) &id_priv->id.route.addr.src_addr;
-	sin->sin_port = htons(bind_list->port);
+	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
+	port = htons(bind_list->port);
+
+	switch (addr->sa_family) {
+	case AF_INET:
+		((struct sockaddr_in *) addr)->sin_port = port;
+		break;
+	case AF_INET6:
+		((struct sockaddr_in6 *) addr)->sin6_port = port;
+		break;
+	case AF_IB:
+		((struct sockaddr_ib *) addr)->sib_sid =
+			cpu_to_be64(((u64) id_priv->id.ps << 16) + ntohs(port));
+		break;
+	}
 	id_priv->bind_list = bind_list;
 	hlist_add_head(&id_priv->node, &bind_list->owners);
 }



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
