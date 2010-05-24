From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 2/3] mlx4: match API changes with ib_ud_header_init()
Date: Mon, 24 May 2010 08:28:38 +0300
Message-ID: <20100524052838.GA16127@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 5643f4a..33d8156 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1229,7 +1229,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	for (i = 0; i < wr->num_sge; ++i)
 		send_size += wr->sg_list[i].length;
 
-	ib_ud_header_init(send_size, mlx4_ib_ah_grh_present(ah), 0, &sqp->ud_header);
+	ib_ud_header_init(send_size, 1, 0, mlx4_ib_ah_grh_present(ah), 0, &sqp->ud_header);
 
 	sqp->ud_header.lrh.service_level   =
 		be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 28;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
