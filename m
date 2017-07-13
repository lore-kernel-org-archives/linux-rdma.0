From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/cxgb3: Fix error codes in iwch_alloc_mr()
Date: Thu, 13 Jul 2017 10:48:00 +0300
Message-ID: <20170713074800.dlzwroi4jmuv5xfk@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We accidentally don't set the error code on some error paths.  It means
return ERR_PTR(0) which is NULL and results in a NULL dereference in the
caller.

Fixes: 13a239330abd ("RDMA/cxgb3: Don't ignore insert_handle() failures")
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 29d30744d6c9..0cd0c1fa27d4 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -718,7 +718,7 @@ static struct ib_mr *iwch_alloc_mr(struct ib_pd *pd,
 	struct iwch_mr *mhp;
 	u32 mmid;
 	u32 stag = 0;
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	if (mr_type != IB_MR_TYPE_MEM_REG ||
 	    max_num_sg > T3_MAX_FASTREG_DEPTH)
@@ -731,10 +731,8 @@ static struct ib_mr *iwch_alloc_mr(struct ib_pd *pd,
 		goto err;
 
 	mhp->pages = kcalloc(max_num_sg, sizeof(u64), GFP_KERNEL);
-	if (!mhp->pages) {
-		ret = -ENOMEM;
+	if (!mhp->pages)
 		goto pl_err;
-	}
 
 	mhp->rhp = rhp;
 	ret = iwch_alloc_pbl(mhp, max_num_sg);
@@ -751,7 +749,8 @@ static struct ib_mr *iwch_alloc_mr(struct ib_pd *pd,
 	mhp->attr.state = 1;
 	mmid = (stag) >> 8;
 	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
-	if (insert_handle(rhp, &rhp->mmidr, mhp, mmid))
+	ret = insert_handle(rhp, &rhp->mmidr, mhp, mmid);
+	if (ret)
 		goto err3;
 
 	pr_debug("%s mmid 0x%x mhp %p stag 0x%x\n", __func__, mmid, mhp, stag);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
