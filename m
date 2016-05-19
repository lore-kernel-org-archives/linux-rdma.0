From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/8] IB/rdmavt: Insure QP vmalloc variants zero memory
Date: Thu, 19 May 2016 05:21:25 -0700
Message-ID: <20160519122123.30706.81554.stgit@scvm10.sc.intel.com>
References: <20160519000433.30706.21093.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519000433.30706.21093.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The usage of the various vmalloc APIs do not consistently zero memory
when allocating the swqe. Insure zeroing variants are used.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 0f12c21..dd03b23 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -653,9 +653,9 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		if (gfp == GFP_NOIO)
 			swq = __vmalloc(
 				(init_attr->cap.max_send_wr + 1) * sz,
-				gfp, PAGE_KERNEL);
+				gfp | __GFP_ZERO, PAGE_KERNEL);
 		else
-			swq = vmalloc_node(
+			swq = vzalloc_node(
 				(init_attr->cap.max_send_wr + 1) * sz,
 				rdi->dparms.node);
 		if (!swq)
@@ -704,9 +704,9 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 				qp->r_rq.wq = __vmalloc(
 						sizeof(struct rvt_rwq) +
 						qp->r_rq.size * sz,
-						gfp, PAGE_KERNEL);
+						gfp | __GFP_ZERO, PAGE_KERNEL);
 			else
-				qp->r_rq.wq = vmalloc_node(
+				qp->r_rq.wq = vzalloc_node(
 						sizeof(struct rvt_rwq) +
 						qp->r_rq.size * sz,
 						rdi->dparms.node);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
