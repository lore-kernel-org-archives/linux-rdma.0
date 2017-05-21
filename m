From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc] IB/mlx4: Fix MAD tunneling when SRIOV is enabled
Date: Sun, 21 May 2017 19:11:13 +0300
Message-ID: <20170521161113.20772-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

The cited patch added a type field to structures ib_ah and rdma_ah_attr.

Function mlx4_ib_query_ah() builds an rdma_ah_attr structure from the
data in an mlx4_ib_ah structure (which contains both an ib_ah structure
and an address vector).

For mlx4_ib_query_ah() to work properly, the type field in the contained
ib_ah structure must be set correctly.

In the outgoing MAD tunneling flow, procedure mlx4_ib_multiplex_mad()
paravirtualizes a MAD received from a slave and sends the processed
mad out over the wire. During this processing, it populates an
mlx4_ib_ah structure and calls mlx4_ib_query_ah().

The cited commit overlooked setting the type field in the contained
ib_ah structure before invoking mlx4_ib_query_ah(). As a result, the
type field remained uninitialized, and the rdma_ah_attr structure was
incorrectly built. This resulted in improperly built MADs being sent out
over the wire.

This patch properly initializes the type field in the contained ib_ah
structure before calling mlx4_ib_query_ah(). The rdma_ah_attr structure
is then generated correctly.

Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index b4694717f6f3..21d31cb1325f 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1578,6 +1578,7 @@ static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
 	if (port < 0)
 		return;
 	ah.av.ib.port_pd = cpu_to_be32(port << 24 | (be32_to_cpu(ah.av.ib.port_pd) & 0xffffff));
+	ah.ibah.type = rdma_ah_find_type(&dev->ib_dev, port);

 	mlx4_ib_query_ah(&ah.ibah, &ah_attr);
 	if (rdma_ah_get_ah_flags(&ah_attr) & IB_AH_GRH)
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
