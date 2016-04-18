From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH] IB/iser: fix max_sectors calculation
Date: Mon, 18 Apr 2016 17:06:28 -0400
Message-ID: <1461013588-8825-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

iSER currently has a couple places that set max_sectors in either the host
template or SCSI host, and all of them get it wrong.

This patch instead uses a single assignment that (hopefully) gets it right:
the max_sectors value must be derived from the number of segments in the
FR or FRM structure, but actually be one lower than the page size multiplied
by the number of sectors, as it has to handle the case of non-aligned I/O.

Without this I get trivivial to reproduce hangs when running xfstests
(on XFS) over iSER to Linux targets.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 80b6bed..64b3d11 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -612,6 +612,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	struct Scsi_Host *shost;
 	struct iser_conn *iser_conn = NULL;
 	struct ib_conn *ib_conn;
+	u32 max_fr_sectors;
 	u16 max_cmds;
 
 	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, 0);
@@ -632,7 +633,6 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		iser_conn = ep->dd_data;
 		max_cmds = iser_conn->max_cmds;
 		shost->sg_tablesize = iser_conn->scsi_sg_tablesize;
-		shost->max_sectors = iser_conn->scsi_max_sectors;
 
 		mutex_lock(&iser_conn->state_mutex);
 		if (iser_conn->state != ISER_CONN_UP) {
@@ -657,8 +657,6 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		 */
 		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
 			ib_conn->device->ib_device->attrs.max_fast_reg_page_list_len);
-		shost->max_sectors = min_t(unsigned int,
-			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
 
 		if (iscsi_host_add(shost,
 				   ib_conn->device->ib_device->dma_device)) {
@@ -672,6 +670,15 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 			goto free_host;
 	}
 
+	/*
+	 * FRs or FMRs can only map up to a (device) page per entry, but if the
+	 * first entry is misaligned we'll end up using using two entries
+	 * (head and tail) for a single page worth data, so we have to drop
+	 * one segment from the calculation.
+	 */
+	max_fr_sectors = ((shost->sg_tablesize - 1) * PAGE_SIZE) >> 9;
+	shost->max_sectors = min(iser_max_sectors, max_fr_sectors);
+
 	if (cmds_max > max_cmds) {
 		iser_info("cmds_max changed from %u to %u\n",
 			  cmds_max, max_cmds);
@@ -989,7 +996,6 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= scsi_change_queue_depth,
 	.sg_tablesize           = ISCSI_ISER_DEF_SG_TABLESIZE,
-	.max_sectors            = ISER_DEF_MAX_SECTORS,
 	.cmd_per_lun            = ISER_DEF_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
