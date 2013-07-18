From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 FIXES for-3.11 2/4] IB/mlx4: Use default pkey when creating tunnel QPs
Date: Thu, 18 Jul 2013 14:02:30 +0300
Message-ID: <1374145352-27816-3-git-send-email-ogerlitz@mellanox.com>
References: <1374145352-27816-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374145352-27816-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

When creating tunnel QPs for special QP tunneling, look for the default pkey
in the slave's virtual pkey table. If it is present, use the real pkey index
where the default pkey is located.

If the default pkey is not found in the pkey table, use the real pkey index
which is stored at index 0 in the slave's virtual pkey table (this is the
current behavior).

This change is required to support cloud computing, where the paravirtualized
index of the default pkey is moved to index 1 or higher. The pkey at
paravirtualized index 0 is used for the default IPoIB interface created by the VF.

Its possible for the pkey value at paravirtualized index 0 to be invalid (zero) at
VF probe time (pkey index 0 is mapped to real pkey index 127, which contains pkey = 0).

At some point after the VF probe, the cloud computing interface at the Hypervisor
maps virtual index 0 for the VF to the pkey index containing the pkey that IPoIB
will use in its operation.  However, when the tunnel QP is created, the pkey at
the slave's virtual index 0 is still mapped to the invalid pkey index, so tunnel
QP creation fails.

This commit causes the Hypervisor to search for the default pkey in the slave's
pkey table -- and this pkey is present in the table (at index > 0) at tunnel QP
creation time, so that the tunnel QP creation will succeed.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 4d599ce..f2a3f48 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1511,8 +1511,14 @@ static int create_pv_sqp(struct mlx4_ib_demux_pv_ctx *ctx,
 
 	memset(&attr, 0, sizeof attr);
 	attr.qp_state = IB_QPS_INIT;
-	attr.pkey_index =
-		to_mdev(ctx->ib_dev)->pkeys.virt2phys_pkey[ctx->slave][ctx->port - 1][0];
+	ret = 0;
+	if (create_tun)
+		ret = find_slave_port_pkey_ix(to_mdev(ctx->ib_dev), ctx->slave,
+					      ctx->port, IB_DEFAULT_PKEY_FULL,
+					      &attr.pkey_index);
+	if (ret || !create_tun)
+		attr.pkey_index =
+			to_mdev(ctx->ib_dev)->pkeys.virt2phys_pkey[ctx->slave][ctx->port - 1][0];
 	attr.qkey = IB_QP1_QKEY;
 	attr.port_num = ctx->port;
 	ret = ib_modify_qp(tun_qp->qp, &attr, qp_attr_mask_INIT);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
