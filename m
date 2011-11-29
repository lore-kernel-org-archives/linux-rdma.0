From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] RDMA/cxgb4: Use kcalloc instead of kzalloc to allocate
 array
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.302.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
--- a/drivers/infiniband/hw/cxgb4/qp.c 2011-11-13 11:07:26.503489176 +0100
+++ b/drivers/infiniband/hw/cxgb4/qp.c 2011-11-28 19:51:22.511565976 +0100
@@ -132,13 +132,13 @@ static int create_qp(struct c4iw_rdev *r
 		goto err1;
 
 	if (!user) {
-		wq->sq.sw_sq = kzalloc(wq->sq.size * sizeof *wq->sq.sw_sq,
-				 GFP_KERNEL);
+		wq->sq.sw_sq = kcalloc(wq->sq.size, sizeof(*wq->sq.sw_sq),
+				       GFP_KERNEL);
 		if (!wq->sq.sw_sq)
 			goto err2;
 
-		wq->rq.sw_rq = kzalloc(wq->rq.size * sizeof *wq->rq.sw_rq,
-				 GFP_KERNEL);
+		wq->rq.sw_rq = kcalloc(wq->rq.size, sizeof(*wq->rq.sw_rq),
+				       GFP_KERNEL);
 		if (!wq->rq.sw_rq)
 			goto err3;
 	}
