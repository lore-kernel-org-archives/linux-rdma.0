From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH v2 09/12] IB/srp: Do not create an all physical insecure rkey by default
Date: Thu, 30 Jul 2015 17:22:23 -0600
Message-ID: <1438298547-21404-10-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

The ULP only needs this if the insecure register_always performance
optimization is enabled, or if FRWR/FMR is not supported in the driver.

Do not create an all physical MR unless it is needed to support either of
those modes. Default register_always to true so the out of the box
configuration does not create an insecure all physical MR.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 31 +++++++++++++++++++++----------
 drivers/infiniband/ulp/srp/ib_srp.h |  2 +-
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 19a1356f8b2a..a8003079c232 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -69,7 +69,7 @@ static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
 static bool prefer_fr;
-static bool register_always;
+static bool register_always = true;
 static int topspin_workarounds = 1;
 
 module_param(srp_sg_tablesize, uint, 0444);
@@ -3147,7 +3147,8 @@ static ssize_t srp_create_target(struct device *dev,
 	target->scsi_host	= target_host;
 	target->srp_host	= host;
 	target->lkey		= host->srp_dev->pd->local_dma_lkey;
-	target->rkey		= host->srp_dev->mr->rkey;
+	if (host->srp_dev->rkey_mr)
+		target->rkey		= host->srp_dev->rkey_mr->rkey;
 	target->cmd_sg_cnt	= cmd_sg_entries;
 	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
 	target->allow_ext_sg	= allow_ext_sg;
@@ -3378,6 +3379,7 @@ static void srp_add_one(struct ib_device *device)
 	struct srp_host *host;
 	int mr_page_shift, p;
 	u64 max_pages_per_mr;
+	unsigned int mr_flags = 0;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -3396,8 +3398,11 @@ static void srp_add_one(struct ib_device *device)
 			    device->map_phys_fmr && device->unmap_fmr);
 	srp_dev->has_fr = (dev_attr->device_cap_flags &
 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
-	if (!srp_dev->has_fmr && !srp_dev->has_fr)
+	if (!srp_dev->has_fmr && !srp_dev->has_fr) {
 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
+		/* Fall back to using an insecure all physical rkey */
+		mr_flags |= IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
+	}
 
 	srp_dev->use_fast_reg = (srp_dev->has_fr &&
 				 (!srp_dev->has_fmr || prefer_fr));
@@ -3433,12 +3438,17 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->pd))
 		goto free_dev;
 
-	srp_dev->mr = ib_get_dma_mr(srp_dev->pd,
-				    IB_ACCESS_LOCAL_WRITE |
-				    IB_ACCESS_REMOTE_READ |
-				    IB_ACCESS_REMOTE_WRITE);
-	if (IS_ERR(srp_dev->mr))
-		goto err_pd;
+	if (!register_always)
+		mr_flags |= IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
+
+	if (mr_flags) {
+		srp_dev->rkey_mr = ib_get_dma_mr(
+		    srp_dev->pd, IB_ACCESS_LOCAL_WRITE | mr_flags);
+		if (IS_ERR(srp_dev->rkey_mr))
+			goto err_pd;
+	} else
+		srp_dev->rkey_mr = NULL;
+
 
 	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
 		host = srp_add_port(srp_dev, p);
@@ -3495,7 +3505,8 @@ static void srp_remove_one(struct ib_device *device)
 		kfree(host);
 	}
 
-	ib_dereg_mr(srp_dev->mr);
+	if (srp_dev->rkey_mr)
+		ib_dereg_mr(srp_dev->rkey_mr);
 	ib_dealloc_pd(srp_dev->pd);
 
 	kfree(srp_dev);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 17ee3f80ba55..8b241f17f8b8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -95,7 +95,7 @@ struct srp_device {
 	struct list_head	dev_list;
 	struct ib_device       *dev;
 	struct ib_pd	       *pd;
-	struct ib_mr	       *mr;
+	struct ib_mr	       *rkey_mr;
 	u64			mr_page_mask;
 	int			mr_page_size;
 	int			mr_max_size;
-- 
2.1.4
