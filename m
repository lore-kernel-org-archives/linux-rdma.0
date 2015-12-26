From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/6] InfiniBand-ocrdma: Returning only value constants in
 ocrdma_resize_cq()
Date: Sat, 26 Dec 2015 19:50:19 +0100
Message-ID: <567EE16B.9030808@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <567EDED5.4040201@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <567EDED5.4040201@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 26 Dec 2015 18:54:47 +0100

Return constant integer values without storing them in the local
variable "status".

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 2de39d3..7bedf44 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1120,15 +1120,12 @@ ctx_err:
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
2.6.3
