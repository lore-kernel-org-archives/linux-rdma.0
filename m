From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-rc 1/2] RDMA/qedr: Parse VLAN ID correctly and ignore the value of zero
Date: Tue, 3 Oct 2017 14:47:26 +0300
Message-ID: <1507031247-7972-2-git-send-email-Ram.Amrani@cavium.com>
References: <1507031247-7972-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507031247-7972-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rename vlan_id field name to vlan as it contains more than the vlan_id.
Mask out non vlan id fields from vlan tag of the QED LL2 RX GSI
vlan output. As it is expected to be vlan id only.
Ignore vlan_id with value of zero.

Fixes: abd49676c707 ("qed: Add RoCE ll2 & GSI support")
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

---
 drivers/infiniband/hw/qedr/qedr.h    |  2 +-
 drivers/infiniband/hw/qedr/qedr_cm.c | 10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index b2bb42e..254083b 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -387,7 +387,7 @@ struct qedr_qp {
 		u8 wqe_size;
 
 		u8 smac[ETH_ALEN];
-		u16 vlan_id;
+		u16 vlan;
 		int rc;
 	} *rqe_wr_id;
 
diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw/qedr/qedr_cm.c
index 4689e80..5ebbe49 100644
--- a/drivers/infiniband/hw/qedr/qedr_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_cm.c
@@ -105,7 +105,7 @@ void qedr_ll2_complete_rx_packet(void *cxt,
 
 	qp->rqe_wr_id[qp->rq.gsi_cons].rc = data->u.data_length_error ?
 		-EINVAL : 0;
-	qp->rqe_wr_id[qp->rq.gsi_cons].vlan_id = data->vlan;
+	qp->rqe_wr_id[qp->rq.gsi_cons].vlan = data->vlan;
 	/* note: length stands for data length i.e. GRH is excluded */
 	qp->rqe_wr_id[qp->rq.gsi_cons].sg_list[0].length =
 		data->length.data_length;
@@ -694,6 +694,7 @@ int qedr_gsi_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 	struct qedr_cq *cq = get_qedr_cq(ibcq);
 	struct qedr_qp *qp = dev->gsi_qp;
 	unsigned long flags;
+	u16 vlan_id;
 	int i = 0;
 
 	spin_lock_irqsave(&cq->cq_lock, flags);
@@ -712,9 +713,12 @@ int qedr_gsi_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 		wc[i].wc_flags |= IB_WC_GRH | IB_WC_IP_CSUM_OK;
 		ether_addr_copy(wc[i].smac, qp->rqe_wr_id[qp->rq.cons].smac);
 		wc[i].wc_flags |= IB_WC_WITH_SMAC;
-		if (qp->rqe_wr_id[qp->rq.cons].vlan_id) {
+
+		vlan_id = qp->rqe_wr_id[qp->rq.cons].vlan &
+			  VLAN_VID_MASK;
+		if (vlan_id) {
 			wc[i].wc_flags |= IB_WC_WITH_VLAN;
-			wc[i].vlan_id = qp->rqe_wr_id[qp->rq.cons].vlan_id;
+			wc[i].vlan_id = vlan_id;
 		}
 
 		qedr_inc_sw_cons(&qp->rq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
