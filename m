From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 7/8] IB/srp: try to use larger FMR sizes to cover our mappings
Date: Tue, 18 Jan 2011 23:27:21 -0500
Message-ID: <1295411242-26148-8-git-send-email-dillowda@ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1295411242-26148-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Now that we can get larger SG lists, we can take advantage of HCAs that
allow us to use larger FMR sizes. In many cases, we can use up to 512
entries, so start there and work our way down.
---
 drivers/infiniband/ulp/srp/ib_srp.c |   31 +++++++++++++++++++------------
 drivers/infiniband/ulp/srp/ib_srp.h |    3 ++-
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0121530..1da8b25 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2300,7 +2300,7 @@ static void srp_add_one(struct ib_device *device)
 	struct ib_device_attr *dev_attr;
 	struct ib_fmr_pool_param fmr_param;
 	struct srp_host *host;
-	int fmr_page_shift, s, e, p;
+	int max_pages_per_fmr, fmr_page_shift, s, e, p;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -2340,17 +2340,24 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->mr))
 		goto err_pd;
 
-	memset(&fmr_param, 0, sizeof fmr_param);
-	fmr_param.pool_size	    = SRP_FMR_POOL_SIZE;
-	fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
-	fmr_param.cache		    = 1;
-	fmr_param.max_pages_per_fmr = SRP_FMR_SIZE;
-	fmr_param.page_shift	    = fmr_page_shift;
-	fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
-				       IB_ACCESS_REMOTE_WRITE |
-				       IB_ACCESS_REMOTE_READ);
-
-	srp_dev->fmr_pool = ib_create_fmr_pool(srp_dev->pd, &fmr_param);
+	for (max_pages_per_fmr = SRP_FMR_SIZE;
+			max_pages_per_fmr >= SRP_FMR_MIN_SIZE;
+			max_pages_per_fmr /= 2, srp_dev->fmr_max_size /= 2) {
+		memset(&fmr_param, 0, sizeof fmr_param);
+		fmr_param.pool_size	    = SRP_FMR_POOL_SIZE;
+		fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
+		fmr_param.cache		    = 1;
+		fmr_param.max_pages_per_fmr = SRP_FMR_SIZE;
+		fmr_param.page_shift	    = fmr_page_shift;
+		fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
+					       IB_ACCESS_REMOTE_WRITE |
+					       IB_ACCESS_REMOTE_READ);
+
+		srp_dev->fmr_pool = ib_create_fmr_pool(srp_dev->pd, &fmr_param);
+		if (!IS_ERR(srp_dev->fmr_pool))
+			break;
+	}
+
 	if (IS_ERR(srp_dev->fmr_pool))
 		srp_dev->fmr_pool = NULL;
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index cf69621..020caf0 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -69,7 +69,8 @@ enum {
 	SRP_TAG_NO_REQ		= ~0U,
 	SRP_TAG_TSK_MGMT	= 1U << 31,
 
-	SRP_FMR_SIZE		= 256,
+	SRP_FMR_SIZE		= 512,
+	SRP_FMR_MIN_SIZE	= 128,
 	SRP_FMR_POOL_SIZE	= 1024,
 	SRP_FMR_DIRTY_SIZE	= SRP_FMR_POOL_SIZE / 4,
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
