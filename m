From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 08/9] ib/iser: move to use libiscsi passthrough mode
Date: Mon, 8 Feb 2010 15:22:34 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002081521260.16288@zuben.voltaire.com>
References: <Pine.LNX.4.64.1002081509400.16288@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002081509400.16288-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The libiscsi passthrough mode invokes the transport xmit calls directly
without first going through an internal queue as done in the other mode
which uses a queue and a xmitworker thread. Now when the "cant_sleep"
prerequisite of iscsi_host_alloc is met, move to use it. Handling xmit
errors is now done by  the passthrough flow of libiscsi. Since the
queue/worker aren't used in this mode, the code that schedules the
xmitworker is removed.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

---

changes from V1:

- remove calls to iscsi_conn_failure which are under now both buggy and not needed,
- instead, return errors to libiscsi (e.g iscsi_queuecommand, __iscsi_conn_send_pdu)
- enhance/fix few debug prints and the change log

 drivers/infiniband/ulp/iser/iscsi_iser.c     |   11 +++--------
 drivers/infiniband/ulp/iser/iser_initiator.c |   12 ------------
 2 files changed, 3 insertions(+), 20 deletions(-)

Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iscsi_iser.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -190,7 +190,7 @@ iscsi_iser_mtask_xmit(struct iscsi_conn
 {
 	int error = 0;

-	iser_dbg("task deq [cid %d itt 0x%x]\n", conn->id, task->itt);
+	iser_dbg("mtask xmit [cid %d itt 0x%x]\n", conn->id, task->itt);

 	error = iser_send_control(conn, task);

@@ -200,9 +200,6 @@ iscsi_iser_mtask_xmit(struct iscsi_conn
 	 * - if yes, the task is recycled at iscsi_complete_pdu
 	 * - if no,  the task is recycled at iser_snd_completion
 	 */
-	if (error && error != -ENOBUFS)
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-
 	return error;
 }

@@ -254,7 +251,7 @@ iscsi_iser_task_xmit(struct iscsi_task *
 			   task->imm_count, task->unsol_r2t.data_length);
 	}

-	iser_dbg("task deq [cid %d itt 0x%x]\n",
+	iser_dbg("ctask xmit [cid %d itt 0x%x]\n",
 		   conn->id, task->itt);

 	/* Send the cmd PDU */
@@ -270,8 +267,6 @@ iscsi_iser_task_xmit(struct iscsi_task *
 		error = iscsi_iser_task_xmit_unsol_data(conn, task);

  iscsi_iser_task_xmit_exit:
-	if (error && error != -ENOBUFS)
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 	return error;
 }

@@ -423,7 +418,7 @@ iscsi_iser_session_create(struct iscsi_e
 	struct Scsi_Host *shost;
 	struct iser_conn *ib_conn;

-	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, 1);
+	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, 0);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_iser_scsi_transport;
Index: linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_initiator.c
===================================================================
--- linux-2.6.33-rc7.orig/drivers/infiniband/ulp/iser/iser_initiator.c
+++ linux-2.6.33-rc7/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -514,10 +514,7 @@ void iser_rcv_completion(struct iser_rx_
 void iser_snd_completion(struct iser_tx_desc *tx_desc,
 			struct iser_conn *ib_conn)
 {
-	struct iscsi_iser_conn *iser_conn = ib_conn->iser_conn;
-	struct iscsi_conn      *conn = iser_conn->iscsi_conn;
 	struct iscsi_task *task;
-	int resume_tx = 0;
 	struct iser_device *device = ib_conn->device;

 	if (tx_desc->type == ISCSI_TX_DATAOUT) {
@@ -526,17 +523,8 @@ void iser_snd_completion(struct iser_tx_
 		kmem_cache_free(ig.desc_cache, tx_desc);
 	}

-	if (atomic_read(&iser_conn->ib_conn->post_send_buf_count) ==
-	    ISER_QP_MAX_REQ_DTOS)
-		resume_tx = 1;
-
 	atomic_dec(&ib_conn->post_send_buf_count);

-	if (resume_tx) {
-		iser_dbg("%ld resuming tx\n",jiffies);
-		iscsi_conn_queue_work(conn);
-	}
-
 	if (tx_desc->type == ISCSI_TX_CONTROL) {
 		/* this arithmetic is legal by libiscsi dd_data allocation */
 		task = (void *) ((long)(void *)tx_desc -
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
