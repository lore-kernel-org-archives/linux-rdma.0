From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 6/8] IB/srp: Use the IB_DEVICE_SG_GAPS_REG HCA feature if supported
Date: Fri, 10 Feb 2017 15:56:09 -0800
Message-ID: <20170210235611.3243-7-bart.vanassche@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170210235611.3243-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a HCA supports the SG_GAPS_REG feature then a single memory
region of type IB_MR_TYPE_SG_GAPS is sufficient. This patch
reduces the number of memory regions that is allocated per SRP
session.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 43 ++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 87efb702b1c6..2f85255d2aca 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3356,25 +3356,34 @@ static ssize_t srp_create_target(struct device *dev,
 	}
 
 	if (srp_dev->use_fast_reg || srp_dev->use_fmr) {
-		/*
-		 * FR and FMR can only map one HCA page per entry. If the
-		 * start address is not aligned on a HCA page boundary two
-		 * entries will be used for the head and the tail although
-		 * these two entries combined contain at most one HCA page of
-		 * data. Hence the "+ 1" in the calculation below.
-		 *
-		 * The indirect data buffer descriptor is contiguous so the
-		 * memory for that buffer will only be registered if
-		 * register_always is true. Hence add one to mr_per_cmd if
-		 * register_always has been set.
-		 */
+		bool gaps_reg = (ibdev->attrs.device_cap_flags &
+				 IB_DEVICE_SG_GAPS_REG);
+
 		max_sectors_per_mr = srp_dev->max_pages_per_mr <<
 				  (ilog2(srp_dev->mr_page_size) - 9);
-		mr_per_cmd = register_always +
-			(target->scsi_host->max_sectors + 1 +
-			 max_sectors_per_mr - 1) / max_sectors_per_mr;
-		pr_debug("max_sectors = %u; max_pages_per_mr = %u; mr_page_size = %u; max_sectors_per_mr = %u; mr_per_cmd = %u\n",
-			 target->scsi_host->max_sectors,
+		if (!gaps_reg) {
+			/*
+			 * FR and FMR can only map one HCA page per entry. If
+			 * the start address is not aligned on a HCA page
+			 * boundary two entries will be used for the head and
+			 * the tail although these two entries combined
+			 * contain at most one HCA page of data. Hence the "+
+			 * 1" in the calculation below.
+			 *
+			 * The indirect data buffer descriptor is contiguous
+			 * so the memory for that buffer will only be
+			 * registered if register_always is true. Hence add
+			 * one to mr_per_cmd if register_always has been set.
+			 */
+			mr_per_cmd = register_always +
+				(target->scsi_host->max_sectors + 1 +
+				 max_sectors_per_mr - 1) / max_sectors_per_mr;
+			mr_per_cmd = max(2U, mr_per_cmd);
+		} else {
+			mr_per_cmd = 1;
+		}
+		pr_debug("IB_DEVICE_SG_GAPS_REG = %d; max_sectors = %u; max_pages_per_mr = %u; mr_page_size = %u; max_sectors_per_mr = %u; mr_per_cmd = %u\n",
+			 gaps_reg, target->scsi_host->max_sectors,
 			 srp_dev->max_pages_per_mr, srp_dev->mr_page_size,
 			 max_sectors_per_mr, mr_per_cmd);
 	}
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
