From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Fri, 22 Apr 2016 14:16:31 -0700
Message-ID: <571A94AF.7000609@sandisk.com>
References: <571A936F.7040409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571A936F.7040409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If both max_sectors and the queue_depth are high enough it can
happen that the MR pool is depleted temporarily. This causes
the SRP initiator to report mapping failures. Although the SRP
initiator recovers from such mapping failures, prevent that
this can happen by limiting max_sectors.

Reported-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a173ec4..ebd4d90 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3172,6 +3172,7 @@ static ssize_t srp_create_target(struct device *dev,
 	struct srp_device *srp_dev = host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
 	int ret, node_idx, node, cpu, i;
+	unsigned int max_max_sectors;
 	bool multich = false;
 
 	target_host = scsi_host_alloc(&srp_template,
@@ -3228,6 +3229,25 @@ static ssize_t srp_create_target(struct device *dev,
 		target->sg_tablesize = target->cmd_sg_cnt;
 	}
 
+	if (srp_dev->use_fast_reg || srp_dev->use_fmr) {
+		/*
+		 * FR and FMR can only map one HCA page per entry. If the
+		 * start address is not aligned on a HCA page boundary two
+		 * entries will be used for the head and the tail although
+		 * these two entries combined contain at most one HCA page of
+		 * data. Hence the "- 1" in the calculation below.
+		 */
+		max_max_sectors = (srp_dev->max_pages_per_mr - 1) <<
+				  (ilog2(srp_dev->mr_page_size) - 9);
+		if (target->scsi_host->max_sectors > max_max_sectors) {
+			shost_printk(KERN_WARNING, target->scsi_host,
+				     PFX "Reducing max_sectors from %d to %d\n",
+				     target->scsi_host->max_sectors,
+				     max_max_sectors);
+			target->scsi_host->max_sectors = max_max_sectors;
+		}
+	}
+
 	target_host->sg_tablesize = target->sg_tablesize;
 	target->mr_pool_size = target->scsi_host->can_queue;
 	target->indirect_size = target->sg_tablesize *
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
