From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 11/12] IB/ocrdma: Delete an unnecessary variable in
 ocrdma_dealloc_pd()
Date: Sat, 22 Apr 2017 16:51:50 +0200
Message-ID: <723017f3-4a6e-5f4d-5431-4caf8af90c2d@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Apr 2017 15:32:05 +0200

1. Return zero in one case directly.

2. Return the value from a call of the function "_ocrdma_dealloc_pd"
   without using an extra assignment for the local variable.

3. Remove the variable "status" in this function then.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Devesh Sharma <devesh.sharma@broadcom.com>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 60b8813aff42..712c0dc9c980 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -754,7 +754,6 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
 	struct ocrdma_ucontext *uctx = NULL;
-	int status = 0;
 	u64 usr_db;
 
 	uctx = pd->uctx;
@@ -768,11 +767,10 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 
 		if (is_ucontext_pd(uctx, pd)) {
 			ocrdma_release_ucontext_pd(uctx);
-			return status;
+			return 0;
 		}
 	}
-	status = _ocrdma_dealloc_pd(dev, pd);
-	return status;
+	return _ocrdma_dealloc_pd(dev, pd);
 }
 
 static int ocrdma_alloc_lkey(struct ocrdma_dev *dev, struct ocrdma_mr *mr,
-- 
2.12.2
