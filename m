From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 09/9] remove redundant locking from iser scsi command
 response flow
Date: Mon, 8 Feb 2010 15:23:11 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002081522410.16288@zuben.voltaire.com>
References: <Pine.LNX.4.64.1002081509400.16288@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002081509400.16288-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

currently iser recv completion flow takes the session lock twice.
optimize it to avoid the first one by letting iser_task_rdma_finalize()
be called only from the cleanup_task callback invoked by iscsi_free_task,
thus reducing the contention on the session lock between the scsi
command submission to the scsi command completion flows.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

---

 drivers/infiniband/ulp/iser/iser_initiator.c |   25 -------------------------
 1 file changed, 25 deletions(-)

Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_initiator.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iser_initiator.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -440,10 +440,7 @@ void iser_rcv_completion(struct iser_rx_
 			 struct iser_conn *ib_conn)
 {
 	struct iscsi_iser_conn *conn = ib_conn->iser_conn;
-	struct iscsi_task *task;
-	struct iscsi_iser_task *iser_task;
 	struct iscsi_hdr *hdr;
-	unsigned char opcode;
 	u64 rx_dma;
 	int rx_buflen, outstanding, count, err;

@@ -464,28 +461,6 @@ void iser_rcv_completion(struct iser_rx_
 	iser_dbg("op 0x%x itt 0x%x dlen %d\n", hdr->opcode,
 			hdr->itt, (int)(rx_xfer_len - ISER_HEADERS_LEN));

-	opcode = hdr->opcode & ISCSI_OPCODE_MASK;
-
-	if (opcode == ISCSI_OP_SCSI_CMD_RSP) {
-		spin_lock(&conn->iscsi_conn->session->lock);
-		task = iscsi_itt_to_ctask(conn->iscsi_conn, hdr->itt);
-		if (task)
-			__iscsi_get_task(task);
-		spin_unlock(&conn->iscsi_conn->session->lock);
-
-		if (!task)
-			iser_err("itt can't be matched to task!!! "
-				 "conn %p opcode %d itt %d\n",
-				 conn->iscsi_conn, opcode, hdr->itt);
-		else {
-			iser_task = task->dd_data;
-			iser_dbg("itt %d task %p\n",hdr->itt, task);
-			iser_task->status = ISER_TASK_STATUS_COMPLETED;
-			iser_task_rdma_finalize(iser_task);
-			iscsi_put_task(task);
-		}
-	}
-
 	iscsi_iser_recv(conn->iscsi_conn, hdr,
 		rx_desc->data, rx_xfer_len - ISER_HEADERS_LEN);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
