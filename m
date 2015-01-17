From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/libocrdma: return error if destroy fails
Date: Sat, 17 Jan 2015 15:37:23 +0530
Message-ID: <12d6c580-1a1f-4da4-b3e1-12b75e2f983b@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

If the destorying of any resource has failed at uverbs
command interface libocrdma should return the error code.

Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/ocrdma_verbs.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index c089a5f..cf2ecd2 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -209,10 +209,11 @@ int ocrdma_free_pd(struct ibv_pd *ibpd)
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
 
 	status = ibv_cmd_dealloc_pd(ibpd);
-	if (pd->dpp_va)
-		munmap((void *)pd->dpp_va, OCRDMA_DPP_PAGE_SIZE);
 	if (status)
 		return status;
+
+	if (pd->dpp_va)
+		munmap((void *)pd->dpp_va, OCRDMA_DPP_PAGE_SIZE);
 	free(pd);
 	return 0;
 }
@@ -356,8 +357,12 @@ int ocrdma_resize_cq(struct ibv_cq *ibcq, int new_entries)
 int ocrdma_destroy_cq(struct ibv_cq *ibv_cq)
 {
 	struct ocrdma_cq *cq = get_ocrdma_cq(ibv_cq);
+	int status;
+
+	status = ibv_cmd_destroy_cq(ibv_cq);
+	if (status)
+		return status;
 
-	ibv_cmd_destroy_cq(ibv_cq);
 	if (cq->db_va)
 		munmap((void *)cq->db_va, cq->db_size);
 	if (cq->va)
@@ -484,6 +489,9 @@ int ocrdma_destroy_srq(struct ibv_srq *ibsrq)
 
 	id = dev->id;
 	status = ibv_cmd_destroy_srq(ibsrq);
+	if (status)
+		return status;
+
 	if (srq->idx_bit_fields)
 		free(srq->idx_bit_fields);
 	if (srq->rqe_wr_id_tbl)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
