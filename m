From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next] IB/core: Do not resolve VLAN if already resolved
Date: Wed, 19 Nov 2014 11:28:18 +0200
Message-ID: <1416389298-7431-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ursula Braun <ursula.braun-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For RoCE, resolution of layer 2 address attributes forces no VLAN if link local
gids are used. This patch enables applications that want to choose VLAN ID for
link local based RoCE gids by setting IB_QP_VID in their QP attribute mask and
prevent the core to override this choice.

Cc: Ursula Braun <ursula.braun-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c2b89cc..f93eb8d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -879,7 +879,8 @@ int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 		if (rdma_link_local_addr((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw)) {
 			rdma_get_ll_mac((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw, qp_attr->ah_attr.dmac);
 			rdma_get_ll_mac((struct in6_addr *)sgid.raw, qp_attr->smac);
-			qp_attr->vlan_id = rdma_get_vlan_id(&sgid);
+			if (!(*qp_attr_mask & IB_QP_VID))
+				qp_attr->vlan_id = rdma_get_vlan_id(&sgid);
 		} else {
 			ret = rdma_addr_find_dmac_by_grh(&sgid, &qp_attr->ah_attr.grh.dgid,
 					qp_attr->ah_attr.dmac, &qp_attr->vlan_id);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
