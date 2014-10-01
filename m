From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 16/21] IB/iser: Suppress scsi command send completions
Date: Wed,  1 Oct 2014 14:02:12 +0300
Message-ID: <1412161337-25285-17-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Singal completion of every 32 scsi commands and suppress
all the rest. We don't do anything upon getting the completion
so no need to "just consume" it, Cleanup of scsi command is done
in cleanup_task callback.

Still keep dataout and control send completions as we may need to
cleanup there. This helps reducing the amount of interrupts/completions
in the IO path.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    5 +++--
 drivers/infiniband/ulp/iser/iser_initiator.c |   13 ++++++++++---
 drivers/infiniband/ulp/iser/iser_verbs.c     |    5 +++--
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 6c3743b..f4e9d62 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -101,7 +101,6 @@
 #define SHIFT_4K	12
 #define SIZE_4K	(1ULL << SHIFT_4K)
 #define MASK_4K	(~(SIZE_4K-1))
-
 					/* support up to 512KB in one RDMA */
 #define ISCSI_ISER_SG_TABLESIZE         (0x80000 >> SHIFT_4K)
 #define ISER_DEF_XMIT_CMDS_DEFAULT		512
@@ -146,6 +145,7 @@
 					ISER_MAX_RX_MISC_PDUS)
 
 #define ISER_WC_BATCH_COUNT   16
+#define ISER_SIGNAL_CMD_COUNT 32
 
 #define ISER_VER			0x10
 #define ISER_WSV			0x08
@@ -500,7 +500,8 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 int  iser_post_recvl(struct iser_conn *iser_conn);
 int  iser_post_recvm(struct iser_conn *iser_conn, int count);
-int  iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc);
+int  iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc,
+		    bool signal);
 
 int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 			    struct iser_data_buf       *data,
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index ffbdf92..5a489ea 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -369,6 +369,11 @@ static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
 	return 0;
 }
 
+static inline bool iser_signal_comp(int sig_count)
+{
+	return ((sig_count % ISER_SIGNAL_CMD_COUNT) == 0);
+}
+
 /**
  * iser_send_command - send command PDU
  */
@@ -383,6 +388,7 @@ int iser_send_command(struct iscsi_conn *conn,
 	struct iscsi_scsi_req *hdr = (struct iscsi_scsi_req *)task->hdr;
 	struct scsi_cmnd *sc  =  task->sc;
 	struct iser_tx_desc *tx_desc = &iser_task->desc;
+	static unsigned sig_count;
 
 	edtl = ntohl(hdr->data_length);
 
@@ -428,7 +434,8 @@ int iser_send_command(struct iscsi_conn *conn,
 
 	iser_task->status = ISER_TASK_STATUS_STARTED;
 
-	err = iser_post_send(&iser_conn->ib_conn, tx_desc);
+	err = iser_post_send(&iser_conn->ib_conn, tx_desc,
+			     iser_signal_comp(++sig_count));
 	if (!err)
 		return 0;
 
@@ -493,7 +500,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 		 itt, buf_offset, data_seg_len);
 
 
-	err = iser_post_send(&iser_conn->ib_conn, tx_desc);
+	err = iser_post_send(&iser_conn->ib_conn, tx_desc, true);
 	if (!err)
 		return 0;
 
@@ -555,7 +562,7 @@ int iser_send_control(struct iscsi_conn *conn,
 			goto send_control_error;
 	}
 
-	err = iser_post_send(&iser_conn->ib_conn, mdesc);
+	err = iser_post_send(&iser_conn->ib_conn, mdesc, true);
 	if (!err)
 		return 0;
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 82bedbc..67225bb 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1099,7 +1099,8 @@ int iser_post_recvm(struct iser_conn *iser_conn, int count)
  *
  * returns 0 on success, -1 on failure
  */
-int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc)
+int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc,
+		   bool signal)
 {
 	int		  ib_ret;
 	struct ib_send_wr send_wr, *send_wr_failed;
@@ -1113,7 +1114,7 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc)
 	send_wr.sg_list	   = tx_desc->tx_sg;
 	send_wr.num_sge	   = tx_desc->num_sge;
 	send_wr.opcode	   = IB_WR_SEND;
-	send_wr.send_flags = IB_SEND_SIGNALED;
+	send_wr.send_flags = signal ? IB_SEND_SIGNALED : 0;
 
 	ib_ret = ib_post_send(ib_conn->qp, &send_wr, &send_wr_failed);
 	if (ib_ret)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
