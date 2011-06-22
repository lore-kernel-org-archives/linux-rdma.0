From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: Non-xrc SRQs need an xrcd which will never be used by xrc
Date: Wed, 22 Jun 2011 15:33:40 +0300
Message-ID: <201106221533.41053.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Non-xrc SRQs should be created with a domain number which will never
be assigned to an XRC TGT QP. This is so there is no possibility of such an SRQ
inadvertently receiving an XRC transmission.

XRC Domain number allocations begin with (dev->dev->caps.reserved_xrcds + 1);
Domain number (dev->dev->caps.reserved_xrcds) has been set aside to be used
for this purpose.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org

---
Sean,
This was a little "glitch" that I noticed during my code review.

-Jack

diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 361838f..39542f3 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -77,7 +77,7 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 	struct mlx4_wqe_srq_next_seg *next;
 	struct mlx4_wqe_data_seg *scatter;
 	u32 cqn;
-	u32 xrcdn;
+	u16 xrcdn;
 	int desc_size;
 	int buf_size;
 	int err;
@@ -179,7 +179,8 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 	cqn = (init_attr->srq_type == IB_SRQT_XRC) ?
 		to_mcq(init_attr->ext.xrc.cq)->mcq.cqn : 0;
 	xrcdn = (init_attr->srq_type == IB_SRQT_XRC) ?
-		to_mxrcd(init_attr->ext.xrc.xrcd)->xrcdn : 0;
+		to_mxrcd(init_attr->ext.xrc.xrcd)->xrcdn :
+		(u16) dev->dev->caps.reserved_xrcds;
 	err = mlx4_srq_alloc(dev->dev, to_mpd(pd)->pdn, cqn, xrcdn, &srq->mtt,
 			     srq->db.dma, &srq->msrq);
 	if (err)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
