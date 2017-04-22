From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 09/12] IB/ocrdma: Delete an unnecessary variable assignment
 in ocrdma_alloc_mr()
Date: Sat, 22 Apr 2017 16:49:51 +0200
Message-ID: <78cdbeeb-5274-d315-33d3-4019f0eb35be@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Apr 2017 15:07:41 +0200

Delete an assignment for the local variable "status" in an if branch
because the desired failure indication is already specified by a constant
error code at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Devesh Sharma <devesh.sharma@broadcom.com>
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index c804889db7e1..2dc399eeeefd 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -3022,10 +3022,8 @@ struct ib_mr *ocrdma_alloc_mr(struct ib_pd *ibpd,
 		return ERR_PTR(-ENOMEM);
 
 	mr->pages = kcalloc(max_num_sg, sizeof(*mr->pages), GFP_KERNEL);
-	if (!mr->pages) {
-		status = -ENOMEM;
+	if (!mr->pages)
 		goto pl_err;
-	}
 
 	status = ocrdma_get_pbl_info(dev, mr, max_num_sg);
 	if (status)
-- 
2.12.2

