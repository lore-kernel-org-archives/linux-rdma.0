From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/8] i40iw: Fix return codes
Date: Tue, 12 Jul 2016 11:48:39 -0500
Message-ID: <1468342126-29168-2-git-send-email-shiraz.saleem@intel.com>
References: <1468342126-29168-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468342126-29168-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix incorrect usage of ENOSYS and other return codes.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 47 ++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 39096a2..86c387a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -528,7 +528,7 @@ static int i40iw_setup_kmode_qp(struct i40iw_device *iwdev,
 		status = i40iw_get_wqe_shift(rq_size, ukinfo->max_rq_frag_cnt, 0, &rqshift);
 
 	if (status)
-		return -ENOSYS;
+		return -ENOMEM;
 
 	sqdepth = sq_size << sqshift;
 	rqdepth = rq_size << rqshift;
@@ -670,7 +670,7 @@ static struct ib_qp *i40iw_create_qp(struct ib_pd *ibpd,
 	iwqp->ctx_info.qp_compl_ctx = (uintptr_t)qp;
 
 	if (init_attr->qp_type != IB_QPT_RC) {
-		err_code = -ENOSYS;
+		err_code = -EINVAL;
 		goto error;
 	}
 	if (iwdev->push_mode)
@@ -2075,8 +2075,12 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 				ret = ukqp->ops.iw_send(ukqp, &info, ib_wr->ex.invalidate_rkey, false);
 			}
 
-			if (ret)
-				err = -EIO;
+			if (ret) {
+				if (ret == I40IW_ERR_QP_TOOMANY_WRS_POSTED)
+					err = -ENOMEM;
+				else
+					err = -EINVAL;
+			}
 			break;
 		case IB_WR_RDMA_WRITE:
 			info.op_type = I40IW_OP_TYPE_RDMA_WRITE;
@@ -2097,8 +2101,12 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 				ret = ukqp->ops.iw_rdma_write(ukqp, &info, false);
 			}
 
-			if (ret)
-				err = -EIO;
+			if (ret) {
+				if (ret == I40IW_ERR_QP_TOOMANY_WRS_POSTED)
+					err = -ENOMEM;
+				else
+					err = -EINVAL;
+			}
 			break;
 		case IB_WR_RDMA_READ_WITH_INV:
 			inv_stag = true;
@@ -2116,15 +2124,19 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 			info.op.rdma_read.lo_addr.stag = ib_wr->sg_list->lkey;
 			info.op.rdma_read.lo_addr.len = ib_wr->sg_list->length;
 			ret = ukqp->ops.iw_rdma_read(ukqp, &info, inv_stag, false);
-			if (ret)
-				err = -EIO;
+			if (ret) {
+				if (ret == I40IW_ERR_QP_TOOMANY_WRS_POSTED)
+					err = -ENOMEM;
+				else
+					err = -EINVAL;
+			}
 			break;
 		case IB_WR_LOCAL_INV:
 			info.op_type = I40IW_OP_TYPE_INV_STAG;
 			info.op.inv_local_stag.target_stag = ib_wr->ex.invalidate_rkey;
 			ret = ukqp->ops.iw_stag_local_invalidate(ukqp, &info, true);
 			if (ret)
-				err = -EIO;
+				err = -ENOMEM;
 			break;
 		case IB_WR_REG_MR:
 		{
@@ -2153,7 +2165,7 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 
 			ret = dev->iw_priv_qp_ops->iw_mr_fast_register(&iwqp->sc_qp, &info, true);
 			if (ret)
-				err = -EIO;
+				err = -ENOMEM;
 			break;
 		}
 		default:
@@ -2193,6 +2205,7 @@ static int i40iw_post_recv(struct ib_qp *ibqp,
 	struct i40iw_sge sg_list[I40IW_MAX_WQ_FRAGMENT_COUNT];
 	enum i40iw_status_code ret = 0;
 	unsigned long flags;
+	int err = 0;
 
 	iwqp = (struct i40iw_qp *)ibqp;
 	ukqp = &iwqp->sc_qp.qp_uk;
@@ -2207,6 +2220,10 @@ static int i40iw_post_recv(struct ib_qp *ibqp,
 		ret = ukqp->ops.iw_post_receive(ukqp, &post_recv);
 		if (ret) {
 			i40iw_pr_err(" post_recv err %d\n", ret);
+			if (ret == I40IW_ERR_QP_TOOMANY_WRS_POSTED)
+				err = -ENOMEM;
+			else
+				err = -EINVAL;
 			*bad_wr = ib_wr;
 			goto out;
 		}
@@ -2214,9 +2231,7 @@ static int i40iw_post_recv(struct ib_qp *ibqp,
 	}
  out:
 	spin_unlock_irqrestore(&iwqp->lock, flags);
-	if (ret)
-		return -ENOSYS;
-	return 0;
+	return err;
 }
 
 /**
@@ -2513,7 +2528,7 @@ static int i40iw_modify_port(struct ib_device *ibdev,
 			     int port_modify_mask,
 			     struct ib_port_modify *props)
 {
-	return 0;
+	return -ENOSYS;
 }
 
 /**
@@ -2709,7 +2724,7 @@ int i40iw_register_rdma_device(struct i40iw_device *iwdev)
 
 	iwdev->iwibdev = i40iw_init_rdma_device(iwdev);
 	if (!iwdev->iwibdev)
-		return -ENOSYS;
+		return -ENOMEM;
 	iwibdev = iwdev->iwibdev;
 
 	ret = ib_register_device(&iwibdev->ibdev, NULL);
@@ -2734,5 +2749,5 @@ error:
 	kfree(iwdev->iwibdev->ibdev.iwcm);
 	iwdev->iwibdev->ibdev.iwcm = NULL;
 	ib_dealloc_device(&iwdev->iwibdev->ibdev);
-	return -ENOSYS;
+	return ret;
 }
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
