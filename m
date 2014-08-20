From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 V4 2/2] Add RoCE IP based addressing support for UD QPs
Date: Wed, 20 Aug 2014 09:52:09 +0300
Message-ID: <1408517529-20631-3-git-send-email-matanb@mellanox.com>
References: <1408517529-20631-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408517529-20631-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to implement IP based addressing for UD QPs, we need a way to
resolve the addresses internally.
When the provider detects an Ethernet link layer with IP based gids,
it calls a helper function in libibverbs in order to resolve the
Ethernet L2 params.


Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/verbs.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index 5c069ea..831e934 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -856,11 +856,29 @@ struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 		memcpy(ah->av.dgid, attr->grh.dgid.raw, 16);
 	}
 
-	if (port_attr.link_layer == IBV_LINK_LAYER_ETHERNET)
-		if (mlx4_resolve_grh_to_l2(pd, ah, attr)) {
-			free(ah);
-			return NULL;
+	if (port_attr.link_layer == IBV_LINK_LAYER_ETHERNET) {
+		if (port_attr.port_cap_flags & IBV_PORT_IP_BASED_GIDS) {
+			uint16_t vid;
+
+			if (ibv_resolve_eth_l2_from_gid(pd->context, attr,
+							ah->mac, &vid)) {
+				free(ah);
+				return NULL;
+			}
+
+			if (vid <= 0xfff) {
+				ah->av.port_pd |= htonl(1 << 29);
+				ah->vlan = vid |
+					((attr->sl & 7) << 13);
+			}
+
+		} else {
+			if (mlx4_resolve_grh_to_l2(pd, ah, attr)) {
+				free(ah);
+				return NULL;
+			}
 		}
+	}
 
 	return &ah->ibv_ah;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
