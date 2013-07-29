From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch v2] RDMA/ocrdma: several stack info leaks
Date: Mon, 29 Jul 2013 22:34:29 +0300
Message-ID: <20130729192431.GB11977@elgon.mountain>
References: <b54b5aaa-8efd-4a9c-899b-341c3808f9c4@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b54b5aaa-8efd-4a9c-899b-341c3808f9c4-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A grab bag of places which don't properly initialize stack data.  I
removed one place which cleared ".rsvd" because it's not needed now that
I have added a memset() earlier in the function.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v2: different approach to fixing the problem

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index dcfbab1..f36630e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -242,6 +242,7 @@ struct ib_ucontext *ocrdma_alloc_ucontext(struct ib_device *ibdev,
 	memset(ctx->ah_tbl.va, 0, map_len);
 	ctx->ah_tbl.len = map_len;
 
+	memset(&resp, 0, sizeof(resp));
 	resp.ah_tbl_len = ctx->ah_tbl.len;
 	resp.ah_tbl_page = ctx->ah_tbl.pa;
 
@@ -253,7 +254,6 @@ struct ib_ucontext *ocrdma_alloc_ucontext(struct ib_device *ibdev,
 	resp.wqe_size = dev->attr.wqe_size;
 	resp.rqe_size = dev->attr.rqe_size;
 	resp.dpp_wqe_size = dev->attr.wqe_size;
-	resp.rsvd = 0;
 
 	memcpy(resp.fw_ver, dev->attr.fw_ver, sizeof(resp.fw_ver));
 	status = ib_copy_to_udata(udata, &resp, sizeof(resp));
@@ -338,6 +338,7 @@ static int ocrdma_copy_pd_uresp(struct ocrdma_pd *pd,
 	struct ocrdma_alloc_pd_uresp rsp;
 	struct ocrdma_ucontext *uctx = get_ocrdma_ucontext(ib_ctx);
 
+	memset(&rsp, 0, sizeof(rsp));
 	rsp.id = pd->id;
 	rsp.dpp_enabled = pd->dpp_enabled;
 	db_page_addr = pd->dev->nic_info.unmapped_db +
@@ -692,6 +693,7 @@ static int ocrdma_copy_cq_uresp(struct ocrdma_cq *cq, struct ib_udata *udata,
 	struct ocrdma_ucontext *uctx;
 	struct ocrdma_create_cq_uresp uresp;
 
+	memset(&uresp, 0, sizeof(uresp));
 	uresp.cq_id = cq->id;
 	uresp.page_size = cq->len;
 	uresp.num_pages = 1;
@@ -1460,6 +1462,7 @@ static int ocrdma_copy_srq_uresp(struct ocrdma_srq *srq, struct ib_udata *udata)
 	int status;
 	struct ocrdma_create_srq_uresp uresp;
 
+	memset(&uresp, 0, sizeof(uresp));
 	uresp.rq_dbid = srq->rq.dbid;
 	uresp.num_rq_pages = 1;
 	uresp.rq_page_addr[0] = srq->rq.pa;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
