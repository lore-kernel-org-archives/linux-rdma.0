From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCHv3 1/2] IB/iser: Fix sg_tablesize calculation
Date: Wed, 18 Jan 2017 00:40:39 +0200
Message-ID: <1484692840-12400-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For devices that can register page list that is bigger than
USHRT_MAX, we actually take the wrong value for sg_tablesize.
E.g: for CX4 max_fast_reg_page_list_len is 65536 (bigger than USHRT_MAX)
so we set sg_tablesize to 0 by mistake. Therefore, each IO that is
bigger than 4k splitted to "< 4k" chunks that cause performance degredation.
Remove wrong sg_tablesize assignment, and use the value that was set during
address resolution handler with the needed casting.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.5+
Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
Changes since v2:
 - remove "Fixes" statement

Changes since v1:
 - update "Fixes" statement
 - use sg_tablesize assignment from iser_calc_scsi_params()
 - add patch 2/2 to remove unneeded variable
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 9104e6b..1c91187 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -651,13 +651,6 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 						   SHOST_DIX_GUARD_CRC);
 		}
 
-		/*
-		 * Limit the sg_tablesize and max_sectors based on the device
-		 * max fastreg page list length.
-		 */
-		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
-			ib_conn->device->ib_device->attrs.max_fast_reg_page_list_len);
-
 		if (iscsi_host_add(shost,
 				   ib_conn->device->ib_device->dma_device)) {
 			mutex_unlock(&iser_conn->state_mutex);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
