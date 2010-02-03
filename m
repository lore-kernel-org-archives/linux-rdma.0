From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 08/9] ib/iser: move to use libiscsi passthrough mode
Date: Wed, 3 Feb 2010 17:41:25 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002031740540.11944@zuben.voltaire.com>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002031721280.11944-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The libiscsi passthrough mode invokes the transport xmit calls directly
without passing through an internal queue, now when the "cant_sleep"
prerequisite of iscsi_alloc_session is met, move to use it. Since the
libibscsi queue isn't used in passthrough mode, the code that schedules
the xmitworker is removed.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    2 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |   12 ------------
 2 files changed, 1 insertion(+), 13 deletions(-)

Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -423,7 +423,7 @@ iscsi_iser_session_create(struct iscsi_e
 	struct Scsi_Host *shost;
 	struct iser_conn *ib_conn;

-	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, 1);
+	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, 0);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_iser_scsi_transport;
Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_initiator.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iser_initiator.c
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_initiator.c
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
