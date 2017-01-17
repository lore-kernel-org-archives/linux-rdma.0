From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCHv2 2/2] IB/iser: remove unused variable from iser_conn struct
Date: Tue, 17 Jan 2017 16:47:26 +0200
Message-ID: <1484664446-15535-2-git-send-email-maxg@mellanox.com>
References: <1484664446-15535-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484664446-15535-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hch-jcswGhMUV9g@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

max_sectors calculation was fixed in commit:
9c674815d346 ("IB/iser: Fix max_sectors calculation").
Thus, iser_conn variable scsi_max_sectors is not needed anymore.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    4 ++++
 drivers/infiniband/ulp/iser/iscsi_iser.h |    2 --
 drivers/infiniband/ulp/iser/iser_verbs.c |   13 +------------
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 1c91187..e71af71 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -672,6 +672,10 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 	max_fr_sectors = ((shost->sg_tablesize - 1) * PAGE_SIZE) >> 9;
 	shost->max_sectors = min(iser_max_sectors, max_fr_sectors);
 
+	iser_dbg("iser_conn %p, sg_tablesize %u, max_sectors %u\n",
+		 iser_conn, shost->sg_tablesize,
+		 shost->max_sectors);
+
 	if (cmds_max > max_cmds) {
 		iser_info("cmds_max changed from %u to %u\n",
 			  cmds_max, max_cmds);
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 0be6a7c..9d0b22a 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -496,7 +496,6 @@ struct ib_conn {
  * @rx_descs:         rx buffers array (cyclic buffer)
  * @num_rx_descs:     number of rx descriptors
  * @scsi_sg_tablesize: scsi host sg_tablesize
- * @scsi_max_sectors: scsi host max sectors
  */
 struct iser_conn {
 	struct ib_conn		     ib_conn;
@@ -519,7 +518,6 @@ struct iser_conn {
 	struct iser_rx_desc	     *rx_descs;
 	u32                          num_rx_descs;
 	unsigned short               scsi_sg_tablesize;
-	unsigned int                 scsi_max_sectors;
 	bool			     snd_w_inv;
 };
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 8ae7a3b..6a9d1cb 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -707,18 +707,7 @@ static void iser_connect_error(struct rdma_cm_id *cma_id)
 	sup_sg_tablesize = min_t(unsigned, ISCSI_ISER_MAX_SG_TABLESIZE,
 				 device->ib_device->attrs.max_fast_reg_page_list_len);
 
-	if (sg_tablesize > sup_sg_tablesize) {
-		sg_tablesize = sup_sg_tablesize;
-		iser_conn->scsi_max_sectors = sg_tablesize * SIZE_4K / 512;
-	} else {
-		iser_conn->scsi_max_sectors = max_sectors;
-	}
-
-	iser_conn->scsi_sg_tablesize = sg_tablesize;
-
-	iser_dbg("iser_conn %p, sg_tablesize %u, max_sectors %u\n",
-		 iser_conn, iser_conn->scsi_sg_tablesize,
-		 iser_conn->scsi_max_sectors);
+	iser_conn->scsi_sg_tablesize = min(sg_tablesize, sup_sg_tablesize);
 }
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
