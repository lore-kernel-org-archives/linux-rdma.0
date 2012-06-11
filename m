From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 02/29] IB/mlx4: Mask out high order bit of port_num in mlx4_ib_create_ah
Date: Mon, 11 Jun 2012 13:45:43 +0300
Message-ID: <1339411570-4689-3-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The high-order bit of the port_num field is used for the forced-loopback flag.

Note: we just noticed that we made illegal use here of the MSB
of the port_num field in the ib core ah structure.  We will correct
this error in the V1 patch set.

We did not want to delay the submission due to this.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index a251bec..d1938b6 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -140,7 +140,9 @@ struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 	if (!ah)
 		return ERR_PTR(-ENOMEM);
 
-	if (rdma_port_get_link_layer(pd->device, ah_attr->port_num) == IB_LINK_LAYER_ETHERNET) {
+	/* high order bit of port_num used for forced-loopback flag */
+	if (rdma_port_get_link_layer(pd->device, (ah_attr->port_num) & 0x7f)
+	    == IB_LINK_LAYER_ETHERNET) {
 		if (!(ah_attr->ah_flags & IB_AH_GRH)) {
 			ret = ERR_PTR(-EINVAL);
 		} else {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
