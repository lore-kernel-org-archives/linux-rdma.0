From: <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] RDMA/libocrdma: un-map cqe memory in destroy_cq
Date: Fri, 21 Feb 2014 11:01:43 +0530
Message-ID: <1392960704-10871-3-git-send-email-devesh.sharma@emulex.com>
References: <1392960704-10871-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392960704-10871-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

while calling detroy cq, the host memory used to hold CQEs
needs to be unmapped.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/ocrdma_verbs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index acf460f..96c5f78 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -356,9 +356,13 @@ int ocrdma_resize_cq(struct ibv_cq *ibcq, int new_entries)
 int ocrdma_destroy_cq(struct ibv_cq *ibv_cq)
 {
 	struct ocrdma_cq *cq = get_ocrdma_cq(ibv_cq);
+
 	ibv_cmd_destroy_cq(ibv_cq);
 	if (cq->db_va)
 		munmap((void *)cq->db_va, cq->db_size);
+	if (cq->va)
+		munmap((void*)cq->va, cq->cq_mem_size);
+
 	free(cq);
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
