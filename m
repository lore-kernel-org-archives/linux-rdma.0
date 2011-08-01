From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2 for-3.1] ib/iser: support iSCSI PDU padding
Date: Tue, 2 Aug 2011 00:14:09 +0300
Message-ID: <alpine.LRH.2.00.1108020013210.22153@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1108020010060.22153@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1108020010060.22153-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RFC3270 mandates that iSCSI PDUs are padded to the closest integer
number of four byte words. Enhance the iser code to support that
on both the TX/RX flows.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8db008d..9c61b9c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -101,13 +101,17 @@ iscsi_iser_recv(struct iscsi_conn *conn,

 	/* verify PDU length */
 	datalen = ntoh24(hdr->dlength);
-	if (datalen != rx_data_len) {
-		printk(KERN_ERR "iscsi_iser: datalen %d (hdr) != %d (IB) \n",
-		       datalen, rx_data_len);
+	if (datalen > rx_data_len || (datalen + 4) < rx_data_len) {
+		iser_err("wrong datalen %d (hdr), %d (IB)\n",
+			datalen, rx_data_len);
 		rc = ISCSI_ERR_DATALEN;
 		goto error;
 	}

+	if (datalen != rx_data_len)
+		iser_dbg("aligned datalen (%d) hdr, %d (IB)\n",
+			datalen, rx_data_len);
+
 	/* read AHS */
 	ahslen = hdr->hlength * 4;

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 95a08a8..6ea28a6 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -412,7 +412,7 @@ int iser_send_control(struct iscsi_conn *conn,
 		memcpy(iser_conn->ib_conn->login_buf, task->data,
 							task->data_count);
 		tx_dsg->addr    = iser_conn->ib_conn->login_dma;
-		tx_dsg->length  = data_seg_len;
+		tx_dsg->length  = task->data_count;
 		tx_dsg->lkey    = device->mr->lkey;
 		mdesc->num_sge = 2;
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
