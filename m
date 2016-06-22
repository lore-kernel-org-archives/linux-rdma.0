From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/11] IB/core: Fix RoCE v1 multicast join logic issue
Date: Wed, 22 Jun 2016 17:27:23 +0300
Message-ID: <1466605652-24798-3-git-send-email-leonro@mellanox.com>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466605652-24798-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

During multicast join of RoCEv1, IGMP join state and max hop limit
were updated incorrectly. IGMP join should be sent and marked as
joined only on RoCEv2 after a successful join. Max hops should be
updated to the hop limit on RoCEv2 regardless of the join state.

Fixes: bee3c3c91865 ('IB/cma: Join and leave multicast groups...')
Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f0c91ba..dcde870 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3878,12 +3878,12 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	gid_type = id_priv->cma_dev->default_gid_type[id_priv->id.port_num -
 		   rdma_start_port(id_priv->cma_dev->device)];
 	if (addr->sa_family == AF_INET) {
-		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
+		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) {
+			mc->multicast.ib->rec.hop_limit = IPV6_DEFAULT_HOPLIMIT;
 			err = cma_igmp_send(ndev, &mc->multicast.ib->rec.mgid,
 					    true);
-		if (!err) {
-			mc->igmp_joined = true;
-			mc->multicast.ib->rec.hop_limit = IPV6_DEFAULT_HOPLIMIT;
+			if (!err)
+				mc->igmp_joined = true;
 		}
 	} else {
 		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
