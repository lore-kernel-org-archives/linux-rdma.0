From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/libocrdma: fix library stack curruption
Date: Fri, 31 Oct 2014 19:16:12 +0530
Message-ID: <774e14a2-8394-4cde-aeaa-369f270e75ef@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The library abi structures are not matching with the
upstream driver abi code. The mismatch is causing
stack curruption on some platforms while running
user application.

This patch has a fix for stack curruption.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/ocrdma_abi.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/ocrdma_abi.h b/src/ocrdma_abi.h
index 88498a9..ad7abd4 100644
--- a/src/ocrdma_abi.h
+++ b/src/ocrdma_abi.h
@@ -74,7 +74,7 @@ struct ocrdma_alloc_ucontext_resp {
 	uint32_t ah_tbl_len;
 	uint32_t rqe_size;
 	uint8_t fw_ver[32];
-	uint32_t rsvd1;
+	uint64_t rsvd1;
 	uint64_t rsvd2;
 };
 
@@ -153,8 +153,7 @@ struct ocrdma_create_qp_uresp {
 	uint32_t db_sq_offset;
 	uint32_t db_rq_offset;
 	uint32_t db_shift;
-	uint64_t rsvd2;
-	uint64_t rsvd3;
+	uint64_t rsvd[11]; /* 8*8 + 4*4 + 8 */
 };
 
 struct ocrdma_create_srq_cmd {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
