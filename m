From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/6] IB/core: rename pd->local_mr to pd->__internal_mr
Date: Mon,  5 Sep 2016 12:56:16 +0200
Message-ID: <1473072981-2035-2-git-send-email-hch@lst.de>
References: <1473072981-2035-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473072981-2035-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This has two reasons: a) to clearly mark that drivers don't have any
business using it, and b) because we're going to use it for the
(dangerous) global rkey soon, so that drivers don't create on themselves.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |  2 +-
 drivers/infiniband/core/verbs.c      | 12 ++++++------
 include/rdma/ib_verbs.h              |  6 +++++-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f664731..fe784a9 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -571,7 +571,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 
 	pd->device  = ib_dev;
 	pd->uobject = uobj;
-	pd->local_mr = NULL;
+	pd->__internal_mr = NULL;
 	atomic_set(&pd->usecnt, 0);
 
 	uobj->object = pd;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f2b776e..9159ea5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -237,7 +237,7 @@ struct ib_pd *ib_alloc_pd(struct ib_device *device)
 
 	pd->device = device;
 	pd->uobject = NULL;
-	pd->local_mr = NULL;
+	pd->__internal_mr = NULL;
 	atomic_set(&pd->usecnt, 0);
 
 	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
@@ -251,8 +251,8 @@ struct ib_pd *ib_alloc_pd(struct ib_device *device)
 			return (struct ib_pd *)mr;
 		}
 
-		pd->local_mr = mr;
-		pd->local_dma_lkey = pd->local_mr->lkey;
+		pd->__internal_mr = mr;
+		pd->local_dma_lkey = pd->__internal_mr->lkey;
 	}
 	return pd;
 }
@@ -270,10 +270,10 @@ void ib_dealloc_pd(struct ib_pd *pd)
 {
 	int ret;
 
-	if (pd->local_mr) {
-		ret = ib_dereg_mr(pd->local_mr);
+	if (pd->__internal_mr) {
+		ret = ib_dereg_mr(pd->__internal_mr);
 		WARN_ON(ret);
-		pd->local_mr = NULL;
+		pd->__internal_mr = NULL;
 	}
 
 	/* uverbs manipulates usecnt with proper locking, while the kabi
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8e90dd2..38a08dae 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1373,7 +1373,11 @@ struct ib_pd {
 	struct ib_device       *device;
 	struct ib_uobject      *uobject;
 	atomic_t          	usecnt; /* count all resources */
-	struct ib_mr	       *local_mr;
+
+	/*
+	 * Implementation details of the RDMA core, don't use in drivers:
+	 */
+	struct ib_mr	       *__internal_mr;
 };
 
 struct ib_xrcd {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
