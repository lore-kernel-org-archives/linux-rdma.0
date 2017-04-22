From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 10/12] IB/ocrdma: Returning only value constants in
 ocrdma_resize_cq()
Date: Sat, 22 Apr 2017 16:50:51 +0200
Message-ID: <0ecccc12-7340-927b-3745-8b84a7e137f8@users.sourceforge.net>
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
Date: Sat, 22 Apr 2017 15:15:09 +0200

Return constant integer values without storing them in the local
variable "status".

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Devesh Sharma <devesh.sharma@broadcom.com>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 2dc399eeeefd..60b8813aff42 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1122,15 +1122,12 @@ struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev,
 int ocrdma_resize_cq(struct ib_cq *ibcq, int new_cnt,
 		     struct ib_udata *udata)
 {
-	int status = 0;
 	struct ocrdma_cq *cq = get_ocrdma_cq(ibcq);
 
-	if (new_cnt < 1 || new_cnt > cq->max_hw_cqe) {
-		status = -EINVAL;
-		return status;
-	}
+	if (new_cnt < 1 || new_cnt > cq->max_hw_cqe)
+		return -EINVAL;
 	ibcq->cqe = new_cnt;
-	return status;
+	return 0;
 }
 
 static void ocrdma_flush_cq(struct ocrdma_cq *cq)
-- 
2.12.2
