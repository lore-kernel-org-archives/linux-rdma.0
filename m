From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/3] IB/core: Set RoCEv2 MGID according to spec
Date: Mon, 12 Jun 2017 11:14:03 +0300
Message-ID: <20170612081404.17553-3-leon@kernel.org>
References: <20170612081404.17553-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612081404.17553-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RoCEv2 Annex states that for RoCEv2 over IPv4, the corresponding
IPv4 address is encoded into the GID according to the following rule:
GID= :ffff:<IPv4 address>

Remove the 0xff0e prefix for RoCEv2 packets with IPv4 and leave it
zeroed and change rdma_is_multicast_addr() to consider the new logic.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c   | 13 +++++++------
 drivers/infiniband/core/verbs.c | 10 ++++++----
 include/rdma/ib_addr.h          |  8 +++++++-
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 31bb82d8ecd7..303a8207513a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4022,7 +4022,8 @@ static void iboe_mcast_work_handler(struct work_struct *work)
 	kfree(mw);
 }

-static void cma_iboe_set_mgid(struct sockaddr *addr, union ib_gid *mgid)
+static void cma_iboe_set_mgid(struct sockaddr *addr, union ib_gid *mgid,
+			      enum ib_gid_type gid_type)
 {
 	struct sockaddr_in *sin = (struct sockaddr_in *)addr;
 	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)addr;
@@ -4032,8 +4033,8 @@ static void cma_iboe_set_mgid(struct sockaddr *addr, union ib_gid *mgid)
 	} else if (addr->sa_family == AF_INET6) {
 		memcpy(mgid, &sin6->sin6_addr, sizeof *mgid);
 	} else {
-		mgid->raw[0] = 0xff;
-		mgid->raw[1] = 0x0e;
+		mgid->raw[0] = (gid_type == IB_GID_TYPE_IB) ? 0xff : 0;
+		mgid->raw[1] = (gid_type == IB_GID_TYPE_IB) ? 0x0e : 0;
 		mgid->raw[2] = 0;
 		mgid->raw[3] = 0;
 		mgid->raw[4] = 0;
@@ -4074,7 +4075,9 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 		goto out1;
 	}

-	cma_iboe_set_mgid(addr, &mc->multicast.ib->rec.mgid);
+	gid_type = id_priv->cma_dev->default_gid_type[id_priv->id.port_num -
+		   rdma_start_port(id_priv->cma_dev->device)];
+	cma_iboe_set_mgid(addr, &mc->multicast.ib->rec.mgid, gid_type);

 	mc->multicast.ib->rec.pkey = cpu_to_be16(0xffff);
 	if (id_priv->id.ps == RDMA_PS_UDP)
@@ -4090,8 +4093,6 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	mc->multicast.ib->rec.hop_limit = 1;
 	mc->multicast.ib->rec.mtu = iboe_get_mtu(ndev->mtu);

-	gid_type = id_priv->cma_dev->default_gid_type[id_priv->id.port_num -
-		   rdma_start_port(id_priv->cma_dev->device)];
 	if (addr->sa_family == AF_INET) {
 		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) {
 			mc->multicast.ib->rec.hop_limit = IPV6_DEFAULT_HOPLIMIT;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 38f6bec08d56..0e8e6d1b5b5b 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1563,8 +1563,9 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)

 	if (!qp->device->attach_mcast)
 		return -ENOSYS;
-	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD ||
-	    !is_valid_mcast_lid(qp, lid))
+
+	if (!rdma_is_multicast_addr((struct in6_addr *)gid->raw) ||
+	    qp->qp_type != IB_QPT_UD || !is_valid_mcast_lid(qp, lid))
 		return -EINVAL;

 	ret = qp->device->attach_mcast(qp, gid, lid);
@@ -1580,8 +1581,9 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)

 	if (!qp->device->detach_mcast)
 		return -ENOSYS;
-	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD ||
-	    !is_valid_mcast_lid(qp, lid))
+
+	if (!rdma_is_multicast_addr((struct in6_addr *)gid->raw) ||
+	    qp->qp_type != IB_QPT_UD || !is_valid_mcast_lid(qp, lid))
 		return -EINVAL;

 	ret = qp->device->detach_mcast(qp, gid, lid);
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 4b34c51f859e..503a02f7c3da 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -302,7 +302,13 @@ static inline void rdma_get_ll_mac(struct in6_addr *addr, u8 *mac)

 static inline int rdma_is_multicast_addr(struct in6_addr *addr)
 {
-	return addr->s6_addr[0] == 0xff;
+	u32 ipv4_addr;
+
+	if (addr->s6_addr[0] == 0xff)
+		return 1;
+
+	memcpy(&ipv4_addr, addr->s6_addr + 12, 4);
+	return (ipv6_addr_v4mapped(addr) && ipv4_is_multicast(ipv4_addr));
 }

 static inline void rdma_get_mcast_mac(struct in6_addr *addr, u8 *mac)
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
