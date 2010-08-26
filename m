From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv10 04/12] mpt to API changelx4: Adapt to API changes in the
 previous commit
Date: Thu, 26 Aug 2010 17:18:05 +0300
Message-ID: <20100826141805.GE8795@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is done to synchronize mlx4 with the API changes.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 6a60827..bb1277c 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1231,7 +1231,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	for (i = 0; i < wr->num_sge; ++i)
 		send_size += wr->sg_list[i].length;
 
-	ib_ud_header_init(send_size, mlx4_ib_ah_grh_present(ah), 0, &sqp->ud_header);
+	ib_ud_header_init(send_size, 1, 0, mlx4_ib_ah_grh_present(ah), 0, &sqp->ud_header);
 
 	sqp->ud_header.lrh.service_level   =
 		be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 28;
-- 
1.7.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
