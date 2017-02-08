From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 11/14] RDMA/cxgb4: Use kcalloc() in create_qp()
Date: Wed, 8 Feb 2017 22:21:38 +0100
Message-ID: <671e21d7-5962-7d2a-c359-42571a7811ba@users.sourceforge.net>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Steve Wise <swise@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Feb 2017 20:27:51 +0100

Multiplications for the size determination of memory allocations
indicated that array data structures should be processed.
Thus use the corresponding function "kcalloc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/cxgb4/qp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index d4fd2f5c8326..373d66a511a8 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -216,15 +216,17 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	}
 
 	if (!user) {
-		wq->sq.sw_sq = kzalloc(wq->sq.size * sizeof *wq->sq.sw_sq,
-				 GFP_KERNEL);
+		wq->sq.sw_sq = kcalloc(wq->sq.size,
+				       sizeof(*wq->sq.sw_sq),
+				       GFP_KERNEL);
 		if (!wq->sq.sw_sq) {
 			ret = -ENOMEM;
 			goto free_rq_qid;
 		}
 
-		wq->rq.sw_rq = kzalloc(wq->rq.size * sizeof *wq->rq.sw_rq,
-				 GFP_KERNEL);
+		wq->rq.sw_rq = kcalloc(wq->rq.size,
+				       sizeof(*wq->rq.sw_rq),
+				       GFP_KERNEL);
 		if (!wq->rq.sw_rq) {
 			ret = -ENOMEM;
 			goto free_sw_sq;
-- 
2.11.1

