From: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/iser: extended CDB support
Date: Wed, 23 Nov 2016 10:52:19 +0200
Message-ID: <1479891139-15604-1-git-send-email-vladimirn@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Support of vendor specific CDBs in iser. SCSI supports max command size
SCSI_MAX_VARLEN_CDB_SIZE (260 bytes). ISER currently supports max scsi
command 16 bytes. This commit changes max scsi command for ISER
(to align with iscsi/tcp) to SCSI_MAX_VARLEN_CDB_SIZE.

Signed-off-by: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 17 +++++++++++++----
 drivers/infiniband/ulp/iser/iscsi_iser.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 64b3d11..865ce48 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -163,7 +163,8 @@ iscsi_iser_pdu_alloc(struct iscsi_task *task, uint8_t opcode)
 	struct iscsi_iser_task *iser_task = task->dd_data;
 
 	task->hdr = (struct iscsi_hdr *)&iser_task->desc.iscsi_header;
-	task->hdr_max = sizeof(iser_task->desc.iscsi_header);
+	task->hdr_max = sizeof(iser_task->desc.iscsi_header) + 
+			sizeof(iser_task->desc.iscsi_ecdb_header);
 
 	return 0;
 }
@@ -189,6 +190,14 @@ iser_initialize_task_headers(struct iscsi_task *task,
 	u64 dma_addr;
 	const bool mgmt_task = !task->sc && !in_interrupt();
 	int ret = 0;
+	int headers_len = ISER_HEADERS_LEN;
+	struct scsi_cmnd *sc = task->sc;
+
+	if(sc) {
+		if(sc->cmd_len > ISCSI_CDB_SIZE)
+			headers_len += offsetof(struct iscsi_ecdb_ahdr, ecdb) + 
+					(sc->cmd_len - ISCSI_CDB_SIZE);
+	}
 
 	if (unlikely(mgmt_task))
 		mutex_lock(&iser_conn->state_mutex);
@@ -199,7 +208,7 @@ iser_initialize_task_headers(struct iscsi_task *task,
 	}
 
 	dma_addr = ib_dma_map_single(device->ib_device, (void *)tx_desc,
-				ISER_HEADERS_LEN, DMA_TO_DEVICE);
+				headers_len, DMA_TO_DEVICE );
 	if (ib_dma_mapping_error(device->ib_device, dma_addr)) {
 		ret = -ENOMEM;
 		goto out;
@@ -209,7 +218,7 @@ iser_initialize_task_headers(struct iscsi_task *task,
 	tx_desc->mapped = true;
 	tx_desc->dma_addr = dma_addr;
 	tx_desc->tx_sg[0].addr   = tx_desc->dma_addr;
-	tx_desc->tx_sg[0].length = ISER_HEADERS_LEN;
+	tx_desc->tx_sg[0].length = headers_len;
 	tx_desc->tx_sg[0].lkey   = device->pd->local_dma_lkey;
 
 	iser_task->iser_conn = iser_conn;
@@ -623,7 +632,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	shost->max_lun = iscsi_max_lun;
 	shost->max_id = 0;
 	shost->max_channel = 0;
-	shost->max_cmd_len = 16;
+	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
 	/*
 	 * older userspace tools (before 2.0-870) did not pass us
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 0be6a7c..e1ae9b8 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -254,6 +254,7 @@ enum iser_desc_type {
 struct iser_tx_desc {
 	struct iser_ctrl             iser_header;
 	struct iscsi_hdr             iscsi_header;
+	struct iscsi_ecdb_ahdr       iscsi_ecdb_header;
 	enum   iser_desc_type        type;
 	u64		             dma_addr;
 	struct ib_sge		     tx_sg[2];
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
