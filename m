From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1] RDMA/cma: Fix multicast joins of the IPoIB port space to be consistent
Date: Thu, 30 Aug 2012 12:09:55 +0300
Message-ID: <1346317795-12622-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

CMA multicast joins done under the ipoib port state must be carried
out using the same component mask used by ipoib. Otherwise, its possible
for the CMA to create a group to which a join made by ipoib will fail,
or vise-versa. So far this wasn't the case, since some of the component
mask fields set by ipoib weren't set by the CMA, fix that.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

changes from V0:
 - removed setting of the multicast record fields, since they are kept
   in the ib sa client data base, only deal with the component mask fields.


 drivers/infiniband/core/cma.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7172559..af3565c 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3056,9 +3056,12 @@ static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 		    IB_SA_MCMEMBER_REC_FLOW_LABEL |
 		    IB_SA_MCMEMBER_REC_TRAFFIC_CLASS;
 
-	if (id_priv->id.ps == RDMA_PS_IPOIB)
+	if (id_priv->id.ps == RDMA_PS_IPOIB)
 		comp_mask |= IB_SA_MCMEMBER_REC_RATE |
-			     IB_SA_MCMEMBER_REC_RATE_SELECTOR;
+			     IB_SA_MCMEMBER_REC_RATE_SELECTOR |
+			     IB_SA_MCMEMBER_REC_MTU_SELECTOR |
+			     IB_SA_MCMEMBER_REC_MTU |
+			     IB_SA_MCMEMBER_REC_HOP_LIMIT;
 
 	mc->multicast.ib = ib_sa_join_multicast(&sa_client, id_priv->id.device,
 						id_priv->id.port_num, &rec,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
