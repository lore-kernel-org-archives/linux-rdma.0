From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 07/12] i40iw: Move ceq_valid to i40iw_sc_dev structure
Date: Mon, 16 Oct 2017 15:46:00 -0500
Message-ID: <20171016204605.37512-8-shiraz.saleem@intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Completion Event Queues are created and destroyed on
a per device basis as opposed to per User-space Direct
Access resource.

Move ceq_valid to the correct place in i40iw_sc_dev
from i40iw_puda_rsrc.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 19 ++++++++++---------
 drivers/infiniband/hw/i40iw/i40iw_puda.c |  9 ++++-----
 drivers/infiniband/hw/i40iw/i40iw_puda.h |  2 --
 drivers/infiniband/hw/i40iw/i40iw_type.h |  1 +
 4 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 438f526..dc6b3387 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -353,6 +353,8 @@ static void i40iw_dele_ceqs(struct i40iw_device *iwdev)
 		i40iw_disable_irq(dev, msix_vec, (void *)iwceq);
 		i40iw_destroy_ceq(iwdev, iwceq);
 	}
+
+	iwdev->sc_dev.ceq_valid = false;
 }
 
 /**
@@ -810,17 +812,16 @@ static enum i40iw_status_code i40iw_setup_ceqs(struct i40iw_device *iwdev,
 		i40iw_enable_intr(&iwdev->sc_dev, msix_vec->idx);
 		iwdev->ceqs_count++;
 	}
-
 exit:
-	if (status) {
-		if (!iwdev->ceqs_count) {
-			kfree(iwdev->ceqlist);
-			iwdev->ceqlist = NULL;
-		} else {
-			status = 0;
-		}
+	if (status && !iwdev->ceqs_count) {
+		kfree(iwdev->ceqlist);
+		iwdev->ceqlist = NULL;
+		return status;
+	} else {
+		iwdev->sc_dev.ceq_valid = true;
+		return 0;
 	}
-	return status;
+
 }
 
 /**
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index 875898b..71914b3 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -614,7 +614,7 @@ static enum i40iw_status_code i40iw_puda_qp_create(struct i40iw_puda_rsrc *rsrc)
 	qp->user_pri = 0;
 	i40iw_qp_add_qos(qp);
 	i40iw_puda_qp_setctx(rsrc);
-	if (rsrc->ceq_valid)
+	if (rsrc->dev->ceq_valid)
 		ret = i40iw_cqp_qp_create_cmd(rsrc->dev, qp);
 	else
 		ret = i40iw_puda_qp_wqe(rsrc->dev, qp);
@@ -707,7 +707,7 @@ static enum i40iw_status_code i40iw_puda_cq_create(struct i40iw_puda_rsrc *rsrc)
 	ret = dev->iw_priv_cq_ops->cq_init(cq, &info);
 	if (ret)
 		goto error;
-	if (rsrc->ceq_valid)
+	if (rsrc->dev->ceq_valid)
 		ret = i40iw_cqp_cq_create_cmd(dev, cq);
 	else
 		ret = i40iw_puda_cq_wqe(dev, cq);
@@ -727,7 +727,7 @@ static void i40iw_puda_free_qp(struct i40iw_puda_rsrc *rsrc)
 	struct i40iw_ccq_cqe_info compl_info;
 	struct i40iw_sc_dev *dev = rsrc->dev;
 
-	if (rsrc->ceq_valid) {
+	if (rsrc->dev->ceq_valid) {
 		i40iw_cqp_qp_destroy_cmd(dev, &rsrc->qp);
 		return;
 	}
@@ -760,7 +760,7 @@ static void i40iw_puda_free_cq(struct i40iw_puda_rsrc *rsrc)
 	struct i40iw_ccq_cqe_info compl_info;
 	struct i40iw_sc_dev *dev = rsrc->dev;
 
-	if (rsrc->ceq_valid) {
+	if (rsrc->dev->ceq_valid) {
 		i40iw_cqp_cq_destroy_cmd(dev, &rsrc->cq);
 		return;
 	}
@@ -925,7 +925,6 @@ enum i40iw_status_code i40iw_puda_create_rsrc(struct i40iw_sc_vsi *vsi,
 		rsrc->xmit_complete = i40iw_ieq_tx_compl;
 	}
 
-	rsrc->ceq_valid = info->ceq_valid;
 	rsrc->type = info->type;
 	rsrc->sq_wrtrk_array = (struct i40iw_sq_uk_wr_trk_info *)((u8 *)vmem->va + pudasize);
 	rsrc->rq_wrid_array = (u64 *)((u8 *)vmem->va + pudasize + sqwridsize);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.h b/drivers/infiniband/hw/i40iw/i40iw_puda.h
index dba05ce..660aa3e 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.h
@@ -100,7 +100,6 @@ struct i40iw_puda_rsrc_info {
 	enum puda_resource_type type;	/* ILQ or IEQ */
 	u32 count;
 	u16 pd_id;
-	bool ceq_valid;
 	u32 cq_id;
 	u32 qp_id;
 	u32 sq_size;
@@ -125,7 +124,6 @@ struct i40iw_puda_rsrc {
 	enum puda_resource_type type;
 	u16 buf_size;		/*buffer must be max datalen + tcpip hdr + mac */
 	u16 mss;
-	bool ceq_valid;
 	u32 cq_id;
 	u32 qp_id;
 	u32 sq_size;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index fb20d91..2a4c5a7 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -504,6 +504,7 @@ struct i40iw_sc_dev {
 	u8 hmc_fn_id;
 	bool is_pf;
 	bool vchnl_up;
+	bool ceq_valid;
 	u8 vf_id;
 	wait_queue_head_t vf_reqs;
 	u64 cqp_cmd_stats[OP_SIZE_CQP_STAT_ARRAY];
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
