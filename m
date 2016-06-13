From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] IB/rxe: fix error code in rxe_srq_from_init()
Date: Mon, 13 Jun 2016 09:53:41 +0300
Message-ID: <20160613065341.GA5993@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Moni Shoua <monis@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

If copy_to_user() fails then it returns the number of bytes not copied.
It would be between 1-4 here.  Later the callers dereference it leading
to an Oops.

It was sort of hard to fix this without making the code confusing so I
did a little cleanup.

Fixes: 443c15d23220 ('IB/rxe: Shared Receive Queue (SRQ) manipulation functions')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/rxe/rxe_srq.c b/drivers/infiniband/hw/rxe/rxe_srq.c
index 22c57d1..2a6e3cd 100644
--- a/drivers/infiniband/hw/rxe/rxe_srq.c
+++ b/drivers/infiniband/hw/rxe/rxe_srq.c
@@ -121,8 +121,7 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 			   srq_wqe_size);
 	if (!q) {
 		pr_warn("unable to allocate queue for srq\n");
-		err = -ENOMEM;
-		goto err1;
+		return -ENOMEM;
 	}
 
 	srq->rq.queue = q;
@@ -130,15 +129,14 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 	err = do_mmap_info(rxe, udata, false, context, q->buf,
 			   q->buf_size, &q->ip);
 	if (err)
-		goto err1;
+		return err;
 
-	if (udata && udata->outlen >= sizeof(struct mminfo) + sizeof(u32))
-		return copy_to_user(udata->outbuf + sizeof(struct mminfo),
-			&srq->srq_num, sizeof(u32));
-	else
-		return 0;
-err1:
-	return err;
+	if (udata && udata->outlen >= sizeof(struct mminfo) + sizeof(u32)) {
+		if (copy_to_user(udata->outbuf + sizeof(struct mminfo),
+				 &srq->srq_num, sizeof(u32)))
+			return -EFAULT;
+	}
+	return 0;
 }
 
 int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
