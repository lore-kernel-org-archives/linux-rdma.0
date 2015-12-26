From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 6/6] InfiniBand-ocrdma: Delete an unnecessary variable in
 ocrdma_dealloc_pd()
Date: Sat, 26 Dec 2015 19:51:21 +0100
Message-ID: <567EE1A9.9000101@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <567EDED5.4040201@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <567EDED5.4040201@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 26 Dec 2015 19:09:23 +0100

1. Return zero in one case directly.

2. Return the value from a call of the _ocrdma_dealloc_pd() function
   without using an extra assignment for the local variable.

3. Remove the variable "status" in this function then.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 7bedf44..0f79a01 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -750,7 +750,6 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
 	struct ocrdma_ucontext *uctx = NULL;
-	int status = 0;
 	u64 usr_db;
 
 	uctx = pd->uctx;
@@ -764,11 +763,10 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 
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
2.6.3

