From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Remove workaround for pre-production errata
Date: Wed, 19 Oct 2016 15:33:32 -0500
Message-ID: <20161019203332.7972-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pre-production silicon incorrectly truncates 4 bytes of the MPA
packet in UDP loopback case. Remove the workaround as it is no
longer necessary.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c    | 26 +++-----------------------
 drivers/infiniband/hw/i40iw/i40iw_cm.h    |  2 --
 drivers/infiniband/hw/i40iw/i40iw_utils.c |  2 +-
 3 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 460a367..e202ff0 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -361,15 +361,6 @@ static void i40iw_cleanup_retrans_entry(struct i40iw_cm_node *cm_node)
 	spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
 }
 
-static bool is_remote_ne020_or_chelsio(struct i40iw_cm_node *cm_node)
-{
-	if ((cm_node->rem_mac[0] == 0x0) &&
-	    (((cm_node->rem_mac[1] == 0x12) && (cm_node->rem_mac[2] == 0x55)) ||
-	     ((cm_node->rem_mac[1] == 0x07 && (cm_node->rem_mac[2] == 0x43)))))
-		return true;
-	return false;
-}
-
 /**
  * i40iw_form_cm_frame - get a free packet and build frame
  * @cm_node: connection's node ionfo to use in frame
@@ -410,11 +401,8 @@ static struct i40iw_puda_buf *i40iw_form_cm_frame(struct i40iw_cm_node *cm_node,
 	if (hdr)
 		hdr_len = hdr->size;
 
-	if (pdata) {
+	if (pdata)
 		pd_len = pdata->size;
-		if (!is_remote_ne020_or_chelsio(cm_node))
-			pd_len += MPA_ZERO_PAD_LEN;
-	}
 
 	if (cm_node->vlan_id < VLAN_TAG_PRESENT)
 		eth_hlen += 4;
@@ -3604,7 +3592,7 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	iwqp->cm_node = (void *)cm_node;
 	cm_node->iwqp = iwqp;
 
-	buf_len = conn_param->private_data_len + I40IW_MAX_IETF_SIZE + MPA_ZERO_PAD_LEN;
+	buf_len = conn_param->private_data_len + I40IW_MAX_IETF_SIZE;
 
 	status = i40iw_allocate_dma_mem(dev->hw, &iwqp->ietf_mem, buf_len, 1);
 
@@ -3638,18 +3626,10 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		iwqp->lsmm_mr = ibmr;
 		if (iwqp->page)
 			iwqp->sc_qp.qp_uk.sq_base = kmap(iwqp->page);
-		if (is_remote_ne020_or_chelsio(cm_node))
-			dev->iw_priv_qp_ops->qp_send_lsmm(
-							&iwqp->sc_qp,
+		dev->iw_priv_qp_ops->qp_send_lsmm(&iwqp->sc_qp,
 							iwqp->ietf_mem.va,
 							(accept.size + conn_param->private_data_len),
 							ibmr->lkey);
-		else
-			dev->iw_priv_qp_ops->qp_send_lsmm(
-							&iwqp->sc_qp,
-							iwqp->ietf_mem.va,
-							(accept.size + conn_param->private_data_len + MPA_ZERO_PAD_LEN),
-							ibmr->lkey);
 
 	} else {
 		if (iwqp->page)
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.h b/drivers/infiniband/hw/i40iw/i40iw_cm.h
index 945ed26..24615c2 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.h
@@ -56,8 +56,6 @@
 
 #define I40IW_MAX_IETF_SIZE      32
 
-#define MPA_ZERO_PAD_LEN	4
-
 /* IETF RTR MSG Fields               */
 #define IETF_PEER_TO_PEER       0x8000
 #define IETF_FLPDU_ZERO_LEN     0x4000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 218e9fd..805603b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -1250,7 +1250,7 @@ enum i40iw_status_code i40iw_puda_get_tcpip_info(struct i40iw_puda_completion_in
 
 	buf->totallen = pkt_len + buf->maclen;
 
-	if (info->payload_len < buf->totallen - 4) {
+	if (info->payload_len < buf->totallen) {
 		i40iw_pr_err("payload_len = 0x%x totallen expected0x%x\n",
 			     info->payload_len, buf->totallen);
 		return I40IW_ERR_INVALID_SIZE;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
