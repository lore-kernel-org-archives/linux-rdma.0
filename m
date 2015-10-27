From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 6/7] IB/srp: Introduce target->mr_pool_size
Date: Tue, 27 Oct 2015 15:03:40 -0700
Message-ID: <562FF4BC.6030100@sandisk.com>
References: <562FF404.7000504@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562FF404.7000504-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 6 +++---
 drivers/infiniband/ulp/srp/ib_srp.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fb6b654..47c3a72 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -315,7 +315,7 @@ static struct ib_fmr_pool *srp_alloc_fmr_pool(struct srp_target_port *target)
 	struct ib_fmr_pool_param fmr_param;
 
 	memset(&fmr_param, 0, sizeof(fmr_param));
-	fmr_param.pool_size	    = target->scsi_host->can_queue;
+	fmr_param.pool_size	    = target->mr_pool_size;
 	fmr_param.dirty_watermark   = fmr_param.pool_size / 4;
 	fmr_param.cache		    = 1;
 	fmr_param.max_pages_per_fmr = dev->max_pages_per_mr;
@@ -449,8 +449,7 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
 {
 	struct srp_device *dev = target->srp_host->srp_dev;
 
-	return srp_create_fr_pool(dev->dev, dev->pd,
-				  target->scsi_host->can_queue,
+	return srp_create_fr_pool(dev->dev, dev->pd, target->mr_pool_size,
 				  dev->max_pages_per_mr);
 }
 
@@ -3247,6 +3246,7 @@ static ssize_t srp_create_target(struct device *dev,
 	}
 
 	target_host->sg_tablesize = target->sg_tablesize;
+	target->mr_pool_size = target->scsi_host->can_queue;
 	target->indirect_size = target->sg_tablesize *
 				sizeof (struct srp_direct_buf);
 	target->max_iu_len = sizeof (struct srp_cmd) +
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 1c6a715..af084f7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -205,6 +205,7 @@ struct srp_target_port {
 	char			target_name[32];
 	unsigned int		scsi_id;
 	unsigned int		sg_tablesize;
+	int			mr_pool_size;
 	int			queue_size;
 	int			req_ring_size;
 	int			comp_vector;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
