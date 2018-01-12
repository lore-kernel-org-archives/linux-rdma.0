From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 4/5] i40iw: Remove setting of rem_addr.len
Date: Thu, 11 Jan 2018 18:10:53 -0600
Message-ID: <20180112001054.15572-5-shiraz.saleem@intel.com>
References: <20180112001054.15572-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112001054.15572-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove setting of rem_addr.len before calling iw_rdma_write,
iw_inline_rdma_write and rdma_read. rem_addr.len is not used
in those functions.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 9f18997..fdc1a38 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2243,14 +2243,12 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 				info.op.inline_rdma_write.len = ib_wr->sg_list[0].length;
 				info.op.inline_rdma_write.rem_addr.tag_off = rdma_wr(ib_wr)->remote_addr;
 				info.op.inline_rdma_write.rem_addr.stag = rdma_wr(ib_wr)->rkey;
-				info.op.inline_rdma_write.rem_addr.len = ib_wr->sg_list->length;
 				ret = ukqp->ops.iw_inline_rdma_write(ukqp, &info, false);
 			} else {
 				info.op.rdma_write.lo_sg_list = (void *)ib_wr->sg_list;
 				info.op.rdma_write.num_lo_sges = ib_wr->num_sge;
 				info.op.rdma_write.rem_addr.tag_off = rdma_wr(ib_wr)->remote_addr;
 				info.op.rdma_write.rem_addr.stag = rdma_wr(ib_wr)->rkey;
-				info.op.rdma_write.rem_addr.len = ib_wr->sg_list->length;
 				ret = ukqp->ops.iw_rdma_write(ukqp, &info, false);
 			}
 
@@ -2272,7 +2270,6 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 			info.op_type = I40IW_OP_TYPE_RDMA_READ;
 			info.op.rdma_read.rem_addr.tag_off = rdma_wr(ib_wr)->remote_addr;
 			info.op.rdma_read.rem_addr.stag = rdma_wr(ib_wr)->rkey;
-			info.op.rdma_read.rem_addr.len = ib_wr->sg_list->length;
 			info.op.rdma_read.lo_addr.tag_off = ib_wr->sg_list->addr;
 			info.op.rdma_read.lo_addr.stag = ib_wr->sg_list->lkey;
 			info.op.rdma_read.lo_addr.len = ib_wr->sg_list->length;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
