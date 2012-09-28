From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2] IB/qib: fix local access validation for user MRs
Date: Fri, 28 Sep 2012 13:33:52 -0400
Message-ID: <20120928173352.7806.14768.stgit@phlsvsles11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 8aac4cc3 ("IB/qib: RCU locking for MR validation") introduced
an error that broke user post sends.  The proper validation of the MR
was lost in the patch.

This patch corrects that validation.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_keys.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index e9486c7..81c7b73 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -186,8 +186,9 @@ int qib_lkey_ok(struct qib_lkey_table *rkt, struct qib_pd *pd,
 		goto bail;
 
 	off = sge->addr - mr->user_base;
-	if (unlikely(sge->addr < mr->iova || off + sge->length > mr->length ||
-		     (mr->access_flags & acc) == 0))
+	if (unlikely(sge->addr < mr->user_base ||
+		     off + sge->length > mr->length ||
+		     (mr->access_flags & acc) != acc))
 		goto bail;
 	if (unlikely(!atomic_inc_not_zero(&mr->refcount)))
 		goto bail;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
