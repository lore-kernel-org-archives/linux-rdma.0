From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] IB/rxe: double free on error
Date: Wed, 8 Mar 2017 08:21:52 +0300
Message-ID: <20170308052152.GA31503@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Moni Shoua <monis@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

"goto err;" has it's own kfree_skb() call so it's a double free.  We
only need to free on the "goto exit;" path.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static analysis.  Not tested.  Please review carefully.

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index dbfde0dc6ff7..9f95f50b2909 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -729,11 +729,11 @@ int rxe_requester(void *arg)
 	ret = rxe_xmit_packet(to_rdev(qp->ibqp.device), qp, &pkt, skb);
 	if (ret) {
 		qp->need_req_skb = 1;
-		kfree_skb(skb);
 
 		rollback_state(wqe, qp, &rollback_wqe, rollback_psn);
 
 		if (ret == -EAGAIN) {
+			kfree_skb(skb);
 			rxe_run_task(&qp->req.task, 1);
 			goto exit;
 		}
