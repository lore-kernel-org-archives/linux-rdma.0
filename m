From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/26] rdma/cm: update port reservation to support AF_IB
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <A8D928CF88DC45318A0DCC56F19B0773@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Update the port reservation code path to support AF_IB addresses.
Define a new port space, RDMA_PS_IB, for AF_IB addressing.

The AF_IB port space is a 64-bit service id (SID), which the
user can control through the use of a mask.  The rdma_cm
will assign values to the unmasked portions of the SID
when an rdma_cm_id is bound to an AF_IB address.

Because the IB spec divides the SID range into several regions,
a SID/mask combination may fall into one of the existing
port space ranges as defined by the RDMA CM IP Annex.  We need
to coordinate port reservation between RDMA_PS_IB and 
RDMA_PS_TCP/RDMA_PS_UDP.
 
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |   69 +++++++++++++++++++++++++++++++++++++----
 include/rdma/rdma_cm.h        |    6 ++++
 2 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ac57155..1328a8e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -657,18 +657,29 @@ static int cma_addr_cmp(struct sockaddr *src, struct sockaddr *dst)
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
+		return htons((u16) (be64_to_cpu(((struct sockaddr_ib *) addr)->sib_sid) &
+			     be64_to_cpu(((struct sockaddr_ib *) addr)->sib_sid_mask)));
+	default:
+		return 0;
+	}
 }
 
 static inline int cma_any_port(struct sockaddr *addr)
@@ -1945,10 +1956,29 @@ EXPORT_SYMBOL(rdma_resolve_addr);
 static void cma_bind_port(struct rdma_bind_list *bind_list,
 			  struct rdma_id_private *id_priv)
 {
-	struct sockaddr_in *sin;
+	struct sockaddr *addr;
+	struct sockaddr_ib *sib;
+	u64 sid, mask;
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
+		sib = (struct sockaddr_ib *) addr;
+		sid = be64_to_cpu(sib->sib_sid);
+		mask = be64_to_cpu(sib->sib_sid_mask);
+		sib->sib_sid = cpu_to_be64((sid & mask) | (u64) ntohs(port));
+		sib->sib_sid_mask = cpu_to_be64(~0ULL);
+		break;
+	}
 	id_priv->bind_list = bind_list;
 	hlist_add_head(&id_priv->node, &bind_list->owners);
 }
@@ -2068,6 +2098,26 @@ static int cma_use_port(struct idr *ps, struct rdma_id_private *id_priv)
 	return 0;
 }
 
+static struct idr *cma_select_ib_ps(struct rdma_id_private *id_priv)
+{
+	struct sockaddr_ib *sib;
+	u64 mask, sid;
+
+	sib = (struct sockaddr_ib *) &id_priv->id.route.addr.src_addr;
+	mask = be64_to_cpu(sib->sib_sid_mask);
+	sid = be64_to_cpu(sib->sib_sid);
+
+	if (mask != RDMA_IB_IP_PS_MASK && mask != ~0ULL)
+		return NULL;
+
+	if ((sid & RDMA_IB_IP_PS_MASK) == RDMA_IB_IP_PS_TCP)
+		return &tcp_ps;
+	else if ((sid & RDMA_IB_IP_PS_MASK) == RDMA_IB_IP_PS_UDP)
+		return &udp_ps;
+	else
+		return NULL;
+}
+
 static int cma_get_port(struct rdma_id_private *id_priv)
 {
 	struct idr *ps;
@@ -2086,6 +2136,11 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 	case RDMA_PS_IPOIB:
 		ps = &ipoib_ps;
 		break;
+	case RDMA_PS_IB:
+		ps = cma_select_ib_ps(id_priv);
+		if (!ps)
+			return -EINVAL;
+		break;
 	default:
 		return -EPROTONOSUPPORT;
 	}
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index c6b2962..8c27b6e 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -65,11 +65,17 @@ enum rdma_cm_event_type {
 enum rdma_port_space {
 	RDMA_PS_SDP   = 0x0001,
 	RDMA_PS_IPOIB = 0x0002,
+	RDMA_PS_IB    = 0x0003,
 	RDMA_PS_TCP   = 0x0106,
 	RDMA_PS_UDP   = 0x0111,
 	RDMA_PS_SCTP  = 0x0183
 };
 
+#define RDMA_IB_IP_PS_MASK   0xFFFFFFFFFFFF0000ULL
+#define RDMA_IB_IP_PORT_MASK 0x000000000000FFFFULL
+#define RDMA_IB_IP_PS_TCP    0x0000000001060000ULL
+#define RDMA_IB_IP_PS_UDP    0x0000000001110000ULL
+
 struct rdma_addr {
 	struct sockaddr_storage src_addr;
 	struct sockaddr_storage dst_addr;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
