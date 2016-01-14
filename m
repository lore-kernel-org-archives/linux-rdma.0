From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v3 4/6] InfiniBand-ocrdma: Return a value from a function call
 in _ocrdma_modify_qp() directly
Date: Thu, 14 Jan 2016 18:48:05 +0100
Message-ID: <5697DF55.2050501@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <567EDED5.4040201@users.sourceforge.net>
 <5697D865.5010507@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <5697D865.5010507@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 14 Jan 2016 18:00:23 +0100

Return the value from a call of the ocrdma_mbx_modify_qp() function
without using an extra assignment for the local variable "status".

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 1d90d18..5f2a34a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1492,9 +1492,7 @@ int _ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	 */
 	if (status < 0)
 		return status;
-	status = ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask);
-
-	return status;
+	return ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask);
 }
 
 int ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-- 
2.6.3

