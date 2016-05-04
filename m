From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 6/9] RDMA/iw_cxgb4: remove abort_connection() usage from accept/reject
Date: Thu,  5 May 2016 01:27:34 +0530
Message-ID: <1462391857-20939-7-git-send-email-hariprasad@chelsio.com>
References: <1462391857-20939-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462391857-20939-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use c4iw_ep_disconnect() instead. This is part of getting rid of
abort_connection() altogether so we properly clean up on send_abort()
failures.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 864da9dec9f6..d862369b5dd7 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2922,14 +2922,14 @@ int c4iw_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 	set_bit(ULP_REJECT, &ep->com.history);
 	BUG_ON(ep->com.state != MPA_REQ_RCVD);
 	if (mpa_rev == 0)
-		abort_connection(ep, NULL, GFP_KERNEL);
+		disconnect = 2;
 	else {
 		err = send_mpa_reject(ep, pdata, pdata_len);
 		disconnect = 1;
 	}
 	mutex_unlock(&ep->com.mutex);
 	if (disconnect)
-		err = c4iw_ep_disconnect(ep, 0, GFP_KERNEL);
+		err = c4iw_ep_disconnect(ep, disconnect == 2, GFP_KERNEL);
 	c4iw_put_ep(&ep->com);
 	return 0;
 }
@@ -2942,13 +2942,14 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct c4iw_ep *ep = to_ep(cm_id);
 	struct c4iw_dev *h = to_c4iw_dev(cm_id->device);
 	struct c4iw_qp *qp = get_qhp(h, conn_param->qpn);
+	int abort = 0;
 
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 
 	mutex_lock(&ep->com.mutex);
 	if (ep->com.state == DEAD) {
 		err = -ECONNRESET;
-		goto err;
+		goto err_out;
 	}
 
 	BUG_ON(ep->com.state != MPA_REQ_RCVD);
@@ -2957,9 +2958,8 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	set_bit(ULP_ACCEPT, &ep->com.history);
 	if ((conn_param->ord > cur_max_read_depth(ep->com.dev)) ||
 	    (conn_param->ird > cur_max_read_depth(ep->com.dev))) {
-		abort_connection(ep, NULL, GFP_KERNEL);
 		err = -EINVAL;
-		goto err;
+		goto err_abort;
 	}
 
 	if (ep->mpa_attr.version == 2 && ep->mpa_attr.enhanced_rdma_conn) {
@@ -2971,9 +2971,8 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 				ep->ord = conn_param->ord;
 				send_mpa_reject(ep, conn_param->private_data,
 						conn_param->private_data_len);
-				abort_connection(ep, NULL, GFP_KERNEL);
 				err = -ENOMEM;
-				goto err;
+				goto err_abort;
 			}
 		}
 		if (conn_param->ird < ep->ord) {
@@ -2981,9 +2980,8 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 			    ep->ord <= h->rdev.lldi.max_ordird_qp) {
 				conn_param->ird = ep->ord;
 			} else {
-				abort_connection(ep, NULL, GFP_KERNEL);
 				err = -ENOMEM;
-				goto err;
+				goto err_abort;
 			}
 		}
 	}
@@ -3024,23 +3022,26 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	err = c4iw_modify_qp(ep->com.qp->rhp,
 			     ep->com.qp, mask, &attrs, 1);
 	if (err)
-		goto err1;
+		goto err_deref_cm_id;
 	err = send_mpa_reply(ep, conn_param->private_data,
 			     conn_param->private_data_len);
 	if (err)
-		goto err1;
+		goto err_deref_cm_id;
 
 	__state_set(&ep->com, FPDU_MODE);
 	established_upcall(ep);
 	mutex_unlock(&ep->com.mutex);
 	c4iw_put_ep(&ep->com);
 	return 0;
-err1:
+err_deref_cm_id:
 	ep->com.cm_id = NULL;
-	abort_connection(ep, NULL, GFP_KERNEL);
 	cm_id->rem_ref(cm_id);
-err:
+err_abort:
+	abort = 1;
+err_out:
 	mutex_unlock(&ep->com.mutex);
+	if (abort)
+		c4iw_ep_disconnect(ep, 1, GFP_KERNEL);
 	c4iw_put_ep(&ep->com);
 	return err;
 }
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
