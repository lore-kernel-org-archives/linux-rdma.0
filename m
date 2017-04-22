From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 12/12] IB/ocrdma: One jump label less in
 ocrdma_alloc_ucontext_pd()
Date: Sat, 22 Apr 2017 16:54:18 +0200
Message-ID: <d6fbc9e2-aaee-3c1f-e5b5-d7c09774557d@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Apr 2017 15:45:21 +0200

This issue was detected by using the Coccinelle software.

1. Return directly if a call of the function "_ocrdma_alloc_pd" failed.

2. Reduce the scope for the local variable "status" to one case
   of an if statement.

3. Delete the jump label "err" then.

4. Return zero as a constant at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Devesh Sharma <devesh.sharma@broadcom.com>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 712c0dc9c980..fbceb9d9d5b0 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -484,19 +484,17 @@ static int ocrdma_alloc_ucontext_pd(struct ocrdma_dev *dev,
 				    struct ocrdma_ucontext *uctx,
 				    struct ib_udata *udata)
 {
-	int status = 0;
-
 	uctx->cntxt_pd = _ocrdma_alloc_pd(dev, uctx, udata);
 	if (IS_ERR(uctx->cntxt_pd)) {
-		status = PTR_ERR(uctx->cntxt_pd);
+		int status = PTR_ERR(uctx->cntxt_pd);
+
 		uctx->cntxt_pd = NULL;
-		goto err;
+		return status;
 	}
 
 	uctx->cntxt_pd->uctx = uctx;
 	uctx->cntxt_pd->ibpd.device = &dev->ibdev;
-err:
-	return status;
+	return 0;
 }
 
 static int ocrdma_dealloc_ucontext_pd(struct ocrdma_ucontext *uctx)
-- 
2.12.2
