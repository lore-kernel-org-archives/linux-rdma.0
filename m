From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/4] RDMA/ocrdma: Fix warnings about uninitialized variables
Date: Tue, 24 Apr 2012 16:49:42 -0700
Message-ID: <1335311385-11381-2-git-send-email-roland@kernel.org>
References: <1335311385-11381-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335311385-11381-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

First, fix

    drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: In function 'ocrdma_alloc_pd':
    drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:371:17: warning: 'dpp_page_addr' may be used uninitialized in this function [-Wuninitialized]
    drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:337:6: note: 'dpp_page_addr' was declared here

which seems that it may border on a bug (the call to ocrdma_del_mmap()
might conceivably do bad things if pd->dpp_enabled is not set and
dpp_page_addr ends up with just the wrong value).

Also take care of:

    drivers/infiniband/hw/ocrdma/ocrdma_hw.c: In function 'ocrdma_init_hw':
    drivers/infiniband/hw/ocrdma/ocrdma_hw.c:2587:5: warning: 'status' may be used uninitialized in this function [-Wuninitialized]
    drivers/infiniband/hw/ocrdma/ocrdma_hw.c:2549:17: note: 'status' was declared here

which is only real if num_eq == 0, which should be impossible.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index c53545f..025c4a9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2546,7 +2546,7 @@ static int ocrdma_create_mq_eq(struct ocrdma_dev *dev)
 
 static int ocrdma_create_qp_eqs(struct ocrdma_dev *dev)
 {
-	int num_eq, i, status;
+	int num_eq, i, status = 0;
 	int irq;
 	unsigned long flags = 0;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 51fc9c7..e955f1f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -334,7 +334,7 @@ static int ocrdma_copy_pd_uresp(struct ocrdma_pd *pd,
 {
 	int status;
 	u64 db_page_addr;
-	u64 dpp_page_addr;
+	u64 dpp_page_addr = 0;
 	u32 db_page_size;
 	struct ocrdma_alloc_pd_uresp rsp;
 	struct ocrdma_ucontext *uctx = get_ocrdma_ucontext(ib_ctx);
@@ -368,7 +368,8 @@ static int ocrdma_copy_pd_uresp(struct ocrdma_pd *pd,
 	return 0;
 
 ucopy_err:
-	ocrdma_del_mmap(pd->uctx, dpp_page_addr, OCRDMA_DPP_PAGE_SIZE);
+	if (pd->dpp_enabled)
+		ocrdma_del_mmap(pd->uctx, dpp_page_addr, OCRDMA_DPP_PAGE_SIZE);
 dpp_map_err:
 	ocrdma_del_mmap(pd->uctx, db_page_addr, db_page_size);
 	return status;
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
