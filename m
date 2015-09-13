From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/2] IB: remove xrc_remote_srq_num from struct ib_send_wr
Date: Sun, 13 Sep 2015 17:13:35 +0200
Message-ID: <1442157215-22341-3-git-send-email-hch@lst.de>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442157215-22341-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The field is only initialized in mlx, but never used.

If we want to add proper XRC support it should be done with a new
struct ib_xrc_wr.

This shrinks the various WR structures by another 4 bytes.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 1 -
 include/rdma/ib_verbs.h         | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 9941c4a..65696e1 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2629,7 +2629,6 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		switch (ibqp->qp_type) {
 		case IB_QPT_XRC_INI:
 			xrc = seg;
-			xrc->xrc_srqn = htonl(wr->xrc_remote_srq_num);
 			seg += sizeof(*xrc);
 			size += sizeof(*xrc) / 16;
 			/* fall through */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 25f022c..edf0290 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1100,7 +1100,6 @@ struct ib_send_wr {
 		__be32		imm_data;
 		u32		invalidate_rkey;
 	} ex;
-	u32			xrc_remote_srq_num;	/* XRC TGT QPs only */
 };
 
 struct ib_rdma_wr {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
