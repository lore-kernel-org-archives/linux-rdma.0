From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] RDMA/ocrdma: several stack info leaks
Date: Thu, 25 Jul 2013 20:05:32 +0300
Message-ID: <20130725170532.GE7026@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Naresh Gottumukkala <bgottumukkala@emulex.com>, Parav Pandit <parav.pandit@emulex.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

A grab bag of places which don't properly initialize stack data.  If the
struct member was at the end of the struct then I fixed the issue by not
passing the uninitialized bits to the user.  This seems like the
prefered thing in infiniband drivers.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index dcfbab1..78bada7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -256,7 +256,8 @@ struct ib_ucontext *ocrdma_alloc_ucontext(struct ib_device *ibdev,
 	resp.rsvd = 0;
 
 	memcpy(resp.fw_ver, dev->attr.fw_ver, sizeof(resp.fw_ver));
-	status = ib_copy_to_udata(udata, &resp, sizeof(resp));
+	status = ib_copy_to_udata(udata, &resp,
+				  sizeof(resp) - sizeof(resp.rsvd1));
 	if (status)
 		goto cpy_err;
 	return &ctx->ibucontext;
@@ -357,9 +358,12 @@ static int ocrdma_copy_pd_uresp(struct ocrdma_pd *pd,
 			goto dpp_map_err;
 		rsp.dpp_page_addr_hi = upper_32_bits(dpp_page_addr);
 		rsp.dpp_page_addr_lo = dpp_page_addr;
+	} else {
+		rsp.dpp_page_addr_hi = 0;
+		rsp.dpp_page_addr_lo = 0;
 	}
 
-	status = ib_copy_to_udata(udata, &rsp, sizeof(rsp));
+	status = ib_copy_to_udata(udata, &rsp, sizeof(rsp) - sizeof(rsp.rsvd1));
 	if (status)
 		goto ucopy_err;
 
@@ -700,7 +704,8 @@ static int ocrdma_copy_cq_uresp(struct ocrdma_cq *cq, struct ib_udata *udata,
 	uresp.db_page_addr = cq->dev->nic_info.unmapped_db;
 	uresp.db_page_size = cq->dev->nic_info.db_page_size;
 	uresp.phase_change = cq->phase_change ? 1 : 0;
-	status = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+	status = ib_copy_to_udata(udata, &uresp,
+				  sizeof(uresp) - sizeof(u64) * 2);
 	if (status) {
 		pr_err("%s(%d) copy error cqid=0x%x.\n",
 		       __func__, cq->dev->id, cq->id);
@@ -1461,6 +1466,8 @@ static int ocrdma_copy_srq_uresp(struct ocrdma_srq *srq, struct ib_udata *udata)
 	struct ocrdma_create_srq_uresp uresp;
 
 	uresp.rq_dbid = srq->rq.dbid;
+	uresp.resv0 = 0;
+	uresp.resv1 = 0;
 	uresp.num_rq_pages = 1;
 	uresp.rq_page_addr[0] = srq->rq.pa;
 	uresp.rq_page_size = srq->rq.len;
@@ -1476,7 +1483,8 @@ static int ocrdma_copy_srq_uresp(struct ocrdma_srq *srq, struct ib_udata *udata)
 		uresp.db_shift = 16;
 	}
 
-	status = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+	status = ib_copy_to_udata(udata, &uresp,
+				  sizeof(uresp) - sizeof(u64) * 2);
 	if (status)
 		return status;
 	status = ocrdma_add_mmap(srq->pd->uctx, uresp.rq_page_addr[0],
