From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 07/9] ib/iser: remove unnecessary connection checks
Date: Wed, 3 Feb 2010 17:40:42 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002031739440.11944@zuben.voltaire.com>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002031721280.11944-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

remove unnecessary checks for the IB connection state and for QP
overflow, as conn state changes are reported by iser to libiscsi
and handled there. QP overflow is theoretically possible only when
unsolicited data-outs are used, its being checked and handled
by HW drivers.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    3 --
 drivers/infiniband/ulp/iser/iser_initiator.c |   38 ---------------------------
 drivers/infiniband/ulp/iser/iser_verbs.c     |   11 -------
 3 files changed, 52 deletions(-)

Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_initiator.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iser_initiator.c
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -260,20 +260,6 @@ int iser_conn_set_full_featured_mode(str
 	return 0;
 }

-static int
-iser_check_xmit(struct iscsi_conn *conn, void *task)
-{
-	struct iscsi_iser_conn *iser_conn = conn->dd_data;
-
-	if (atomic_read(&iser_conn->ib_conn->post_send_buf_count) ==
-	    ISER_QP_MAX_REQ_DTOS) {
-		iser_dbg("%ld can't xmit task %p\n",jiffies,task);
-		return -ENOBUFS;
-	}
-	return 0;
-}
-
-
 /**
  * iser_send_command - send command PDU
  */
@@ -289,13 +275,6 @@ int iser_send_command(struct iscsi_conn
 	struct scsi_cmnd *sc  =  task->sc;
 	struct iser_tx_desc *tx_desc = &iser_task->desc;

-	if (!iser_conn_state_comp(iser_conn->ib_conn, ISER_CONN_UP)) {
-		iser_err("Failed to send, conn: 0x%p is not up\n", iser_conn->ib_conn);
-		return -EPERM;
-	}
-	if (iser_check_xmit(conn, task))
-		return -ENOBUFS;
-
 	edtl = ntohl(hdr->data_length);

 	/* build the tx desc regd header and add it to the tx desc dto */
@@ -357,15 +336,6 @@ int iser_send_data_out(struct iscsi_conn
 	int err = 0;
 	struct ib_sge *tx_dsg;

-
-	if (!iser_conn_state_comp(iser_conn->ib_conn, ISER_CONN_UP)) {
-		iser_err("Failed to send, conn: 0x%p is not up\n", iser_conn->ib_conn);
-		return -EPERM;
-	}
-
-	if (iser_check_xmit(conn, task))
-		return -ENOBUFS;
-
 	itt = (__force uint32_t)hdr->itt;
 	data_seg_len = ntoh24(hdr->dlength);
 	buf_offset   = ntohl(hdr->offset);
@@ -425,14 +395,6 @@ int iser_send_control(struct iscsi_conn
 	int err = 0;
 	struct iser_device *device;

-	if (!iser_conn_state_comp(iser_conn->ib_conn, ISER_CONN_UP)) {
-		iser_err("Failed to send, conn: 0x%p is not up\n", iser_conn->ib_conn);
-		return -EPERM;
-	}
-
-	if (iser_check_xmit(conn, task))
-		return -ENOBUFS;
-
 	/* build the tx desc regd header and add it to the tx desc dto */
 	mdesc->type = ISCSI_TX_CONTROL;
 	iser_create_send_desc(iser_conn->ib_conn, mdesc);
Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.h
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -357,9 +357,6 @@ int  iser_post_recvl(struct iser_conn *i
 int  iser_post_recvm(struct iser_conn *ib_conn, int count);
 int  iser_post_send(struct iser_conn *ib_conn, struct iser_tx_desc *tx_desc);

-int iser_conn_state_comp(struct iser_conn *ib_conn,
-			 enum iser_ib_conn_state comp);
-
 int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 			    struct iser_data_buf       *data,
 			    enum   iser_data_dir       iser_dir,
Index: linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_verbs.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-2.6.33-rc4/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -300,17 +300,6 @@ static void iser_device_try_release(stru
 	mutex_unlock(&ig.device_list_mutex);
 }

-int iser_conn_state_comp(struct iser_conn *ib_conn,
-			enum iser_ib_conn_state comp)
-{
-	int ret;
-
-	spin_lock_bh(&ib_conn->lock);
-	ret = (ib_conn->state == comp);
-	spin_unlock_bh(&ib_conn->lock);
-	return ret;
-}
-
 static int iser_conn_state_comp_exch(struct iser_conn *ib_conn,
 				     enum iser_ib_conn_state comp,
 				     enum iser_ib_conn_state exch)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
