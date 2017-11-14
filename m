From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 03/31] IB/core: Depend on IPv6 stack to resolve link local address
Date: Tue, 14 Nov 2017 14:51:50 +0200
Message-ID: <20171114125218.20477-4-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently ib_resolve_eth_dmac() bypasses IPv6 stack for resolving link
local destination mac address and translates the IPv6 link local GID
to MAC address, which is not always correct.
Static link local neighbour entry can be setup using
ip -6 neigh add <link_local_addr> lladdr <mac_addr> dev eth0
Current code bypasses such administratively set entries and IPV6 stack.

IPv6 RFC 4861 defines neighbour discovery protocol and is already
implemented by the kernel.

Now that rdma_addr_find_l2_eth_by_grh() supports resolving link local
address to find destination mac address, lets make use of it.
This aligns it to how the rest of the IPv6 stack resolves link local
destination IPv6 address.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 54b56c4fcc38..75ebd74f8bbd 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -506,9 +506,20 @@ static int ib_resolve_unicast_gid_dmac(struct ib_device *device,
 		return ret;
 	}
 
+	/* If destination is link local and source GID is RoCEv1,
+	 * IP stack is not used.
+	 */
+	if (rdma_link_local_addr((struct in6_addr *)grh->dgid.raw) &&
+	    sgid_attr.gid_type == IB_GID_TYPE_ROCE) {
+		rdma_get_ll_mac((struct in6_addr *)grh->dgid.raw,
+				ah_attr->roce.dmac);
+		goto done;
+	}
+
 	ret = rdma_addr_find_l2_eth_by_grh(&sgid, &grh->dgid,
 					   ah_attr->roce.dmac,
 					   sgid_attr.ndev, &hop_limit);
+done:
 	dev_put(sgid_attr.ndev);
 
 	grh->hop_limit = hop_limit;
@@ -1280,11 +1291,6 @@ static int ib_resolve_eth_dmac(struct ib_device *device,
 
 	grh = rdma_ah_retrieve_grh(ah_attr);
 
-	if (rdma_link_local_addr((struct in6_addr *)grh->dgid.raw)) {
-		rdma_get_ll_mac((struct in6_addr *)grh->dgid.raw,
-				ah_attr->roce.dmac);
-		return 0;
-	}
 	if (rdma_is_multicast_addr((struct in6_addr *)ah_attr->grh.dgid.raw)) {
 		if (ipv6_addr_v4mapped((struct in6_addr *)ah_attr->grh.dgid.raw)) {
 			__be32 addr = 0;
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
