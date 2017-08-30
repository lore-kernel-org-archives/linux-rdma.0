From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] vmw_pvrdma: Explicitly check for IP_BASED_GIDS port flag
Date: Wed, 30 Aug 2017 16:34:01 -0700
Message-ID: <1504136041-3070-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Rely on the IP_BASED_GIDS flag to use the ibv_resolve_eth_l2_from_gid
function when creating the AH. Otherwise, fallback to the
set_mac_from_gid function to set the DMAC.

Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
Pull request:
https://github.com/linux-rdma/rdma-core/pull/205

 providers/vmw_pvrdma/verbs.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/providers/vmw_pvrdma/verbs.c b/providers/vmw_pvrdma/verbs.c
index 852aced..a32046b 100644
--- a/providers/vmw_pvrdma/verbs.c
+++ b/providers/vmw_pvrdma/verbs.c
@@ -166,7 +166,7 @@ static int is_ipv6_addr_v4mapped(const struct in6_addr *a)
 		 (a->s6_addr32[2] ^ htobe32(0x0000ffff))) == 0UL));
 }
 
-static void set_mac_from_gid(const union ibv_gid *gid,
+static int set_mac_from_gid(const union ibv_gid *gid,
 			     __u8 mac[6])
 {
 	if (is_link_local_gid(gid)) {
@@ -177,7 +177,11 @@ static void set_mac_from_gid(const union ibv_gid *gid,
 		memcpy(mac, gid->raw + 8, 3);
 		memcpy(mac + 3, gid->raw + 13, 3);
 		mac[0] ^= 2;
+
+		return 0;
 	}
+
+	return 1;
 }
 
 struct ibv_ah *pvrdma_create_ah(struct ibv_pd *pd,
@@ -218,15 +222,17 @@ struct ibv_ah *pvrdma_create_ah(struct ibv_pd *pd,
 				   attr->grh.flow_label;
 	memcpy(av->dgid, attr->grh.dgid.raw, 16);
 
-	if (ibv_resolve_eth_l2_from_gid(pd->context, attr,
-					av->dmac, &vlan_id)) {
-		free(ah);
-		return NULL;
+	if (port_attr.port_cap_flags & IBV_PORT_IP_BASED_GIDS) {
+		if (!ibv_resolve_eth_l2_from_gid(pd->context, attr,
+						 av->dmac, &vlan_id))
+			return &ah->ibv_ah;
 	} else {
-		set_mac_from_gid(&attr->grh.dgid, av->dmac);
+		if (!set_mac_from_gid(&attr->grh.dgid, av->dmac))
+			return &ah->ibv_ah;
 	}
 
-	return &ah->ibv_ah;
+	free(ah);
+	return NULL;
 }
 
 int pvrdma_destroy_ah(struct ibv_ah *ah)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
